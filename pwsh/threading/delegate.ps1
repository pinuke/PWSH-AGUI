function global:Invoke-Delegate{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Runtime,
        [scriptblock] $Delegate,
        [string] $Path,
        [switch] $Sync
    )

    if ( !$Path -and !$Delegate ) {
        throw [System.ArgumentException]::new('Either Path or Script must be specified', 'Delegate')
    }

    If ( $Path ) {
        $Delegate = Import-Contents -Path $Path -As ScriptBlock
    } else {
        $Delegate = [scriptblock]::Create( $Delegate.ToString() )
    }
    
    $Task = $Runtimes[ $Runtime ].Dispatcher.InvokeAsync( [System.Action]$Delegate )

    if ( $Sync ) {
        $Task.Wait()
    } else {
        $Task
    }

}