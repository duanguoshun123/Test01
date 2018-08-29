using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DelegateConsoleApplication.DelegateHelper
{
    public class Manager
    {
        private Func<int,int> Handler;
        //加入观察者
        public void Attach(Func<int, int> Handler1)
        {
            Handler += Handler1;
        }

        //删除观察者
        public void Detach(Func<int, int> Handler1)
        {
            Handler -= Handler1;
        }

        //通过GetInvodationList方法获取多路广播委托列表，如果观察者数量大于0即执行方法
        public void Execute(int basicNum)
        {
            if (Handler != null)
                if (Handler.GetInvocationList().Count() != 0)
                    Handler(basicNum);
        }
    }
}
