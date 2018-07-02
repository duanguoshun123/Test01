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

            Console.WriteLine(strFirst);
            Console.WriteLine(DaysCheck.GetDays());
        }
    }
}
