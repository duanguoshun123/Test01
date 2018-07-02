using ReflactionHepler;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplicationOfReflaction
{
    class Program
    {
        static void Main(string[] args)
        {
            Rectangle r = new Rectangle(4.5, 7.5);
            r.Display();
            Type type = typeof(Rectangle);
            // 遍历 Rectangle 类的特性
            foreach (Object attributes in type.GetCustomAttributes(false))
            {
                DeBugInfo dbi = (DeBugInfo)attributes;
                if (null != dbi)
                {
                    Console.WriteLine("Bug no: {0}", dbi.BugNo);
                    Console.WriteLine("Developer: {0}", dbi.Developer);
                    Console.WriteLine("Last Reviewed: {0}",
                         dbi.LastReview);
                    Console.WriteLine("Remarks: {0}", dbi.Message);
                }
            }

            // 遍历方法特性
            foreach (MethodInfo m in type.GetMethods())
            {
                foreach (Attribute a in m.GetCustomAttributes(true))
                {
                    try
                    {
                        DeBugInfo dbi = (DeBugInfo)a;
                        if (null != dbi)
                        {
                            Console.WriteLine("Bug no: {0}, for Method: {1}",
                                  dbi.BugNo, m.Name);
                            Console.WriteLine("Developer: {0}", dbi.Developer);
                            Console.WriteLine("Last Reviewed: {0}",
                                  dbi.LastReview);
                            Console.WriteLine("Remarks: {0}", dbi.Message);
                        }
                    }
                    catch (Exception)
                    {
                        continue;
                    }

                }
            }
            //获取类型信息
            Type t = Assembly.Load("ReflactionHepler").GetType("ReflactionHepler.TestClass");
            //构造器的参数
            object[] constructParams = new object[] { "tummy" };
            //根据类型创建对象
            object dObj = Activator.CreateInstance(t, constructParams);
            //获取方法的信息
            MethodInfo method = t.GetMethod("GetValue");
            //调用方法的一些标志位，这里的含义是Public并且是实例方法，这也是默认的值
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance;
            //GetValue方法的参数
            object[] parameters = new object[] { "Hello" };
            //调用方法，用一个object接收返回值
            object returnValue = method.Invoke(dObj, flag, Type.DefaultBinder, parameters, null);
            Console.WriteLine(returnValue);

            TestDelegateClass objTestDelegateClass = new TestDelegateClass();
            Type tTestDelegate = Assembly.Load("ReflactionHepler").GetType("ReflactionHepler.TestDelegate");
            Type tTestDelegateClass = Assembly.Load("ReflactionHepler").GetType("ReflactionHepler.TestDelegateClass");
            TestDelegate methodTestDelegate = (TestDelegate)Delegate.CreateDelegate(tTestDelegate, objTestDelegateClass, "GetValue");
            string returnValueTestDelegate = methodTestDelegate("hello");
            Console.WriteLine(returnValueTestDelegate);

            PropertyInfo propertyInfo = tTestDelegateClass.GetProperty("Id");
            FieldInfo fieldInfo = tTestDelegateClass.GetField("Name");
            // TestDelegateClass objTestDelegateClass2=(TestDelegateClass)tTestDelegateClass.FastNew

            string name1, name2;
            name1 = "Jimmy Zhang";
            name2 = "张子阳";
            DelegateAccess.GreetPeople(name1, DelegateAccess.EnglishGreeting);
            DelegateAccess.GreetPeople(name2, DelegateAccess.ChineseGreeting);

            Console.ReadKey();
        }
    }
}
