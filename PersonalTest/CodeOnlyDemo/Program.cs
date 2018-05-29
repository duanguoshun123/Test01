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
            DemoContext dbContext = new DemoContext();
            dbContext.Database.CreateIfNotExists();//不存在的情况下会创建对应的数据库  
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new CustomerOrderDemo());
        }
    }
}
