$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../../.." } else { Resolve-Path "./../../../.." }
}

$Remote = Import-Contents -Path "$Root/pwsh/helpers/wpf/new-window/remote.ps1" -As ScriptBlock
$Runtimes[ "WPF" ].Dispatcher.InvokeAsync( [System.Action]$Remote ).Wait() | Out-Null

function global:New-WPFWindow{
    param(
        [string] $Xaml,
        [string] $Path,
        [scriptblock] $Script
    )

    If( $Script ) {
        $Script = [scriptblock]::Create( $Script.ToString() )
    } else {

        if ( !$Path -and !$Xaml ) {
            throw [System.ArgumentException]::new('Either Path or Xaml must be specified', 'Path')
        }
    
        If ( $Path ) {
            $Xaml = Import-Contents -Path $Path
        }
    
        $Script = [scriptblock]::Create(@"
    
Invoke-Command `$Scope["New-Window"] -ArgumentList `@`"
$Xaml
`"`@

"@)

    }

    $Runtimes[ "WPF" ].Dispatcher.InvokeAsync( [System.Action]$Script )
    # Returns the ITask so that the dispatch can be awaited

}
