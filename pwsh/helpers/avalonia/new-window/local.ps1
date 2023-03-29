$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../../.." } else { Resolve-Path "./../../../.." }
}

$Runtimes[ "Avalonia" ].Windows = New-Object System.Collections.ArrayList

$Remote = [scriptblock]::Create(( Import-Contents -Path "$Root/pwsh/helpers/avalonia/new-window/remote.ps1" ))
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
