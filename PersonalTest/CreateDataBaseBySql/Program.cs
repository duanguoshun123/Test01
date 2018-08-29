using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CreateDataBaseBySql
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                ExecfileHelper ex = new ExecfileHelper();
                string baseUrl = AppDomain.CurrentDomain.BaseDirectory;
                for (int i = 0; i < 3; i++)
                    baseUrl = baseUrl.Substring(0, baseUrl.LastIndexOf('\\'));
                string filePath02 = baseUrl + "\\CreateDataOnly.sql";
                string filePath01 = baseUrl + "\\CreateSchemaOnly.sql";
                string readDbName = Console.ReadLine();
                string sqlStr = string.Format(@"IF NOT EXISTS (SELECT * FROM sys.databases WHERE name ='{0}')
				create database  {0}", readDbName);
                Console.WriteLine("脚本开始执行");
                ex.ExeceSql(sqlStr, ".", "", "", "master");
                ex.ExeceFile(filePath01, ".", "", "", readDbName);
                ex.ExeceFile(filePath02, ".", "", "", readDbName);
                Console.WriteLine("脚本执行成功");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.ReadKey();
            }
           
        }
    }
}
