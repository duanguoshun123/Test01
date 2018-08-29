using DbFirst.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using IDA;
using Manage;
using WebApi.Interface;
using WebApi.Models;
using WebApi.Filter;

namespace WebApi.Controllers
{
    [RoutePrefix("user")]
    [WebApiExceptionFilter]
    public class UserController : ApiController
    {
        private readonly IUser userManage;
        public UserController(IUser userManager)
        {
            this.userManage = userManager;
        }
        /// <summary>
        /// 添加用户
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("")]
        public void AddUser(User dto)
        {
            userManage.Add(dto);
        }
        [HttpPut]
        [Route("{id}")]
        public HttpResponseMessage Update(int id, [FromBody]User dto)
        {
            User _dto = null;
            try
            {
                if (id.ToString() != dto.UserId)
                {
                    throw new Exception("不存在该对象");
                }
                _dto = userManage.Update(dto);
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex.Message);
            }
            return Request.CreateResponse<User>(HttpStatusCode.OK, _dto);
        }
    }
}