# Usage
#  PS> Unblock-File .\get-and-patch-source.ps
#  PS> .\get-and-patch-source.ps


# Settings

# Select the branch to build from the "Active branches" list
#   https://github.com/MarlinFirmware/Marlin/branches
$fw_branch_name = "2.1.x"

#   https://github.com/MarlinFirmware/Configurations/branches
$cfg_branch_name = "release-2.1.2.1"


# Constants
$fw_root_folder = "C:/dev/scratch/cr30/tmp.marlinfw"

$fw_config_folder = "C:/dev/scratch/cr30/tmp.marlincfg"
$fw_config_printer_folder = "config/examples/Creality/CR-30 PrintMill"

$patch_branch_name = "cr30-stock-with-tuning"
$patch_folder = (Join-Path $PWD "patches") | Resolve-Path 
$fw_patch_message_for_folder = [ordered]@{
    (Join-Path $patch_folder "02-cr30users") = "Applying CR30-Users improvements";
    (Join-Path $patch_folder "03-features") = "Enabling additional Marlin features";
    (Join-Path $patch_folder "05-custom") = "Setting machine specific constants and custom identifiers"
}


# Run

# Get firmware source code
Write-Host -ForegroundColor Green "Downloading Marlin firmware source code branch $fw_branch_name"
git clone --branch $fw_branch_name --depth 1 https://github.com/MarlinFirmware/Marlin.git $fw_root_folder

# Get Creality firmware settings
Write-Host -ForegroundColor Green "Downloading Marlin firmware configuration branch $cfg_branch_name"
git clone --branch $cfg_branch_name --depth 1 --sparse https://github.com/MarlinFirmware/Configurations.git $fw_config_folder
Push-Location $fw_config_folder
git sparse-checkout set "config/default" "$fw_config_printer_folder"
Pop-Location

# Patch firmware
Push-Location $fw_root_folder
git switch --create $patch_branch_name

$message = "Official: Copy baseline configuration from Marlin/Configurations/$fw_config_printer_folder"
Write-Host -ForegroundColor Green "$message"
Copy-Item -v -force "$fw_config_folder/$fw_config_printer_folder/*.h" "Marlin"
git add Marlin
git commit -q -m "$message"

foreach ($folder in $fw_patch_message_for_folder.Keys) {
    $message = $($fw_patch_message_for_folder["$folder"])
    Write-Host -ForegroundColor Green "$message"
    foreach ($file in Get-ChildItem -File -Path "$folder/*" -Include "*.patch") {
        git am -3 "$file"
    }
}

Pop-Location

Write-Host -ForegroundColor Green "Launching VS Code"
code $fw_root_folder
