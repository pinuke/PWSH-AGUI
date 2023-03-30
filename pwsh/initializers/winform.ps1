Initialize-AsyncRuntime -Name "WinForm" -Factory {

    # Return the thread's current dispatcher
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher

    [System.Windows.Forms.Application]::EnableVisualStyles() | Out-Null
    [System.Windows.Forms.Application]::Run() | Out-Null
} | Out-Null

$Runtimes[ "WinForm" ].Windows = New-Object System.Collections.ArrayList
# todo: add factory on remote for auto setting this