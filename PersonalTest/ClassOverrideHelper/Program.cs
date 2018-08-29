using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassOverrideHelper
{
    class Program
    {
        static void Main(string[] args)
        {
            AbstractOverriderClass aOC = new AbstractOverriderClass("我是独立思考者");
            aOC.AbstractFunc();
            aOC.VirtualFunc("我是自己");
            AbstractBasicClass.NormalFunc();

            NormalClass nC = new NormalClass();
            IPrint print = new NormalClass();
            IPrintOut printOut = new NormalClass();

            print.Test();
            print.PrintIn();

            nC.Test();
            nC.PrintIn();

            printOut.Test();
            printOut.Out();
            Console.ReadKey();
        }
    }
}
