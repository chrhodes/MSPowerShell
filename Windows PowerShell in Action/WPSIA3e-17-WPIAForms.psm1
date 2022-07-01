Add-Type -Assembly System.Drawing, System.Windows.Forms

function New-Size    
{
  param (
    [Parameter(mandatory=$true)] $x,
    [Parameter(mandatory=$true)] $y
  )
  New-Object System.Drawing.Size $x,$y
}

function New-Control   
{
  param (
    [Parameter(mandatory=$true)]
    [string]
      $ControlName,
    [hashtable] $Properties = @{}
  )

  $private:events = @{}
  $private:controls = $null 

  foreach ($pn in "Events", "Controls") 
  {
    if ($v = $Properties.$pn)
    {
      Set-Variable private:$pn $v
      $Properties.Remove($pn)
    }
  }
  
  $private:control = if ($Properties.Count) { 
    New-Object "System.Windows.Forms.$ControlName" -Property $Properties 
    }
    else {
      New-Object "System.Windows.Forms.$ControlName" 
    }

  if ($controls) {[void] $control.Controls.AddRange(@(& $controls)) }

  foreach ($private:en in $events.keys) 
  {
    $method = "add_$en"
    $control.$method.Invoke($events[$en])
  }

  if ($control -eq "form") {$c.add_Shown({ $this.Activate() }) }

  $control 
}
