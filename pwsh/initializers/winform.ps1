Initialize-AsyncRuntime -Name "WinForm" -InitializerScript {

    $Scope = @{}

    Invoke-Command $PostDispatcher -ArgumentList @( [System.Windows.Threading.Dispatcher]::CurrentDispatcher )

    [System.Windows.Forms.Application]::EnableVisualStyles()
    [System.Windows.Forms.Application]::Run()
} | Out-Null

$Runtimes[ "WinForm" ].Windows = New-Object System.Collections.ArrayList
# todo: add factory on remote for auto setting this