$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/../.." } else { Resolve-Path "./../.." }
}

$global:Runtimes = @{}

function global:Initialize-AsyncRuntime{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [scriptblock] $InitializerScript,
        [System.Collections.Hashtable]
        $SessionProxies = @{}
    )

    If( $Runtimes[ $Name ] ){
        Write-Host "$Name runtime already initialized!" -BackgroundColor DarkRed -ForegroundColor White
        return;
    } else {
        $Runtimes[ $Name ] = @{}
    }

    If( !$SessionProxies.PostDispatcher ){
        $SessionProxies.PostDispatcher = [scriptblock]::Create(( Import-Contents -Path "$Root/pwsh/threading/postdispatcher.ps1" ))
    }
    $SessionProxies.Runtimes = $Runtimes
    $SessionProxies.RuntimeName = $Name
    $SessionProxies.InitializerScript = $InitializerScript
    
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

    $Runtimes[ $Name ].Ready = $false

    $Thread.AddScript([System.Action]{
        
        # Since application loops can't add to this scope, providing a scope hashtable to make do
        $Scope = @{}

        $Runtimes[ $Name ].Dispatcher = Invoke-Command $InitializerScript
        $Runtimes[ $Name ].Ready = $true
    }) | Out-Null
    $Thread.BeginInvoke()

    Write-Host "Awaiting runtime initialization for $Name..."
    While( !$Runtimes[ $Name ].Ready && !$Runtimes[ $Name ].Dispatcher ){}
    Write-Host " - done!"

    If( !$Runtimes[ $Name ].Dispatcher ){
        $Runtimes[ $Name ].Remove('Dispatcher')
    }
    $Runtimes[ $Name ].Remove('Ready')
}