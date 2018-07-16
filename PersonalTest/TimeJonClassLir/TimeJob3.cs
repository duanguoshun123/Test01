using Common.Log;
using Quartz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TimeJonClassLir
{
    public class TimeJob3 : IJob
    {
        public async Task Execute(IJobExecutionContext context)
        {
            await Logger();
        }
        public async Task Logger()
        {
            int num = 0;
            try
            {
                LoggerHelper.Debug("调试器解读03{0}", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            }
            catch (Exception)
            {
                num = -1;
            }
            await Task.FromResult(num);
        }
    }
}
