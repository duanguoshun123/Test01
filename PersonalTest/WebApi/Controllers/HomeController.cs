using DbFirst.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using IDA;
using Manage;
namespace WebApi.Controllers
{
    public class HomeController : ApiController
    {
        public IStudentDA iStudentDA = new StudentManage();
        /// <summary>
        /// 获取学生
        /// </summary>
        /// <returns></returns>
        public IEnumerable<Students> Get()
        {
            return iStudentDA.GetAllStudents();
        }
        [HttpPost]
        // GET api/<controller>/5
        public bool AddStudent([FromBody]Students stu)
        {
            return iStudentDA.AddStudents(stu);
        }
    }
}