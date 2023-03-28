param(
    [Parameter(Mandatory=$true)]
    $RemoteDispatcher
)

$Runtimes[ $RuntimeName ].Dispatcher = $RemoteDispatcher