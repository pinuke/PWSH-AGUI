Initialize-AsyncRuntime -Name "WPF" -Factory {
    
    $App = [System.Windows.Application]::new()

    Invoke-Command $PostDispatcher -ArgumentList @( [System.Windows.Application]::Current.Dispatcher ) | Out-Null

    $App.Run() | Out-Null
} | Out-Null

$Runtimes[ "WPF" ].Windows = New-Object System.Collections.ArrayList