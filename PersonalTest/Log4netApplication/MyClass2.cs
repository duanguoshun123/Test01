using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Log4netApplication
{
    public class MyClass2 : BaseClass
    {
        private string property2;
        public string Property2
        {
            get
            {
                return this.property2;
            }
            set
            {
                this.property2 = value;
            }
        }
    }
}
