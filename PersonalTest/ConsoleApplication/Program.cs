﻿using IDA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Manage;
using DbFirst.Model;

namespace ConsoleApplication
{
    class Program
    {
        public static IStudentDA iStudentDA;
        static void Main(string[] args)
        {
            Console.WriteLine("请选择对应的数据库操作：A(数据库1)，B(数据库2)");
            var key01 = Console.ReadLine();
            if (key01 == "A")
            {
                iStudentDA = new StudentManage("StuAndCourse");
            }
            else if (key01 == "B")
            {
                iStudentDA = new StudentManage("StuAndCourse_Copy1");
            }
            else
            {
                Console.WriteLine("没有对应的数据库操作！");
                Console.ReadKey();
            }
            GetAllStudent();
            Console.WriteLine("请选择操作,I(添加),U(更新),D(删除),Q（查询所有）");
            var key = Console.ReadLine();
            var isContinue = true;
            while (isContinue)
            {
                if (key == "I")
                {
                    AddStudent();
                }
                else if (key == "U")
                {
                    UpdateStudent();
                }
                else if (key == "D")
                {
                    DeleteStudent();
                }
                else if (key == "Q")
                {
                    GetAllStudent();
                }
                else
                {
                    Console.WriteLine("输入的操作不合法，请重新输入");
                    isContinue = true;
                }
                isContinue = false;
            }


        }
        public static void GetAllStudent()
        {
            var students = iStudentDA.GetAllStudents().ToList();
            Console.WriteLine("ID\tName\tSex\tAge");
            for (int i = 0; i < students.Count; i++)
            {
                Console.WriteLine("{0}\t{1}\t{2}\t{3}", students[i].ID, students[i].stu_Name, students[i].stu_sex, students[i].stu_age);
            }
        }
        public static void AddStudent()
        {
            Console.WriteLine("是否添加一列，Y/N");
            Console.WriteLine("请输入姓名:");
            var name = Console.ReadLine();
            Console.WriteLine("请输入性别:");
            var sex = Console.ReadLine();
            Console.WriteLine("请输入年龄:");
            int age;
            while (!int.TryParse(Console.ReadLine(), out age))
            {
                Console.WriteLine("输入有效的年龄");
            }
            Console.WriteLine("请输入密码:");
            var pwd = Console.ReadLine();
            var stu = new Students() { stu_Name = name, stu_sex = sex, stu_age = age, stu_Pwd = pwd };
            if (iStudentDA.AddStudents(stu))
            {
                Console.WriteLine("添加成功");
                GetAllStudent();
                Console.WriteLine("是否继续添加，Y/N");
                if (Console.ReadLine() == "Y")
                {
                    Console.WriteLine("请选择对应的数据库操作：A(数据库1)，B(数据库2)");
                    var key01 = Console.ReadLine();
                    if (key01 == "A")
                    {
                        iStudentDA = new StudentManage("StuAndCourse");
                    }
                    else if (key01 == "B")
                    {
                        iStudentDA = new StudentManage("StuAndCourse_Copy1");
                    }
                    else
                    {
                        Console.WriteLine("没有对应的数据库操作！");
                        Console.ReadKey();
                    }
                    AddStudent();
                }
            }
            else
            {
                Console.WriteLine("添加失败");
            }
        }
        public static void UpdateStudent()
        {
            Console.WriteLine("请输入要更新的对象ID");
            int id;
            while (int.TryParse(Console.ReadLine(), out id))
            {
                if (iStudentDA.GetById(id) == null)
                {
                    Console.WriteLine("更新失败,不存在此对象,请重新输入");
                    continue;
                }
                Console.WriteLine("ID无效");
                Console.WriteLine("请输入姓名:");
                var name = Console.ReadLine();
                Console.WriteLine("请输入性别:");
                var sex = Console.ReadLine();
                Console.WriteLine("请输入年龄:");
                int age;
                while (!int.TryParse(Console.ReadLine(), out age))
                {
                    Console.WriteLine("输入有效的年龄");
                }
                Console.WriteLine("请输入密码:");
                var pwd = Console.ReadLine();
                var stu = new Students() { ID = id, stu_Name = name, stu_sex = sex, stu_age = age, stu_Pwd = pwd };
                try
                {
                    if (iStudentDA.UpdateStudents(stu))
                    {
                        Console.WriteLine("更新成功");
                        GetAllStudent();
                        Console.WriteLine("是否继续更新，Y/N");
                        if (Console.ReadLine() == "Y")
                        {
                            Console.WriteLine("请选择对应的数据库操作：A(数据库1)，B(数据库2)");
                            var key01 = Console.ReadLine();
                            if (key01 == "A")
                            {
                                iStudentDA = new StudentManage("StuAndCourse");
                            }
                            else if (key01 == "B")
                            {
                                iStudentDA = new StudentManage("StuAndCourse_Copy1");
                            }
                            else
                            {
                                Console.WriteLine("没有对应的数据库操作！");
                                Console.ReadKey();
                            }
                            UpdateStudent();
                        }
                    }
                    else
                    {
                        Console.WriteLine("更新失败");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("更新失败,{0}", ex.Message);
                }
            }
        }
        public static void DeleteStudent()
        {
            Console.WriteLine("请输入删除的对象ID");
            int id;
            while (!int.TryParse(Console.ReadLine(), out id))
            {
                Console.WriteLine("ID无效");
            }
            try
            {
                if (iStudentDA.DeleteStudents(id))
                {
                    Console.WriteLine("删除成功");
                    GetAllStudent();
                    Console.WriteLine("是否继续删除，Y/N");
                    if (Console.ReadLine() == "Y")
                    {
                        Console.WriteLine("请选择对应的数据库操作：A(数据库1)，B(数据库2)");
                        var key01 = Console.ReadLine();
                        if (key01 == "A")
                        {
                            iStudentDA = new StudentManage("StuAndCourse");
                        }
                        else if (key01 == "B")
                        {
                            iStudentDA = new StudentManage("StuAndCourse_Copy1");
                        }
                        else
                        {
                            Console.WriteLine("没有对应的数据库操作！");
                            Console.ReadKey();
                        }
                        DeleteStudent();
                    }
                }
                else
                {
                    Console.WriteLine("删除失败");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("删除失败,{0}", ex.Message);
                GetAllStudent();
            }


        }
    }
}
