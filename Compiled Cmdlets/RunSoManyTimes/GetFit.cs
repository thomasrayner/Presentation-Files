using System;
using System.Management.Automation;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RunSoManyTimes
{
    [Cmdlet(VerbsCommon.Get, "Fit")]
    public class GetFit : PSCmdlet
    {
        protected override void ProcessRecord()
        {
            var firstList = Enumerable.Range(1, 5);
            var secondList = Enumerable.Range(20, 5);
            var thirdList = Enumerable.Range(300, 5);

            var firstTask = Task.Run(() => GetBiggestThenWait(firstList));
            var secondTask = Task.Run(() => GetBiggestThenWait(secondList));
            var thirdTask = Task.Run(() => GetBiggestThenWait(thirdList));

            Task.WaitAll();

            var bigNumbers = new List<int>() {firstTask.Result, secondTask.Result, thirdTask.Result};

            string outString = String.Join(",", bigNumbers);
            WriteObject(outString);
        }

        static int GetBiggestThenWait(IEnumerable<int> InputCollection)
        {
            Thread.Sleep(5000);
            return InputCollection.Max();
        }
    }
}
