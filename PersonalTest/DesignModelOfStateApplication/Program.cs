using DesignModelClass.StateModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelOfStateApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            // 设置Context的初始状态为ConcreteStateA
            Context context = new Context(new ConcreteStateA());

            // 不断地进行请求，同时更改状态
            context.Request();

            Console.Read();
        }
    }
}
