using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModel.DesignModelClass.MediatorModel
{
    //开发部门
    public sealed class Development : Department
    {
        public Development(Mediator m) : base(m) { }
        public override void Process()
        {
            Console.WriteLine("我们是开发部门，要进行项目开发，没钱了，需要资金支持！");
        }

        public override void Apply()
        {
            Console.WriteLine("专心科研，开发项目！");
        }
    }
}
