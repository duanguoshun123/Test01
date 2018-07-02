using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplicationOfReflaction
{
    public delegate void GreetingDelegate(string name);
    public class DelegateAccess
    {
        public static void EnglishGreeting(string name)
        {
            Console.WriteLine("Morning, " + name);
        }

        public static void ChineseGreeting(string name)
        {
            Console.WriteLine("早上好, " + name);
        }

        //注意此方法，它接受一个GreetingDelegate类型的方法作为参数  
        public static void GreetPeople(string name, GreetingDelegate MakeGreeting)
        {
            MakeGreeting(name);
        }
    }
}
