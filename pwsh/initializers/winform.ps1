Initialize-AsyncRuntime -Name "WinForm" -InitializerScript {

    Invoke-Command $PostDispatcher -ArgumentList @( [System.Windows.Threading.Dispatcher]::CurrentDispatcher ) | Out-Null

    [System.Windows.Forms.Application]::EnableVisualStyles() | Out-Null
    [System.Windows.Forms.Application]::Run() | Out-Null
} | Out-Null

$Runtimes[ "WinForm" ].Windows = New-Object System.Collections.ArrayList
# todo: add factory on remote for auto setting this