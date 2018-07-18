using CodeOnlyDemo.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeOnlyDemo.Context
{
    public class StuAndCourseContext : DbContext
    {
        public StuAndCourseContext()
            : base("name=ConnStuAndCourse")
        {

        }
        public DbSet<Student> Student { get; set; }
    }
}
