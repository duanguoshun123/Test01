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
    [RoutePrefix("product")]
    [WebApiExceptionFilter]
    public class ProductController : ApiController
    {
        private readonly IProduct productManage;
        public ProductController(IProduct productManager)
        {
            this.productManage = productManager;
        }
        /// <summary>
        /// 添加用户
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("Addproduct")]
        public void Addproduct(Product dto)
        {
            productManage.Add(dto);
        }
        [HttpPut]
        [Route("Update/{id}")]
        public HttpResponseMessage Update(int id, [FromBody]Product dto)
        {
            try
            {
                if (id != dto.Id)
                {
                    throw new Exception("不存在该对象");
                }
                productManage.Update(dto);
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex.Message);
            }
            return Request.CreateResponse<Product>(HttpStatusCode.OK, dto);
        }
        /// <summary>
        /// 获取产品列表
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("GetByList")]
        public HttpResponseMessage GetByList()
        {
            var productList = productManage.GetList();
            return Request.CreateResponse<IList<Product>>(HttpStatusCode.OK, productList);
        }
        /// <summary>
        /// 获取产品列表
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("GetById/{Id}")]
        public HttpResponseMessage GetById([FromUri]int id)
        {
            var product = productManage.GetById(id);
            return Request.CreateResponse<Product>(HttpStatusCode.OK, product);
        }
    }
}