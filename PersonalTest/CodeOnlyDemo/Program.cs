using CodeOnlyDemo.Context;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CodeOnlyDemo
{
    static class Program
    {
        /// <summary>  
        /// 应用程序的主入口点。  
        /// </summary>  
        [STAThread]
        static void Main()
        {
            List<string> strArr = new List<string>() { "小芳", "国顺", "婷婷", "小荟" };
            var name = strArr.GetRandomStr();
            StuAndCourseContext dbStuAndCourseContext = new StuAndCourseContext();
            dbStuAndCourseContext.Database.CreateIfNotExists();//不存在的情况下会创建对应的数据库  
            var id = dbStuAndCourseContext.Student.Where(p => p.stu_Name == name).Select(p => p.Id).FirstOrDefault();
            var dbName = "";
            if (id == 2)
            {
                dbName = "CodeFirstDemoDb";
            }
            else
            {
                dbName = "CodeFirstDemoDB_Copy1";
            }
            var connectStr = DemoContext.GetConnection(dbName);
            DemoContext dbContext = new DemoContext(connectStr);
            var list = dbContext.customer.ToList();
            list.ForEach(x =>
            {
                Console.WriteLine(x.Id + "\r" + x.Name + "\r" + x.Password);
            });
            dbContext.Database.CreateIfNotExists();//不存在的情况下会创建对应的数据库  
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Console.WriteLine();
            //Application.Run(new CustomerOrderDemo());
        }
        static string GetRandomStr(this List<string> strArr)
        {
            Random rnd = new Random();
            int index = rnd.Next(strArr.Count);
            return strArr[index];
        }
    }
}
