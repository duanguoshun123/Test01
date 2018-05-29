using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.ObserverModel
{
    //定义一个委托，这里定义了观察者方法的签名，就是一个协议吧 
    public delegate void NumberEventHandler(object sender, NumberEventArgs e);
    //要传递哪些参数到观察者？在这里定义，注意，要继承自EventArgs 
    public class NumberEventArgs : EventArgs
    {
        public NumberEventArgs(int number)
        {
            _number = number;
        }
        private int _number;
        public int Number
        {
            get
            { return _number; }
            set
            { _number = value; }
        }
    }
    //观察者模式中的主题 
    public class Subject
    {
        //定义一个事件，就是委托的实例了 
        public event NumberEventHandler NumberReached;
        public void DoWithLoop(int number)
        {
            for (int i = 0; i <= 100; i++)
            {
                //触发事件的条件到了 
                if (i == number)
                {
                    NumberEventArgs e = new NumberEventArgs(i); OnNumberReached(e);
                }
            }
        }
        //注意，这个方法定义为保护的，虚拟的，代表子类还可以进行覆盖，改变触发事件的行为 
        //甚至可以不触发事件 
        protected virtual void OnNumberReached(NumberEventArgs e)
        {
            //判断事件是否为null，也就是是否绑定了方法 
            if (NumberReached != null) NumberReached(this, e);
        }
    }
}
