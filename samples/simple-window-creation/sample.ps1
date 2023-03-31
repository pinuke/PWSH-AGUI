$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../.." } else { Resolve-Path "./../.." }
}

$SampleDir = Resolve-Path "$Root/samples/simple-window-creation"

. "$Root/pwsh/main.ps1"

New-WinFormWindow -Path "$SampleDir/pwsh/winform.ps1"
New-WPFWindow -Path "$SampleDir/xaml/wpf.xaml"
New-AvaloniaWindow -Path "$SampleDir/xaml/avalonia.xaml"