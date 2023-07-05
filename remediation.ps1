Write-Output "Script is running."
try {
    $user = (Get-WMIObject -ClassName Win32_ComputerSystem).Username.split("\")[-1]
}
catch {
    Write-Error "Error fetching user: $Error"
    Exit 1
}

#variable defnitions
$SourcePath = ".\JobAssignment.exe"
$appVer = "v2.1"
$userDesk = "C:\Users\$user\Desktop"
$altDesk = "C:\Users\$user.HMFEXPRESS\Desktop"
$oneDriveDesk = "C:\Users\$user\OneDrive - Senneca Holdings\Desktop"
$altOneDriveDesk = "C:\Users\$user.HMFEXPRESS\OneDrive - Senneca Holdings\Desktop"

#function to install at path, with nice user-friendly output
function InstallToPath {
    param (
        [Parameter(Mandatory = $true)]
        [string]$path
    )

    try {
        Write-Output "Copying $SourcePath as JobAssignment_$appVer to $path"
        $destPath = "$path\JobAssignment_$appVer.exe"
        Copy-Item $SourcePath $destPath -Force -ErrorAction Stop
        Write-Output "Success! File: $destPath"
    }
    catch {
        Write-Output "Error copying to ${path}: $Error"
    }
}

#function to uninstall prior versions at path, with nice user-friendly output
function UninstallFromPath {
    param (
        [Parameter(Mandatory = $true)]
        [string]$path
    )

    try {
        #remove files that begin with JobAssignment but do not end with the current version
        Write-Output "Removing older versions from $path"
        Get-ChildItem $path -Filter "JobAssignment*.exe" | Where-Object { $_.Name -notlike "JobAssignment_$appVer.exe" } | Remove-Item -Force
        Write-Output "Success!"
    }
    catch {
        Write-Error "Error removing from ${path}: $Error"
    }
}

try {
    #if none of the above desktops exists, exit with error, else continue
    if (!(Test-Path $userDesk) -and !(Test-Path $altDesk) -and !(Test-Path $oneDriveDesk) -and !(Test-Path $altOneDriveDesk)) {
        Write-Error "No desktop found for user $user"
        Exit 1
    }
    else {
        #test each path and install if it exists
        if (Test-Path $userDesk) {
            InstallToPath $userDesk
            UninstallFromPath $userDesk
        }
        elseif (Test-Path $altDesk) {
            InstallToPath $altDesk
            UninstallFromPath $altDesk
        }

        if (Test-Path $oneDriveDesk) {
            InstallToPath $oneDriveDesk
            UninstallFromPath $oneDriveDesk
        }
        elseif (Test-Path $altOneDriveDesk) {
            InstallToPath $altOneDriveDesk
            UninstallFromPath $altOneDriveDesk
        }
    }

}
catch {
    Write-Error "Something went wrong: $Error"
    Exit 1
}