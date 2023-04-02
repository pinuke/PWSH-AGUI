function global:Invoke-Delegate{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Runtime,
        $Delegate,
        [string] $Path,
        [switch] $Sync
    )

    if ( !$Path -and !$Delegate ) {
        throw [System.ArgumentException]::new('Either Path or Script must be specified', 'Delegate')
    }

    If ( $Path ) {
        $Delegate = Import-Contents -Path $Path -As ScriptBlock
    } elseif ( $Delegate.GetType() -notin [string],[scriptblock] ) {
        throw [System.ArgumentException]::new( 'Delegate must be a string or scriptblock', 'Delegate' )
    } else {
        $Delegate = [scriptblock]::Create( $Delegate.ToString() )
    }
    
    $Task = $Runtimes[ $Runtime ].Dispatcher.InvokeAsync( [System.Action]$Delegate )

    if ( $Sync ) {
        $Task.Wait() | Out-Null
    } else {
        $Task
    }

}