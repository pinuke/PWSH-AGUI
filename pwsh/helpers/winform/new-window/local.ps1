function global:New-WinFormWindow{
    param(
        [scriptblock] $Script,
        [string] $Path
    )

    if ( !$Path -and !$Script ) {
        throw [System.ArgumentException]::new('Either Path or Script must be specified', 'Path')
    }

    if ( $Path ) {
        $Script = Import-Contents -Path $Path -As ScriptBlock
    } else {
        $Script = [scriptblock]::Create( $Script.ToString() )
    }

    $Runtimes[ "WinForm" ].Dispatcher.InvokeAsync( [System.Action]$Script )
    # Returns the ITask so that the dispatch can be awaited

}
