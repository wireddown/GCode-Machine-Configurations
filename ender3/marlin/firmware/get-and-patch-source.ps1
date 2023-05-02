# Usage
#  PS> Unblock-File .\get-and-patch-source.ps
#  PS> .\get-and-patch-source.ps


# Settings

# Select the latest bugfix branch from the "Active branches" list
#   https://github.com/MarlinFirmware/Marlin/branches
$fw_branch_name = "bugfix-2.0.x"

# Select the folder that matches the LCD screen controller chip
#   https://github.com/MarlinFirmware/Configurations/blob/import-2.1.x/config/examples/Creality/Ender-3%20V2/README.md
$LCD_screen_folder = "private"
$LCD_boot_screen_path = "image/0.jpg"


# Constants
$fw_root_folder = "tmp.marlinfw"

$fw_config_folder = "tmp.marlincfg"
$fw_config_printer_folder = "config/examples/Creality/Ender-3 V2"
$fw_config_printer_subfolder = "CrealityV422/CrealityUI"

$patch_branch_name = "ender3v2-crtouch-hemera"
$patch_folder = (Join-Path $PWD "patches") | Resolve-Path 
$fw_patch_message_for_folder = [ordered]@{
    (Join-Path $patch_folder "01-stock") = "Patching to match Ender-3 V2 'GD-Ender-3 V2-Marlin2.0.8.2-HW-V4.2.2-SW-V1.0.7_E_N_BLTouch";
    (Join-Path $patch_folder "02-tuning") = "Tuning movement and fixing stock settings";
    (Join-Path $patch_folder "03-features") = "Enabling additional Marlin features";
    (Join-Path $patch_folder "04-hemera") = "Configuring E3D Hemera hotend + direct drive extruder";
    (Join-Path $patch_folder "05-custom") = "Setting version and custom identifiers"
}


# Run

# Get firmware source code
Write-Host -ForegroundColor Green "Downloading Marlin firmware source code branch $fw_branch_name"
git clone --branch $fw_branch_name --depth 1 https://github.com/MarlinFirmware/Marlin.git $fw_root_folder

# Get Creality firmware settings
Write-Host -ForegroundColor Green "Downloading Marlin firmware configuration branch $fw_branch_name"
git clone --branch $fw_branch_name --depth 1 --sparse https://github.com/MarlinFirmware/Configurations.git $fw_config_folder
pushd $fw_config_folder
git sparse-checkout set "config/default" "$fw_config_printer_folder"
popd

# Patch firmware
pushd $fw_root_folder
git switch --create $patch_branch_name

$message = "Copy baseline Ender 3 V2 configuration from Marlin/Configurations/../$fw_config_printer_subfolder"
Write-Host -ForegroundColor Green "$message"
cp -v -force "../$fw_config_folder/$fw_config_printer_folder/$fw_config_printer_subfolder/*.h" "Marlin"
cp -force -recurse -exclude "*private*.txt" "../$fw_config_folder/$fw_config_printer_folder/LCD Files/$LCD_screen_folder" "Marlin"
git add Marlin
git commit -q -m "$message"

$message = "Copy custom boot screen"
Write-Host -ForegroundColor Green "$message"
cp -force "../custom-screen.jpg" "Marlin/$LCD_screen_folder/$LCD_boot_screen_path"
git add Marlin
git status --short
git commit -q -m "$message"

foreach ($folder in $fw_patch_message_for_folder.Keys) {
    $message = $($fw_patch_message_for_folder["$folder"])
    Write-Host -ForegroundColor Green "$message"
    foreach ($file in Get-ChildItem -File -Path "$folder") {
        git am -3 "$folder\$file"
    }
}

popd

# code $fw_root_folder

