Initialize-AsyncRuntime -Name "WPF" -InitializerScript {
    
    $Scope = @{}
    
    $App = [System.Windows.Application]::new()

    Invoke-Command $PostDispatcher -ArgumentList @( [System.Windows.Application]::Current.Dispatcher )

    $App.Run()
} | Out-Null

$Runtimes[ "WPF" ].Windows = New-Object System.Collections.ArrayList