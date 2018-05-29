using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DeepShallowCopy
{
    [Serializable]
    public class DeepCopyDemoClass
    {
        public string Name { get; set; }
        public int[] pIntArray { get; set; }
        public Address Address { get; set; }
        public DemoEnum DemoEnum { get; set; }

        // DeepCopyDemoClass中引用了TestB对象，TestB类又引用了DeepCopyDemoClass对象，从而造成了相互引用
        public TestB TestB { get; set; }

        public override string ToString()
        {
            return "DeepCopyDemoClass";
        }
    }

    [Serializable]
    public class TestB
    {
        public string Property1 { get; set; }

        public DeepCopyDemoClass DeepCopyClass { get; set; }

        public override string ToString()
        {
            return "TestB Class";
        }
    }

    [Serializable]
    public struct Address
    {
        public string City { get; set; }
    }

    public enum DemoEnum
    {
        EnumA = 0,
        EnumB = 1
    }

    public class PersonA
    {
        public string Name { get; set; }
        public int Age { get; set; }

        public A ClassA { get; set; }
    }

    public class A
    {
        public String TestProperty { get; set; }
    }
}
