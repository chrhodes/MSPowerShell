$code = @'
using System.Management.Automation;

[Cmdlet("Write", "InputObject")]
public class MyWriteInputObjectCmdlet : Cmdlet
{
    [Parameter]
    public string Parameter1;

    [Parameter(Mandatory = true, ValueFromPipeline=true)]
    public string InputObject;

    protected override void ProcessRecord()
    {
        if (Parameter1 != null)
                WriteObject(Parameter1 +  ":" +  InputObject);
            else
                WriteObject(InputObject);
    }
}
'@
$bin = Add-Type $code -PassThru
$bin.Assembly | Import-Module