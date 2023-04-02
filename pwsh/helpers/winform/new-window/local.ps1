function global:New-WinFormWindow{
    param(
        [scriptblock] $Script,
        [string] $Path
    )

    if ( !$Path -and !$Script ) {
        throw [System.ArgumentException]::new('Either Path or Script must be specified', 'Path')
    }

    $Params = @{ "Runtime" = "WinForm" }

    if ( $Path ) {
        $Params.Path = $Path
    } else {
        $Params.Delegate = $Script
    }

    # Returns the ITask so that the dispatch can be awaited
    Invoke-Delegate @Params

}
