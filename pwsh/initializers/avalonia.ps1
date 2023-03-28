Initialize-AsyncRuntime -Name "Avalonia" -Script {
    $Builder = [Avalonia.AppBuilder]::Configure[Avalonia.Application]()
    $Builder = [Avalonia.AppBuilderDesktopExtensions]::UsePlatformDetect( $Builder )

    $Lifetime = [Avalonia.Controls.ApplicationLifetimes.ClassicDesktopStyleApplicationLifetime]::new()
    $Lifetime.ShutdownMode = [Avalonia.Controls.ShutdownMode]::OnExplicitShutdown

    $Builder = $Builder.SetupWithLifetime( $Lifetime )

    $App = $Appbuilder.Instance

    Invoke-Command $PostDispatcher -ArgumentList @( [Avalonia.Threading.Dispatcher]::UIThread )

    $Themes = @{
        "Default" = [Avalonia.Markup.Xaml.Styling.StyleInclude]::new( [System.Uri] $null )
        "BaseLight" = [Avalonia.Markup.Xaml.Styling.StyleInclude]::new( [System.Uri] $null )
    }
    $Themes.Default.Source = [System.Uri]::new( "avares://Avalonia.Themes.Default/DefaultTheme.xaml" )
    $Themes.BaseLight.Source = [System.Uri]::new( "avares://Avalonia.Themes.Default/Accents/BaseLight.xaml" )

    $App.Styles.Add( $Themes.Default )
    $App.Styles.Add( $Themes.BaseLight )

    $CTS = [System.Threading.CancellationTokenSource]::new()

    [Avalonia.Controls.DesktopApplicationExtensions]::Run( $App, $CTS.Token )
} | Out-Null