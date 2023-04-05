$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../../../.." } else { Resolve-Path "./../../../.." }
}

Invoke-Delegate `
    -Runtime "Avalonia" `
    -Path "$Root/pwsh/helpers/avalonia/new-window/remote.ps1" `
    -Sync | Out-Null

function global:New-AvaloniaWindow{
    param(
        [string] $Xaml,
        [string] $Path,
        [scriptblock] $Script
    )

    $Params = @{ "Runtime" = "Avalonia" }

    If( $Script ) {
        $Params.Delegate = $Script
    } else {

        if ( !$Path -and !$Xaml ) {
            throw [System.ArgumentException]::new('Either Path or Xaml must be specified', 'Path')
        }

        If ( $Path ) {
            $Xaml = Import-Contents -Path $Path
        }

        $Params.Delegate = @"

Invoke-Command `$Scope["New-Window"] -ArgumentList `@`"
$Xaml
`"`@

"@

    }

    # Returns the ITask so that the dispatch can be awaited
    Invoke-Delegate @Params

}
