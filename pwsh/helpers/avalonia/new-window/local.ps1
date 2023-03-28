$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../../.." } else { Resolve-Path "./../../../.." }
}

$Remote = [scriptblock]::Create(( Import-Contents -Path "$Root/pwsh/helpers/avalonia/new-window/remote.ps1" ))
$Runtimes[ "Avalonia" ].Dispatcher.InvokeAsync( [System.Action]$Remote ).Wait()

function global:New-AvaloniaWindow{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Xaml
    )

    $Script = @"

New-Window -Xaml `@`"
$Xaml
`"`@

"@

    $Runtimes[ "Avalonia" ].Dispatcher.InvokeAsync( [System.Action]$Script )
    # Returns the ITask so that the dispatch can be awaited

}
