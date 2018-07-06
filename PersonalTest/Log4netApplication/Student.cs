using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Log4netApplication
{
    [Serializable]
    public class Student
    {
        public string Sex
        {
            get { return "男"; }
            set { }
        }
        public string Name
        {
            get { return "wangying"; }
            set { }
        }
        public int Age
        {
            get;
            set;
        }
    }
}
