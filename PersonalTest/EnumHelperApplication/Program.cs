using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EnumHelperApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            TimeOfDay time = TimeOfDay.Afternoon;
            Console.WriteLine(time.ToString());

            TimeOfDay time2 = (TimeOfDay)Enum.Parse(typeof(TimeOfDay), "afternoon", true);
            Console.WriteLine((int)time2);
            // Enum.GetValues(typeof(TimeOfDay)) 获得枚举下的所有值
            // Enum.GetNames(typeof(TimeOfDay)) 获得枚举下所有名称
            var str1 = Enum.GetName(typeof(TimeOfDay), 0);
            Console.WriteLine(str1);

            var nvc = EnumHeplerMethod.GetNVCFromEnumValue(typeof(TimeOfDay));

            var roles = EnumsRoles.User | EnumsRoles.SupAdmin;
            // 去掉一个枚举两种方法 
            var role1 = roles ^ EnumsRoles.SupAdmin;
            var role2 = roles & (~EnumsRoles.SupAdmin);
            Console.WriteLine(roles + ";" + role1 + ";" + role2);
        }
    }
}
