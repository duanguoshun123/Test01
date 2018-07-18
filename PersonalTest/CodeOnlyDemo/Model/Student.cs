using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeOnlyDemo.Model
{
    public class Student
    {
        [Key]
        public int Id { get; set; }
        public string stu_Name { get; set; }
        public string stu_Pwd { get; set; }
        public string stu_sex { get; set; }
        public int stu_age { get; set; }
    }
}
