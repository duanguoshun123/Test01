using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.StateModel
{
    public class ConcreteStateA : State
    {
        /// <summary>
        /// 设置ConcreteStateA的下一个状态是ConcreteStateB
        /// </summary>
        /// <param name="context"></param>
        public override void Handle(Context context)
        {
            Console.WriteLine("当前状态是 A.");
            context.State = new ConcreteStateB();
        }
    }
}
