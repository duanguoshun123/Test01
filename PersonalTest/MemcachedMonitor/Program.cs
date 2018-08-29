using EnyimMemcachedHelper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MemcachedMonitor
{
    class Program
    {
        static void Main(string[] args)
        {
            MemcachedDemo demo = new MemcachedDemo();
            demo.SetDemo();
            demo.MultiGetDemo();
            Console.ReadKey();
        }
    }
}
