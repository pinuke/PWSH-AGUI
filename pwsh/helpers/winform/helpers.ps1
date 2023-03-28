$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../.." } else { Resolve-Path "./../../.." }
}

# New-WinFormWindow (local thread)
# & "$Root/pwsh/helpers/winform/new-window/remote.ps1" # no remote function for winform creation
& "$Root/pwsh/helpers/winform/new-window/local.ps1"