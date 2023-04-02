$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../../.." } else { Resolve-Path "./../../../.." }
}

Invoke-Delegate `
    -Runtime "Avalonia" `
    -Path "$Root/pwsh/helpers/wpf/new-window/remote.ps1" `
    -Sync

function global:New-WPFWindow{
    param(
        [string] $Xaml,
        [string] $Path,
        [scriptblock] $Script
    )

    $Params = @{ "Runtime" = "WPF" }

    If( $Script ) {
        $Params.Script = $Script
    } else {

        if ( !$Path -and !$Xaml ) {
            throw [System.ArgumentException]::new('Either Path or Xaml must be specified', 'Path')
        }
    
        If ( $Path ) {
            $Xaml = Import-Contents -Path $Path
        }
    
        $Params.Script = @"
    
Invoke-Command `$Scope["New-Window"] -ArgumentList `@`"
$Xaml
`"`@

"@

    }
    # Returns the ITask so that the dispatch can be awaited
    Invoke-Delegate @Params

}
