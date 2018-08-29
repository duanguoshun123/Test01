using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassOverrideHelper
{
    public class AbstractOverriderClass : AbstractBasicClass
    {
        public AbstractOverriderClass() : base()
        {
            Console.WriteLine("我是继承抽象类的类中构造函数");
        }
        public AbstractOverriderClass(string str)
        {
            Console.WriteLine("我是继承抽象类的类中构造函数,我有自己的思考{0}", str);
        }
        public override void AbstractFunc()
        {
            Console.WriteLine("我是继承抽象类的抽象方法");
        }
        public void VirtualFunc(string str)
        {
            Console.WriteLine("我是继承抽象类的虚拟方法,我独立了:{0}", str);
            //base.VirtualFunc();
        }
        new public void VirtualFunc()
        {
            Console.WriteLine("我是继承抽象类的虚拟方法");
        }
    }
}
