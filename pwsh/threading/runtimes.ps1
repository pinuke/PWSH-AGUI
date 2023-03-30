$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../.." } else { Resolve-Path "./../.." }
}

$global:Runtimes = [System.Collections.Hashtable]::Synchronized(@{})

function global:Initialize-AsyncRuntime{
    param(
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [scriptblock] $Factory,
        [System.Collections.Hashtable]
        $SessionProxies = @{}
    )

    If( !$Name ){
        $Index = $Runtimes.Keys |
            Where-Object { $_ -match "AsyncRuntime\d+$" } |
            Select-String -Pattern "\d+$" |
            ForEach-Object { $_.Matches.Value } |
            Sort-Object -Descending |
            Select-Object -First 1

        If( $Index ){
            $Name = "AsyncRuntime$($Index + 1)"
        } else {
            $Name = "AsyncRuntime0"
        }
    }

    If( $Runtimes[ $Name ] ){
        Write-Host "$Name runtime already initialized!" -BackgroundColor DarkRed -ForegroundColor White
        return;
    } else {
        $Runtimes[ $Name ] = @{}
    }

    $SessionProxies = [System.Collections.Hashtable]::Synchronized( $SessionProxies )
    
    $SessionProxies.Runtimes = $Runtimes
    $SessionProxies.RuntimeName = $Name
    $SessionProxies.Factory = $Factory
    
    $Runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace( $Host )
    $Runspace.ApartmentState = "STA"
    $Runspace.Name = $Name
    $Runspace.ThreadOptions = "ReuseThread"
    $Runspace.Open() | Out-Null

    foreach( $Proxy in $SessionProxies.GetEnumerator() ){
        $Runspace.SessionStateProxy.SetVariable( $Proxy.Name, $Proxy.Value )| Out-Null
    }

    $Thread = [System.Management.Automation.PowerShell]::Create()

    $Thread.Runspace = $Runspace
    $Runtimes[ $Name ].Runspace = $Thread

    $Thread.AddScript({
        
        # Since application loops can't add to this scope, providing a scope hashtable to make do
        $Scope = @{}

        $local:InitializerScript = [scriptblock]::Create($Factory.ToString())
        $Factory = $null

        Invoke-Command $InitializerScript | ForEach-Object {
            $Runtimes[ $RuntimeName ].Dispatcher = $_
        }
    }) | Out-Null
    $OutputTask = $Thread.BeginInvoke()

    Write-Host "Awaiting runtime initialization for $Name..."
    # System.Threading.Tasks.TaskStatus.RanToCompletion
    While( !$OutputTask.IsCompleted -and !$Runtimes[ $Name ].ContainsKey( "Dispatcher" ) ){}
    Write-Host " - done!"
}