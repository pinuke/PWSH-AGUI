Initialize-AsyncRuntime -Name "WPF" -Script {
    $App = [System.Windows.Application]::new()

    Invoke-Command $PostDispatcher -ArgumentList @( [System.Windows.Application]::Current.Dispatcher )

    $App.Run()
} | Out-Null