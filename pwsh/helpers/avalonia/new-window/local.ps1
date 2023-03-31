$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../../.." } else { Resolve-Path "./../../../.." }
}

$Remote = Import-Contents -Path "$Root/pwsh/helpers/avalonia/new-window/remote.ps1" -As ScriptBlock
$Runtimes[ "Avalonia" ].Dispatcher.InvokeAsync( [System.Action]$Remote ).Wait() | Out-Null

function global:New-AvaloniaWindow{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Xaml
    )

    $Script = [scriptblock]::Create(@"

Invoke-Command `$Scope["New-Window"] -ArgumentList `@`"
$Xaml
`"`@

"@)

    $Runtimes[ "Avalonia" ].Dispatcher.InvokeAsync( [System.Action]$Script )
    # Returns the ITask so that the dispatch can be awaited

}
