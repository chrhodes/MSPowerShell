Add-Member -InputObject $s -MemberType ScriptProperty -Name Desc -Value `
  {$this.Description} `
  {
    $t = $args[0]
    if ($t -isnot [string]) {
      throw 'this property only takes strings'
    }
    $this.Description = $t
  }
