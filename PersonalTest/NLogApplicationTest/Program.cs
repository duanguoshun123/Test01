using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NLogHelper;
namespace NLogApplicationTest
{
    class Program
    {
        static void Main(string[] args)
        {
            NLogHelperFunc logger = new NLogHelperFunc();
            try
            {
                logger.LoggerDebug("调试：除法运算");
                int x = 50, y = 0;
                if (y == 0)
                {
                    logger.LoggerWarn("提示：除数为0会出现异常");
                }
                var z = x / y;
                logger.LoggerInfo("{0}除以{1}结果为{2}", x, y, z);
            }
            catch (Exception ex)
            {
                logger.LoggerErr("异常信息：{0}", ex.Message);
            }
        }
    }
}
