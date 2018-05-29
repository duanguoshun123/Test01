using DeepShallowCopy;
using DesignModelClass.MemorandumModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace PersonalTest
{
    class Program
    {
        static void Main(string[] args)
        {
            //MyThread t = new MyThread(5);
            //ThreadStart threadStart = new ThreadStart(t.Calculate);
            //Thread thread = new Thread(threadStart);
            //thread.Start();
            //string str1 = "abcABG122";
            //string str2 = "ABcabG122";
            //Console.WriteLine(string.Equals(str1, str2, StringComparison.CurrentCultureIgnoreCase));
            //React obj = new React() { Height = 50.2, Widtd = 30.6 };
            //double squal = obj.GetSqual(obj);
            //Console.WriteLine(squal);
            //Helper h = new Helper();
            //h.DoWork();

            // 孙悟空 原型
            //MonkeyKingPrototype prototypeMonkeyKing = new ConcretePrototype("MonkeyKing");

            //// 变一个
            //MonkeyKingPrototype cloneMonkeyKing = prototypeMonkeyKing.Clone() as ConcretePrototype;
            //Console.WriteLine("Cloned1:\t" + cloneMonkeyKing.Id);

            //// 变两个
            //MonkeyKingPrototype cloneMonkeyKing2 = prototypeMonkeyKing.Clone() as ConcretePrototype;
            //Console.WriteLine("Cloned2:\t" + cloneMonkeyKing2.Id);
            //Console.ReadLine();
            //AbstractFile file1, file2, folder1, file3, folder2, folder3;
            //folder1 = new Folder("我的视频");
            //folder2 = new Folder("我的图片");
            //folder3 = new Folder("我的资料");

            //file1 = new TextFile("文本1");

            //file2 = new ImageFile("图像2");
            //file3 = new TextFile("文本2");
            //folder1.Add(file1);
            //folder2.Add(file2);
            //folder2.Add(file3);
            //folder3.Add(file1);
            //folder3.Add(file3);
            //folder1.KillVirue();
            //folder2.KillVirue();
            //folder3.KillVirue();
            //Console.ReadLine();
            //string roman = "MCMXXVIII";
            //Context context = new Context(roman);
            //// Build the 'parse tree'
            //List<Expression> tree = new List<Expression>();
            //tree.Add(new ThousandExpression());
            //tree.Add(new HundredExpression());
            //tree.Add(new TenExpression());
            //tree.Add(new OneExpression());

            //// Interpret
            //foreach (Expression exp in tree)
            //{
            //    exp.Interpret(context);
            //}
            //Console.WriteLine("{0} = {1}", roman, context.Output);
            //Console.ReadKey();
            /// 中介者模式 测试
            //DeepCopyDemo();
            //DeepCopyDemo2();
            List<ContactPerson> persons = new List<ContactPerson>()
            {
                new ContactPerson() { Name= "Learning Hard", MobileNum = "123445"},
                new ContactPerson() { Name = "Tony", MobileNum = "234565"},
                new ContactPerson() { Name = "Jock", MobileNum = "231455"}
            };

            MobileOwner mobileOwner = new MobileOwner(persons);
            mobileOwner.Show();

            // 创建备忘录并保存备忘录对象
            Caretaker caretaker = new Caretaker();
            caretaker.ContactMementoDic.Add(DateTime.Now.ToString(), mobileOwner.CreateMemento());

            // 更改发起人联系人列表
            Console.WriteLine("----移除最后一个联系人--------");
            mobileOwner.ContactPersons.RemoveAt(2);
            mobileOwner.Show();

            // 创建第二个备份
            Thread.Sleep(1000);
            caretaker.ContactMementoDic.Add(DateTime.Now.ToString(), mobileOwner.CreateMemento());

            Console.WriteLine("是否修改名为Tony通讯录,Y/N");
            var flag = Console.ReadLine();
            if (flag == "Y")//修改
            {
                Console.Write("请输入你要修改后的备注:");
                var name = Console.ReadLine();
                mobileOwner.ContactPersons.ForEach(x =>
                {
                    if (x.Name == "Tony")
                    {
                        x.Name = name;
                    }
                });
            }
            mobileOwner.Show();

            // 恢复到原始状态
            Console.WriteLine("-------恢复联系人列表,请从以下列表选择恢复的日期------");
            var keyCollection = caretaker.ContactMementoDic.Keys;
            foreach (string k in keyCollection)
            {
                Console.WriteLine("Key = {0}", k);
            }
            while (true)
            {
                Console.Write("请输入数字,按窗口的关闭键退出:");

                int index = -1;
                try
                {
                    index = Int32.Parse(Console.ReadLine());
                }
                catch
                {
                    Console.WriteLine("输入的格式错误");
                    continue;
                }

                ContactMemento contactMentor = null;
                if (index < keyCollection.Count && caretaker.ContactMementoDic.TryGetValue(keyCollection.ElementAt(index), out contactMentor))
                {
                    mobileOwner.RestoreMemento(contactMentor);
                    mobileOwner.Show();
                }
                else
                {
                    Console.WriteLine("输入的索引大于集合长度！");
                }
            }
        }
        #region 拷贝测试
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
        #endregion
    }
    public class MyThread
    {
        public double Diameter = 10;

        public double Result = 0;

        public MyThread(int Diameter)
        {
            this.Diameter = Diameter;
        }

        public void Calculate()
        {
            Console.WriteLine("Calculate Start");
            Thread.Sleep(2000);
            Result = Diameter * Math.PI; ;
            Console.WriteLine("Calculate End, Diameter is {0},Result is {1}", this.Diameter, Result);
        }
    }
    struct React
    {
        public double Height;
        public double Widtd;
        public double GetSqual(React obj)
        {
            return obj.Height * obj.Widtd;
        }
    }
    public class Helper
    {
        public static int chanceNumber = 0;
        public void DoWork()
        {
            Console.WriteLine("请输入任何一个值:");
            var str = Console.ReadLine();
            int y;
            int[] gz = new int[] { 3000, 3500, 3600, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 9000, 10000, 15000 };
            if (int.TryParse(str, out y))
            {

                if (gz.Contains(y))
                {
                    switch (chanceNumber)
                    {
                        case 0: Console.WriteLine("恭喜你获得一等奖"); break;
                        case 1: Console.WriteLine("恭喜你获得二等奖"); break;
                        case 2: Console.WriteLine("恭喜你获得三等奖"); break;
                        default:
                            break;
                    }

                }
                else
                {
                    chanceNumber++;
                    if (chanceNumber < 3)
                    {
                        Console.WriteLine("猜测有误喔,你还有{0}次机会，请重新输入任何一个值:", 3 - chanceNumber);
                        DoWork();
                    }
                    else
                    {
                        Console.WriteLine("对不起,你已经用光了所有的猜测机会");
                    }
                }
            }
            else
            {
                Console.WriteLine("输入的参数不是有效的数值，请重新输入任何一个值:");
                DoWork();
            }
        }
    }

}
