using System;
using System.Management.Automation;

namespace SayHello
{
    [Cmdlet(VerbsCommon.Get, "Greeting")]
    public class GetGreeting : PSCmdlet
    {
        [Parameter()]
        public string Name {get; set;}

        protected override void ProcessRecord()
        {
            string greeting = $"Hello, {(!string.IsNullOrEmpty(Name) ? Name : "World")}";
            WriteObject(greeting);
        }
    }
}
