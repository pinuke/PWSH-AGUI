function global:Invoke-Delegate{
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock] $Delegate,
        [Parameter(Mandatory=$true)]
        [string] $Runtime,
        [switch] $Sync
    )

    $Delegate = [scriptblock]::Create( $Delegate.ToString() )
    $Task = $Runtimes[ $Runtime ].Dispatcher.InvokeAsync( [System.Action]$Delegate )

    if ( $Sync ) {
        $Task.Wait()
    } else {
        $Task
    }

}