$Scope["New-Window"] = {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Xaml
    )

    [xml] $Xaml = $Xaml

    $manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $Xaml.NameTable
    $manager.AddNamespace( "x", "http://schemas.microsoft.com/winfx/2006/xaml" )

    $reader = New-Object System.Xml.XmlNodeReader $Xaml
    $window = [Windows.Markup.XamlReader]::Load( $reader )

    $Runtimes[ "WPF" ].Windows.Add( $window ) | Out-Null

    $window.Show() | Out-Null
}