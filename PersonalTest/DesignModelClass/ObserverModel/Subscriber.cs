using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.ObserverModel
{
    public class Subscriber
    {
        public string Name { get; set; }
        public Subscriber(string name)
        {
            this.Name = name;
        }

        public void Receive(Object obj)
        {
            Blog xmfdsh = obj as Blog;

            if (xmfdsh != null)
            {
                Console.WriteLine("订阅者 {0} 观察到了{1}{2}", Name, xmfdsh.Symbol, xmfdsh.Info);
            }
        }
    }
}
