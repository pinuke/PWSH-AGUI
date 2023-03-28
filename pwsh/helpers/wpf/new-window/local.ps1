$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../../.." } else { Resolve-Path "./../../../.." }
}

$Remote = [scriptblock]::Create(( Import-Contents -Path "$Root/pwsh/helpers/wpf/new-window/remote.ps1" ))
$Runtimes[ "WPF" ].Dispatcher.InvokeAsync( [System.Action]$Remote ).Wait()

function global:New-WPFWindow{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Xaml
    )

    $Script = @"

New-Window -Xaml `@`"
$Xaml
`"`@

"@

    $Runtimes[ "WPF" ].Dispatcher.InvokeAsync( [System.Action]$Script )
    # Returns the ITask so that the dispatch can be awaited

}
