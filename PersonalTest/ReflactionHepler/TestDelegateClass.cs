using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReflactionHepler
{
    public delegate string TestDelegate(string value);
    public class TestDelegateClass
    {
        public string TestField;
        public int Id { get; set; }
        public TestDelegateClass()
        {

        }
        public string GetValue(string value)
        {
            return value;
        }
    }
}
