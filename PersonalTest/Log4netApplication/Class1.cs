using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Log4netApplication
{
    public class Class1
    {
        private BaseClass myObject;

        [XmlElement("BaseClass", typeof(BaseClass))]
        [XmlElement("MyClass1", typeof(MyClass1))]
        [XmlElement("MyClass2", typeof(MyClass2))]
        public BaseClass Property
        {
            get
            {
                return this.myObject;
            }
            set
            {
                this.myObject = value;
            }
        }
    }
}
