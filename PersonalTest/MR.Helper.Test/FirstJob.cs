using Microsoft.Hadoop.MapReduce;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MR.Helper.Test
{
    public class FirstJob : HadoopJob<FirstMapper>
    {
        public override HadoopJobConfiguration Configure(ExecutorContext context)
        {
            HadoopJobConfiguration config = new HadoopJobConfiguration();
            config.InputPath = "input/SqrtJob";
            config.OutputFolder = "output/SqrtJob";
            return config;
        }
    }
}
