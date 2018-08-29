using DelegateConsoleApplication.DelegateHelper;
using System;

namespace DelegateConsoleApplication
{
    class Program
    {
        public delegate int Handler(int a);
        public static event Func<int, int> EventHandler;
        static void Main(string[] args)
        {
            Expression Expression = DelegateFunc.Add;
            DelegateFunc.Calculate(Expression, 10, 5);


            Expression add = delegate (int a, int b) { return a + b; };
            Expression subtract = delegate (int a, int b) { return a - b; };
            Expression multiply = delegate (int a, int b) { return a * b; };
            Expression divide = delegate (int a, int b) { return a / b; };
            DelegateFunc.Calculate(subtract, 10, 5);


            DelegateFunc.Calculate((a, b) => a + b, 10, 5);
            //DelegateHelper.DelegateFunc.Calculate((a, b) => a - b, 10, 5);
            //DelegateHelper.DelegateFunc.Calculate((a, b) => a * b, 10, 5);
            //DelegateHelper.DelegateFunc.Calculate((a, b) => a / b, 10, 5);

            Func<int, int, int> addBySys = (a, b) => a + b;
            DelegateFunc.CalculateBySys(addBySys, 10, 5);

            Func<int, int> addMultDelegate = new Func<int, int>(Cul1);
            addMultDelegate += new Func<int, int>(Cul2);
            Console.WriteLine(addMultDelegate(10));

            Manager manager = new Manager();
            //加入Add1观察者
            Func<int, int> HandlerA = new Func<int, int>(Cul1);
            manager.Attach(HandlerA);

            //加入Add2观察者
            Func<int, int> HandlerB = new Func<int, int>(Cul2);
            manager.Attach(HandlerB);

            //同时加入10，分别进行计算
            manager.Execute(10);


            Func<int, int> handlerC;
            handlerC = HandlerA;
            handlerC += HandlerB;
            handlerC(10);


            EventHandler += HandlerA;
            EventHandler += HandlerB;
            EventHandler(10);

            Console.ReadKey();
        }
        static int Cul1(int a)
        {
            int b = 10 + a;
            Console.WriteLine(b);
            return b;
        }
        static int Cul2(int a)
        {
            int b = 10 - a;
            Console.WriteLine(b);
            return b;
        }
    }
}
