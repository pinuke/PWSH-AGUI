$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../.." } else { Resolve-Path "./../../.." }
}

# New-Window (remote thread)/New-WPFWindow (local thread)
& "$Root/pwsh/helpers/wpf/new-window/remote.ps1"
& "$Root/pwsh/helpers/wpf/new-window/local.ps1"