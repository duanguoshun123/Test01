using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModel.DesignModelClass.MediatorModel
{
    //抽象中介者角色
    public interface Mediator
    {
        void Command(Department department);
    }
}
