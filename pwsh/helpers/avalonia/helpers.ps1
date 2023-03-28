$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../.." } else { Resolve-Path "./../../.." }
}

# New-Window (remote thread)/New-AvaloniaWindow (local thread)
& "$Root/pwsh/helpers/avalonia/new-window/remote.ps1"
& "$Root/pwsh/helpers/avalonia/new-window/local.ps1"