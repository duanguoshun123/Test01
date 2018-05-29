using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DeepShallowCopy
{
    class Program
    {
        static void Main(string[] args)
        {
            //ShallowCopyDemo();
            //ListShallowCopyDemo();
            DeepCopyDemo();
            DeepCopyDemo2();
        }

        public static void ListShallowCopyDemo()
        {
            List<PersonA> personList = new List<PersonA>()
            {
                new PersonA() { Name="PersonA", Age= 10, ClassA= new A() { TestProperty = "AProperty"} },
                new PersonA() { Name="PersonA2", Age= 20, ClassA= new A() { TestProperty = "AProperty2"} }
            };

            // 下面2种方式实现的都是浅拷贝
            List<PersonA> personsCopy = new List<PersonA>(personList);
            PersonA[] personCopy2 = new PersonA[2];
            personList.CopyTo(personCopy2);

            // 由于实现的是浅拷贝，所以改变一个对象的值，其他2个对象的值都会发生改变，因为它们都是使用的同一份实体，即它们指向内存中同一个地址
            personsCopy.First().ClassA.TestProperty = "AProperty3";
            WriteLog(string.Format("personCopy2.First().ClassA.TestProperty is {0}", personCopy2.First().ClassA.TestProperty));
            WriteLog(string.Format("personList.First().ClassA.TestProperty is {0}", personList.First().ClassA.TestProperty));
            WriteLog(string.Format("personsCopy.First().ClassA.TestProperty is {0}", personsCopy.First().ClassA.TestProperty));
            Console.Read();
        }

        public static void ShallowCopyDemo()
        {
            ShallowCopyDemoClass DemoA = new ShallowCopyDemoClass();
            ShallowCopyDemoClass DemoB = DemoA.Clone() as ShallowCopyDemoClass;
            DemoB.intValue = 2;
            WriteLog(string.Format("    int->[A:{0}] [B:{1}]", DemoA.intValue, DemoB.intValue));
            DemoB.strValue = "2";
            WriteLog(string.Format("    string->[A:{0}] [B:{1}]", DemoA.strValue, DemoB.strValue));
            DemoB.pEnum = PersonEnum.EnumB;
            WriteLog(string.Format("  Enum->[A: {0}] [B:{1}]", DemoA.pEnum, DemoB.pEnum));
            DemoB.pStruct.StructValue = 2;
            WriteLog(string.Format("    struct->[A: {0}] [B: {1}]", DemoA.pStruct.StructValue, DemoB.pStruct.StructValue));
            DemoB.pIntArray[0] = 2;
            WriteLog(string.Format("   intArray->[A:{0}] [B:{1}]", DemoA.pIntArray[0], DemoB.pIntArray[0]));
            DemoB.pStringArray[0] = "2";
            WriteLog(string.Format("stringArray->[A:{0}] [B:{1}]", DemoA.pStringArray[0], DemoB.pStringArray[0]));
            DemoB.pClass.Name = "2";
            WriteLog(string.Format("      Class->[A:{0}] [B:{1}]", DemoA.pClass.Name, DemoB.pClass.Name));
            Console.WriteLine();
        }

        private static void WriteLog(string msg)
        {
            Console.WriteLine(msg);
        }

        public static void DeepCopyDemo()
        {
            DeepCopyDemoClass deepCopyClassA = new DeepCopyDemoClass();
            deepCopyClassA.Name = "DeepCopyClassDemo";
            deepCopyClassA.pIntArray = new int[] { 1 };
            deepCopyClassA.DemoEnum = DemoEnum.EnumA;
            deepCopyClassA.Address = new Address() { City = "Shanghai" };

            deepCopyClassA.TestB = new TestB() { Property1 = "TestProperty", DeepCopyClass = deepCopyClassA };

            // 使用反序列化来实现深拷贝
            DeepCopyDemoClass deepCopyClassB = DeepCopyAchieve.DeepCopyWithBinarySerialize<DeepCopyDemoClass>(deepCopyClassA);
            deepCopyClassB.Name = "DeepCopyClassDemoB";
            WriteLog(string.Format("    Name->[A:{0}] [B:{1}]", deepCopyClassA.Name, deepCopyClassB.Name));
            deepCopyClassB.pIntArray[0] = 2;
            WriteLog(string.Format("    intArray->[A:{0}] [B:{1}]", deepCopyClassA.pIntArray[0], deepCopyClassB.pIntArray[0]));
            deepCopyClassB.Address = new Address() { City = "Beijing" };
            WriteLog(string.Format("    Addressstruct->[A: {0}] [B: {1}]", deepCopyClassA.Address.City, deepCopyClassB.Address.City));
            deepCopyClassB.DemoEnum = DemoEnum.EnumB;
            WriteLog(string.Format("    DemoEnum->[A: {0}] [B: {1}]", deepCopyClassA.DemoEnum, deepCopyClassB.DemoEnum));
            deepCopyClassB.TestB.Property1 = "TestPropertyB";
            WriteLog(string.Format("    Property1->[A:{0}] [B:{1}]", deepCopyClassA.TestB.Property1, deepCopyClassB.TestB.Property1));
            WriteLog(string.Format("    TestB.DeepCopyClass.Name->[A:{0}] [B:{1}]", deepCopyClassA.TestB.DeepCopyClass.Name, deepCopyClassB.TestB.DeepCopyClass.Name));
            Console.WriteLine();
        }

        public static void DeepCopyDemo2()
        {
            DeepCopyDemoClass deepCopyClassA = new DeepCopyDemoClass();
            deepCopyClassA.Name = "DeepCopyClassDemo";
            deepCopyClassA.pIntArray = new int[] { 1, 2 };
            deepCopyClassA.DemoEnum = DemoEnum.EnumA;
            deepCopyClassA.Address = new Address() { City = "Shanghai" };

            deepCopyClassA.TestB = new TestB() { Property1 = "TestProperty", DeepCopyClass = deepCopyClassA };

            // 使用反射来完成深拷贝
            DeepCopyDemoClass deepCopyClassB = DeepCopyAchieve.DeepCopyWithReflection<DeepCopyDemoClass>(deepCopyClassA);

            //DeepCopyDemoClass deepCopyClassB = DeepCopyHelper.DeepCopyWithReflection<DeepCopyDemoClass>(deepCopyClassA);
            deepCopyClassB.Name = "DeepCopyClassDemoB";
            WriteLog(string.Format("    Name->[A:{0}] [B:{1}]", deepCopyClassA.Name, deepCopyClassB.Name));
            deepCopyClassB.pIntArray[0] = 2;
            WriteLog(string.Format("    intArray->[A:{0}] [B:{1}]", deepCopyClassA.pIntArray[0], deepCopyClassB.pIntArray[0]));
            deepCopyClassB.Address = new Address() { City = "Beijing" };
            WriteLog(string.Format("    Addressstruct->[A: {0}] [B: {1}]", deepCopyClassA.Address.City, deepCopyClassB.Address.City));
            deepCopyClassB.DemoEnum = DemoEnum.EnumB;
            WriteLog(string.Format("    DemoEnum->[A: {0}] [B: {1}]", deepCopyClassA.DemoEnum, deepCopyClassB.DemoEnum));
            deepCopyClassB.TestB.Property1 = "TestPropertyB";
            WriteLog(string.Format("    Property1->[A:{0}] [B:{1}]", deepCopyClassA.TestB.Property1, deepCopyClassB.TestB.Property1));
            WriteLog(string.Format("    TestB.DeepCopyClass.Name->[A:{0}] [B:{1}]", deepCopyClassA.TestB.DeepCopyClass.Name, deepCopyClassB.TestB.DeepCopyClass.Name));
            Console.ReadKey();
        }
    }
}
