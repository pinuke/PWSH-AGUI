param(
    [switch] $Reinstall = $false
)

$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/.." } else { Resolve-Path "./.." }
}

$LoadArgs = @{
    "Reinstall" = $Reinstall
    "ConfigFile" = Resolve-Path "$Root/json/.loaderconfig.json"
    "ProjectDir" = Resolve-Path "$Root"
}

& "$Root/git/PowerLoader/pwsh/load.ps1" @LoadArgs

& "$Root/pwsh/threading/runtimes.ps1"
& "$Root/pwsh/threading/delegate.ps1"

& "$Root/pwsh/initializers/winform.ps1"
& "$Root/pwsh/initializers/wpf.ps1"
& "$Root/pwsh/initializers/avalonia.ps1"

& "$Root/pwsh/helpers/winform/helpers.ps1"
& "$Root/pwsh/helpers/wpf/helpers.ps1"
& "$Root/pwsh/helpers/avalonia/helpers.ps1"