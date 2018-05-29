using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.MemorandumModel
{
    /// <summary>
    /// 备忘录
    /// </summary>
    public class ContactMemento
    {
        public List<ContactPerson> ContactPersonBack { get; set; }
        public ContactMemento(List<ContactPerson> persons)
        {
            ContactPersonBack = persons;
        }
    }
}
