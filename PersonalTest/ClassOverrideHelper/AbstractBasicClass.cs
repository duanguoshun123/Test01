using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassOverrideHelper
{
    public abstract class AbstractBasicClass
    {
        public AbstractBasicClass()
        {
            Console.WriteLine("我是抽象类构造函数");
        }
        public static void NormalFunc()
        {
            Console.WriteLine("我是抽象类中普通的方法");
        }
        public virtual void VirtualFunc()
        {
            Console.WriteLine("我是抽象类中虚拟的方法");
        }
        public abstract void AbstractFunc();
    }
}
