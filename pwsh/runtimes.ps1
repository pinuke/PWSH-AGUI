param(
    [switch] $Reinstall = $false
)

$Root = If ( $TestRoot ) { $TestRoot } else {
    If ( $PSScriptRoot ) { Resolve-Path "$PSScriptRoot/.." } else { Resolve-Path "./.." }
}

$LoadArgs = @{
    "Reinstall" = $Reinstall
    "ConfigFile" = Resolve-Path "$Root/json/.loaderconfig.json"
    "ProjectDir" = Resolve-Path "$Root"
}

& "$Root/git/PowerLoader/pwsh/load.ps1" @LoadArgs

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
    }

    If( !$SessionProxies.PostDispatcher ){
        $SessionProxies.PostDispatcher = [scriptblock]::Create(( Import-Contents -Path "$Root/pwsh/postdispatcher.ps1" ))
    }
    $SessionProxies.Runtimes = $Runtimes
    $SessionProxies.RuntimeName = $Name
    
    $Runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace( $Host )
    $Runspace.ApartmentState = "STA"
    $Runspace.ThreadOptions = "ReuseThread"
    $Runspace.Open() | Out-Null

    foreach( $Proxy in $SessionProxies.GetEnumerator() ){
        $Runspace.SessionStateProxy.SetVariable( $Proxy.Name, $Proxy.Value )| Out-Null
    }

    $Thread = [System.Management.Automation.PowerShell]::Create()

    $Thread.Runspace = $Runspace
    $Runtimes[ $Name ].Runspace = $Thread

    $Thread.AddScript( $InitializerScript ) | Out-Null
    $Thread.BeginInvoke()

    Write-Host "Awaiting runtime initialization for $Name..."
    While( !$Runspace[ $Name ].Dispatcher ){}
    Write-Host " - done!"

}