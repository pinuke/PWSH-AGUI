$Scope["New-Window"] = {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Xaml
    )

    $window = [Avalonia.Markup.Xaml.AvaloniaRuntimeXamlLoader]::Parse[Avalonia.Controls.Window]( $Xaml )

    $Runtimes[ "Avalonia" ].Windows.Add( $window ) | Out-Null

    $window.Show() | Out-Null
}