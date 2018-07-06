using log4net.Config;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;

namespace Log4netApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                int y = 10;
                int x = 5 / y;
                Student stu = new Student();
                stu.Age = 12;
                LoggerHelper.Info("姓名：{0}，性别：{1}，年龄：{2}", stu.Name, stu.Sex, stu.Age);
                //序列化
                try
                {
                    FileStream fs = new FileStream("studentSerialiable.xml", FileMode.Create);
                    XmlSerializer xs = new XmlSerializer(typeof(Student));
                    xs.Serialize(fs, stu);
                    fs.Close();
                    LoggerHelper.Info("序列化成功! ");
                    Console.WriteLine("序列化成功！");
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }

                //反序列化
                try
                {
                    FileStream fs = new FileStream("studentSerialiable.xml", FileMode.Open, FileAccess.Read);
                    XmlSerializer xs = new XmlSerializer(typeof(Student));
                    Student s = (Student)xs.Deserialize(fs);
                    Console.WriteLine(s.Name + s.Sex + s.Age);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
                XmlSerializer xmlSerializer = new XmlSerializer(typeof(Class1));
                Class1 class1 = new Class1();
                MyClass2 myClass2 = new MyClass2();
                myClass2.BaseName = "base name";
                myClass2.Property2 = "property 2";
                class1.Property = myClass2;
                StringBuilder stringBuilder = new StringBuilder();

                using (XmlWriter xmlWriter = XmlWriter.Create(stringBuilder))
                {
                    xmlSerializer.Serialize(xmlWriter, class1);
                    Console.WriteLine(stringBuilder.ToString());
                }
            }
            catch (Exception ex)
            {
                LoggerHelper.Error("{0}失败", ex.Message);
            }
            LoggerHelper.Info("{0}成功", "数据调用");
            Console.WriteLine("日志写入完成");
        }
    }
}
