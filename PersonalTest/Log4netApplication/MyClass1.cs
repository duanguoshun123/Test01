using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Log4netApplication
{
    public class MyClass1 : BaseClass
    {
        private string property1;
        public string Property1
        {
            get
            {
                return this.property1;
            }
            set
            {
                this.property1 = value;
            }
        }
    }
}
