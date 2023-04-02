Initialize-AsyncRuntime -Name "WPF" -Factory {
    
    If( [System.Windows.Application]::Current ){
        # WPF bug: https://stackoverflow.com/q/60171199
        throw @"
The WPF Application object is already initialized. Due to a bug in WPF, you must restart PowerShell to use the WPF runtime.

- PWSH-AGUI requires control over the WPF Application's thread in order to work properly.
  - the PowerShell thread that WPF is currently running on is inaccessible by PWSH-AGUI.
- WPF Bug: https://stackoverflow.com/q/60171199

"@
    }

    $App = [System.Windows.Application]::new()

    # Return the thread's current dispatcher
    [System.Windows.Application]::Current.Dispatcher

    $App.Run() | Out-Null
} | Out-Null

$Runtimes[ "WPF" ].Windows = New-Object System.Collections.ArrayList