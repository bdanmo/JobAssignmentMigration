trap { $host.ui.WriteErrorLine($_.Exception); exit 90 }

try {
  $user = (Get-WMIObject -ClassName Win32_ComputerSystem).Username.split("\")[-1]
} catch {
  Write-Error "Error fetching user: $Error"
  Exit 0
}

$oneDrive = "C:\Users\$user\OneDrive - Senneca Holdings\Desktop"
$deskPath = "C:\Users\$user\Desktop\JobAssignment_v2.0.exe"
$altDeskPath = "C:\Users\$user.HMFEXPRESS\Desktop\JobAssignment_v2.0.exe"
$oneDrivePath = "C:\Users\$user\OneDrive - Senneca Holdings\Desktop\JobAssignment_v2.0.exe"
$altOneDrivePath = "C:\Users\$user.HMFEXPRESS\OneDrive - Senneca Holdings\Desktop\JobAssignment_v2.0.exe"

if (Test-Path $oneDrive) {
  if (((Test-Path $deskPath) -or (Test-Path $altDeskPath)) -and ((Test-Path $oneDrivePath) -or (Test-Path $altOneDrivePath))) {
    Write-Output "Current version already installed."
    Exit 0
  } else {
    Exit 1
  }
} else {
  if ((Test-Path $deskPath) -or (Test-Path $altDeskPath)) {
    Write-Output "Current version already installed."
    Exit 0
  } else {
    Exit 1
  }
}
