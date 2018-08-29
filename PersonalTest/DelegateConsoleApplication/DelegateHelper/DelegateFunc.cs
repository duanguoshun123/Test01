using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DelegateConsoleApplication.DelegateHelper
{
    // 自定义一个委托
    public delegate int Expression(int a, int b);
    public class DelegateFunc
    {
        public static int Add(int a, int b)
        {
            return a + b;
        }
        public static int Divide(int a, int b)
        {
            return a / b;
        }
        public static int Subtract(int a, int b)
        {
            return a - b;
        }
        public static int multiply(int a, int b)
        {
            return a * b;
        }
        public static void Calculate(Expression ex, int a, int b)
        {
            Console.WriteLine(ex(a, b) + "\n");
        }
        public static void CalculateBySys<T, Y, U>(Func<T, Y, U> ex, T a, Y b)
        {
            Console.WriteLine(ex(a, b) + "\n");
        }
    }
}
