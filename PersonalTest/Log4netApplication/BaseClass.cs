using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Log4netApplication
{
    public class BaseClass
    {
        private string baseName;
        public string BaseName
        {
            get
            {
                return this.baseName;
            }
            set
            {
                this.baseName = value;
            }
        }
    }
}
