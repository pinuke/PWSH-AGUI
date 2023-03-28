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

& "$Root/pwsh/runtimes.ps1"