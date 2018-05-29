using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DeepShallowCopy
{
    // 继承ICloneable接口，重新其Clone方法
    public class ShallowCopyDemoClass : ICloneable
    {
        public int intValue = 1;
        public string strValue = "1";
        public PersonEnum pEnum = PersonEnum.EnumA;
        public PersonStruct pStruct = new PersonStruct() { StructValue = 1 };
        public Person pClass = new Person("1");
        public int[] pIntArray = new int[] { 1 };
        public string[] pStringArray = new string[] { "1" };

        #region ICloneable成员
        public object Clone()
        {
            return this.MemberwiseClone();
        }

        #endregion 

    }

    public class Person
    {
        public string Name;
        public Person(string name)
        {
            Name = name;
        }
    }

    public enum PersonEnum
    {
        EnumA = 0,
        EnumB = 1
    }

    public struct PersonStruct
    {
        public int StructValue;
    }
}
