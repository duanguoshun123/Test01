using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassOverrideHelper
{
    public class NormalClass : AbstractBasicClass, IPrint, IPrintOut
    {
        public NormalClass()
        {
            Console.WriteLine("我是一般类的构造函数");
        }
        public override void AbstractFunc()
        {
            Console.WriteLine("我实现了AbstractBasicClass抽象类的AbstractFunc方法");
        }

        public void Out()
        {
            Console.WriteLine("我实现了IPrintOut接口中Out方法");
        }

        public void PrintIn()
        {
            Console.WriteLine("我实现了IPrint接口中PrintIn方法");
        }

        void IPrint.Test()
        {
            Console.WriteLine("我实现了IPrint接口中测试方法");
        }
        void IPrintOut.Test()
        {
            Console.WriteLine("我实现了IPrintOut接口中测试方法");
        }
        public void Test()
        {
            Console.WriteLine("我实现了测试接口");
        }


    }
}
