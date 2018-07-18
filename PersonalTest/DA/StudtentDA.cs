using DbFirst.DbContexts;
using DbFirst.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DA
{
    public class StudtentDA
    {
        CommonDbContext contexts;
        public StudtentDA(string connectionString)
        {
            contexts = new CommonDbContext(connectionString);
        }

        public int AddStudents(Students stu)
        {
            contexts.Students.Add(stu);
            return contexts.SaveChanges();

        }
        public int UpdateStudents(Students stu)
        {
            var stus = contexts.Students.Where(p => p.ID == stu.ID).FirstOrDefault();
            if (stus != null)
            {
                stus.stu_Name = stu.stu_Name;
                stus.stu_age = stu.stu_age;
                stus.stu_Pwd = stu.stu_Pwd;
                stus.stu_sex = stu.stu_sex;
                contexts.Students.Attach(stus);
                contexts.Entry<Students>(stus).State = System.Data.Entity.EntityState.Modified;
                return contexts.SaveChanges();
            }
            else
            {
                throw new Exception("无更新对象");
            }
        }
        public int DeleteStudents(int id)
        {
            var stu = contexts.Students.Where(p => p.ID == id).FirstOrDefault();
            if (stu != null)
            {
                contexts.Students.Attach(stu);
                contexts.Entry<Students>(stu).State = System.Data.Entity.EntityState.Deleted;
                return contexts.SaveChanges();
            }
            else
            {
                throw new Exception("无删除对象");
            }
        }
        public Students GetById(int id)
        {
            var stu = contexts.Students.Where(p => p.ID == id).FirstOrDefault();
            return stu;
        }
        public IEnumerable<Students> GetAllStudents()
        {
            var stu = contexts.Students;
            return stu;
        }
    }
}
