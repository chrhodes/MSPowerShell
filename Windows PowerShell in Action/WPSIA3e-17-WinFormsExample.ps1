Import-Module ./WPIAForms.psm1
$form = New-Control -ControlName form -Properties @{
    Text = 'Hi'
    Size = New-Size -x 100 -y 60
    Controls = {
        New-Control -ControlName button -Properties @{
            Text = 'Push Me'
            Dock = 'Fill'
            Events = @{
                Click = {$form.Close()}
            }
        }
    }
}
$form.ShowDialog()