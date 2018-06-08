using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DbFirst.Model;
namespace IDA
{
    public interface IStudentDA
    {
        bool AddStudents(Students stu);
        bool UpdateStudents(Students stu);
        bool DeleteStudents(int id);
        List<Students> GetAllStudents();
    }
}
