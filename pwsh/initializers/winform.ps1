Initialize-AsyncRuntime -Name "WinForm" -InitializerScript {

    $Scope = @{}

    Invoke-Command $PostDispatcher -ArgumentList @( [System.Windows.Threading.Dispatcher]::CurrentDispatcher )

    [System.Windows.Forms.Application]::EnableVisualStyles()
    [System.Windows.Forms.Application]::Run()
} | Out-Null