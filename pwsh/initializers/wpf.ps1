Initialize-AsyncRuntime -Name "WPF" -Factory {
    
    $App = [System.Windows.Application]::new()

    # Return the thread's current dispatcher
    [System.Windows.Application]::Current.Dispatcher

    $App.Run() | Out-Null
} | Out-Null

$Runtimes[ "WPF" ].Windows = New-Object System.Collections.ArrayList