function Stop-ProcessUsingWMI {
[CmdletBinding(SupportsShouldProcess=$True)]
param(
[parameter(mandatory=$true)] [regex] $pattern
)
  foreach ($process in Get-WmiObject Win32_Process | where { $_.Name -match $pattern }) {
      if ($PSCmdlet.ShouldProcess("process $($process.Name) " + " (id: $($process.ProcessId))" , "Stop Process")) {
        $process.Terminate()
      }
  }
}