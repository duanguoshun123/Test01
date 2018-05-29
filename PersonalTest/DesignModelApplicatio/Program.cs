using DesignModelClass.ObserverModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelApplicatio
{
    class Program
    {
        static void Main(string[] args)
        {
            Blog xmfdsh = new MyBlog("xmfdsh", "发布了一篇新博客");
            List<Subscriber> sub = new List<Subscriber>() {
                new Subscriber("王尼玛"),
                new Subscriber("唐马儒"),
                new Subscriber("王蜜桃"),
                new Subscriber("敖尼玛")
            };
            // 添加订阅者
            foreach (var item in sub)
            {
                xmfdsh.AddObserver(new NotifyEventHandler(item.Receive));
            }
            xmfdsh.Update();

            Console.WriteLine();
            Console.WriteLine();

            Console.WriteLine("移除订阅者王尼玛");
            foreach (var item in sub)
            {
                if (item.Name.Equals("王尼玛"))
                {
                    xmfdsh.RemoveObserver(new NotifyEventHandler(sub[sub.IndexOf(item)].Receive));
                    break;
                }
            }
            xmfdsh.Update();

            while (true)
            {
                Console.WriteLine("请选择操作，1:添加订阅者,2:移除订阅者,N:终止操作");
                var op = Console.ReadLine();
                var ops = new List<string>() { "1", "2", "N" };
                if (!ops.Contains(op))
                {
                    Console.WriteLine("输入命令操作不合法，请重新输入!");
                }
                if (op == "1")
                {
                    Console.WriteLine("请输入您要添加的订阅者姓名");
                    var name = Console.ReadLine();
                    Subscriber reader = new Subscriber(name);
                    sub.Add(reader);
                    xmfdsh.AddObserver(new NotifyEventHandler(reader.Receive));
                    Console.WriteLine("{0}订阅者添加成功!",name);
                }
                if (op == "2")
                {
                    Console.WriteLine("请输入您要移除的订阅者姓名");
                    var name = Console.ReadLine();
                    Subscriber reader = new Subscriber(name);
                    foreach (var item in sub)
                    {
                        if (item.Name.Equals(name))
                        {
                            xmfdsh.RemoveObserver(new NotifyEventHandler(sub[sub.IndexOf(item)].Receive));
                            break;
                        }
                    }
                    Console.WriteLine("{0}订阅者移除成功!", name);
                }
                if (op == "N")
                {
                    xmfdsh.Update();
                    break;
                }
            }
        }

    }
}
