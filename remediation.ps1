Write-Output "Script is running."
try {
    $user = (Get-WMIObject -ClassName Win32_ComputerSystem).Username.split("\")[-1]
}
catch {
    Write-Error "Error fetching user: $Error"
    Exit 1
}

#variable defnitions
$SourcePath = .\JobAssignment.exe
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
        Write-Output "Copying to $path"
        $destPath = "$path\JobAssignment.exe"
        Copy-Item $SourcePath $destPath -Force
        Write-Output "Success!"
    }
    catch {
        Write-Error "Error copying to ${path}: $Error"
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
        }
        elseif (Test-Path $altDesk) {
            InstallToPath $altDesk
        }

        if (Test-Path $oneDriveDesk) {
            InstallToPath $oneDriveDesk
        }
        elseif (Test-Path $altOneDriveDesk) {
            InstallToPath $altOneDriveDesk
        }
    }

}
catch {
    Write-Error "Something went wrong: $Error"
    Exit 1
}