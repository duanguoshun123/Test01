using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.StateModel
{
    public class ConcreteStateB : State
    {
        /// <summary>
        /// 设置ConcreteStateB的下一个状态是ConcreteSateA
        /// </summary>
        /// <param name="context"></param>
        public override void Handle(Context context)
        {
            Console.WriteLine("当前状态是 B.");
            context.State = new ConcreteStateA();
        }
    }
}
