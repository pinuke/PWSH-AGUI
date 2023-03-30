function global:New-WinFormWindow{
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock] $Script
    )

    $Script = [scriptblock]::Create( $Script.ToString() )

    $Runtimes[ "WinForm" ].Dispatcher.InvokeAsync( [System.Action]$Script )
    # Returns the ITask so that the dispatch can be awaited

}
