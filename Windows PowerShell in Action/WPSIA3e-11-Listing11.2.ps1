param(
    [switch]${AsJob}
)

Begin {
  try {
    $positionalArguments = & $script:NewObject collections.arraylist
    foreach ($parameterName in $PSBoundParameters.BoundPositionally)
    {
       $null = $positionalArguments.Add( $PSBoundParameters[$parameterName] )
       $null = $PSBoundParameters.Remove($parameterName)
    }
    $positionalArguments.AddRange($args)

    $clientSideParameters = Get-PSImplicitRemotingClientSideParameters $PSBoundParameters $False

    $scriptCmd = { & $script:InvokeCommand `
                     @clientSideParameters `
                     -HideComputerName `
                     -Session (Get-PSImplicitRemotingSession -CommandName 'Get-Bios') `
                     -Arg ('Get-Bios', $PSBoundParameters, $positionalArguments) `
                     -Script { param($name, $boundParams, $unboundParams) & $name @boundParams @unboundParams } `
                  }

    $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
    $steppablePipeline.Begin($myInvocation.ExpectingInput, $ExecutionContext)
  } catch {
    throw
  }
}
Process {
  try {
    $steppablePipeline.Process($_)
  } catch {
    throw
  }
}
End {
  try {
    $steppablePipeline.End()
  } catch {
    throw
  }
}

# .ForwardHelpTargetName Get-Bios
# .ForwardHelpCategory Function
# .RemoteHelpRunspace PSSession