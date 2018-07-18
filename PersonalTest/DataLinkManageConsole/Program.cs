using Dal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataLinkManageConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            DbHelper helper = new DbHelper();
            //helper.createConnection("MyConnection", "Data Source=.;Initial Catalog=StuAndCourse;Integrated Security=True;user id=sa;password=Miss20170129;", DbType.String);


            Students model = helper.ExcuteString(o => o.From("Students").Select().AndWhere("SAddNo", 1)).ToModel<Students>();
            Console.Read();
        }
    }
}
