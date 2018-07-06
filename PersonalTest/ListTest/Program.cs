using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace ListTest
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string> arrList = new List<string>() { "A", "ABC", "DEF", "ACFFF", "DJKJKJKJ" };
            string strFirst = arrList.Find(str =>
            {
                if (str.Length >= 5)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            });
            List<string> str2 = arrList.Where(str => str.Length >= 5).ToList();
            List<string> str3 = arrList.FindAll(str => str.Length >= 5).ToList();
            foreach (var item in str2)
            {
                Console.WriteLine(item);
            }
            foreach (var item in str3)
            {
                Console.WriteLine(item);
            }
            DateTime RestStartTime = new DateTime(2018, 7, 2, 18, 32, 50, 100);
            DateTime OtherRestStartTime = new DateTime(2018, 7, 2, 18, 32, 50, 500);
            TimeSpan times = RestStartTime - OtherRestStartTime;
            if (OtherRestStartTime.Ticks == RestStartTime.Ticks)
            {
                Console.WriteLine("相等");
            }
            else
            {
                if ((int)(times.TotalSeconds) == 0)
                {
                    Console.WriteLine("时分秒相等");
                }
                else
                {
                    Console.WriteLine("不相等,当前时间为:{0},RestStartTime当前时间为:{1}", DateTime.Now.Ticks, RestStartTime.Ticks);
                }
            }
            Console.WriteLine(strFirst);
            Console.WriteLine(DaysCheck.GetDays());
        }
    }
}
