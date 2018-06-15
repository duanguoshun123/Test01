using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReflactionHepler
{
    public class TestClass
    {
        private string _value;
        public TestClass()
        {
        }
        public TestClass(string value)
        {
            _value = value;
        }
        public string GetValue(string prefix)
        {
            if (_value == null)
                return "NULL";
            else
                return prefix + "  :  " + _value;
        }
        public string Value
        {
            set
            {
                _value = value;
            }
            get
            {
                if (_value == null)
                    return "NULL";
                else
                    return _value;
            }
        }
    }
}
