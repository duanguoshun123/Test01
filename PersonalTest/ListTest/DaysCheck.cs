using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ListTest
{
    public class DaysCheck
    {
        /// <summary>
        /// 判断是否是周六,周天
        /// </summary>
        /// <param name="y"></param>
        /// <param name="m"></param>
        /// <param name="d"></param>
        /// <returns></returns>
        public  static bool Whether_Weekend(int y, int m, int d)
        {
            if (m == 1 || m == 2)
            {
                m += 12;
                y--;
            }
            int week = (d + 2 * m + 3 * (m + 1) / 5 + y + y / 4 - y / 100 + y / 400) % 7; // 基姆拉尔森公式 
            if (week == 5 || week == 6)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        /// <summary>
        /// 判断是否是周六,周天
        /// </summary>
        /// <param name="y"></param>
        /// <param name="m"></param>
        /// <param name="d"></param>
        /// <returns></returns>
        public static string GetDays()
        {
            var days = "";
            switch (DateTime.Now.DayOfWeek)
            {
                case DayOfWeek.Sunday:
                    days = "星期日";
                    break;
                case DayOfWeek.Monday:
                    days = "星期一";
                    break;
                case DayOfWeek.Tuesday:
                    days = "星期二";
                    break;
                case DayOfWeek.Wednesday:
                    days = "星期三";
                    break;
                case DayOfWeek.Thursday:
                    days = "星期四";
                    break;
                case DayOfWeek.Friday:
                    days = "星期五";
                    break;
                case DayOfWeek.Saturday:
                    days = "星期六";
                    break;
                default:
                    break;
            }
            return days;
        }
    }
}
