using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DA;
using IDA;
using DbFirst.Model;

namespace Manage
{
    public class StudentManage : IStudentDA
    {
        public StudtentDA studentDA;
        public StudentManage(string dbName)
        {
            studentDA = new StudtentDA("server =.; uid=sa;pwd=Miss20170129;database=" + dbName);
        }
        public bool AddStudents(Students stu)
        {
            int result = studentDA.AddStudents(stu);
            if (result > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public bool UpdateStudents(Students stu)
        {
            int result = studentDA.UpdateStudents(stu);
            if (result > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public bool DeleteStudents(int id)
        {
            int result = studentDA.DeleteStudents(id);
            if (result > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public Students GetById(int id)
        {
            return studentDA.GetById(id);
        }
        public IEnumerable<Students> GetAllStudents()
        {
            return studentDA.GetAllStudents();
        }
    }
}
