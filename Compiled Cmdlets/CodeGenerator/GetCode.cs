using System;
using System.Management.Automation;
using YouDidntMakeMe;

namespace CodeGenerator
{
    [Cmdlet(VerbsCommon.Get, "Code")]
    public class GetCode : PSCmdlet
    {
        protected override void ProcessRecord()
        {
            var codeGen = new FunCodes();
            WriteObject(codeGen.SecretCode);
        }
    }
}
