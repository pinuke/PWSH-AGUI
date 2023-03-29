$Form = New-Object System.Windows.Forms.Form

$Form.Text = "WinForm Test"
$Form.Name = "WinForm Test"

$Form.DataBindings.DefaultDataSourceUpdateMode = 0

$Form.ClientSize = "800,450"

$Runtimes[ $RuntimeName ].Windows.Add( $Form )

$Form.Show() | Out-Null