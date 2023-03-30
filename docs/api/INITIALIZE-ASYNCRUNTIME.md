# Initialize-AsyncRuntime()

The `Initialize-AsyncRuntime` cmdlet is used to initialize a PowerShell application in a separate runspace. This is necessary for running .NET-based apps in PowerShell, as the .NET-based apps will hang the PowerShell process if they are run in the same runspace as the host thread.

## Try it out

```powershell
$Script = {
    Write-Host "I'm running on my own thread!"

    # Sending a dispatcher back to the main thread is required!
    # The $PostDispatcher scriptblock is automatically created by the `Invoke-AsyncRuntime` cmdlet.
    $Dispatcher = [System.Windows.Threading.Dispatcher]::CurrentDispatcher
    Invoke-Command $PostDispatcher -ArgumentList @( $Dispatcher )
}

Invoke-AsyncRuntime -Name "SecondThread" -InitializerScript $Script

$Runtimes.SecondThread.Dispatcher.Invoke([System.Action]{
    Write-Host "Second call on the second thread!"
})
```

## Syntax

```powershell
Invoke-AsyncRuntime
  -Name <String>
  -InitializerScript <ScriptBlock>
  [-SessionProxies <HashTable>]
```

### Parameters

#### -Name
String. The name of the runtime.
- Required: True

#### -InitializerScript
ScriptBlock. The scriptblock to initialize the new runspace. Must call `Invoke-Command $PostDispatcher -ArgumentList @( $Dispatcher )` to send the dispatcher back to the main thread.
- Required: True

#### -SessionProxies
HashTable. A hashtable of session proxies to use in the new runspace. The keys are the names of the proxies, and the values are the session proxies themselves.
- Required: False
- Default value: 
```powershell
@{
    # These can be overridden by -SessionProxies argument:
    # Internal script block defined in pwsh/threading/postdispatcher.ps1
    "PostDispatcher" = $PostDispatcher

    # These can't be overridden by -SessionProxies argument:
    # Is set by -Name argument
    "RuntimeName" = $Name

    # Is the same hashtable as the $Runtimes variable in the main thread
    "Runtimes" = $Runtimes
}
```

### Sets

#### $Runtimes
HashTable. A hashtable of runtimes. The keys are the names of the runtimes, and the values are the runtimes themselves. The runtimes contain 2 properties: `Dispatcher` and `Runspace` by default.
- The built-in runtimes additionally have a `Windows` property.

### Returns
[`System.Threading.Tasks.Task`](https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.task?view=net-7.0) representing the state of the -InitializerScript scriptblock on the new thread.