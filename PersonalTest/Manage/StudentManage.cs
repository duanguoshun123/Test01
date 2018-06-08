﻿using System;
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
        public StudtentDA studentDA = new StudtentDA();
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
        public List<Students> GetAllStudents()
        {
            return studentDA.GetAllStudents() ?? new List<Students>();
        }
    }
}
