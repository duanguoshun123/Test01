using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassHelper
{
    public class Tools
    {
        #region 假设这些方法被第三方被封装的，不可修改的方法
        public static async Task TestAsync()
        {
            await Task.Delay(1000)
                      .ConfigureAwait(false);//不会死锁
        }

        public static async Task<string> GetStrAsync()
        {
            return await Task.Run(() => "OK").ConfigureAwait(false);
        }

        public static async Task DelayTestAsync()
        {
            //Logger.LoggerFactory.Instance.Logger_Info("DelayAsync");
            await Task.Delay(1000);
        }

        public static async Task<string> DelayGetStrAsync()
        {
            return await Task.Run(() => "OK");
        }
        #endregion

        #region 我们需要在自己代码中封装它，解决线程死锁
        /// <summary>
        /// 没有返回值的同步调用异步的实体
        /// </summary>
        /// <param name="func"></param>
        public static void ForWait(Func<Task> func)
        {
            func().ConfigureAwait(false);
        }
        /// <summary>
        /// 存在返回值的同步调用异步的实体
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="func"></param>
        /// <returns></returns>
        public static T ForResult<T>(Func<Task<T>> func)
        {
            var a = func();
            a.ConfigureAwait(false);
            return a.Result;
        }
        #endregion
    }
}
