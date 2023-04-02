Initialize-AsyncRuntime -Name "WPF" -Factory {
    
    If( [System.Windows.Application]::Current ){
        # WPF thread restriction:
        # - WPF can only access/return the current dispatcher, on the thread it was created.
        # Workaround: shutdown and restart the application.
        [System.Windows.Application]::Current.Dispatcher.InvokeAsync([System.Action]{
            [System.Windows.Application]::Current.Shutdown()
        }).Wait() | Out-Null
    }

    $App = [System.Windows.Application]::new()

    # Return the thread's current dispatcher
    [System.Windows.Application]::Current.Dispatcher

    $App.Run() | Out-Null
} | Out-Null

$Runtimes[ "WPF" ].Windows = New-Object System.Collections.ArrayList