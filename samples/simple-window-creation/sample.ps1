$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../.." } else { Resolve-Path "./../.." }
}

$SampleDir = Resolve-Path "$Root/samples/simple-window-creation"

. "$Root/pwsh/main.ps1"

New-WinFormWindow -Script ([scriptblock]::Create(( Import-Contents "$SampleDir/pwsh/winform.ps1" )))
New-WPFWindow -Xaml (Import-Contents "$SampleDir/xaml/wpf.xaml" )
New-AvaloniaWindow -Xaml (Import-Contents "$SampleDir/xaml/avalonia.xaml" )