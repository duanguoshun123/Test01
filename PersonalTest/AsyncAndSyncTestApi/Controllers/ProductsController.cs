using AsyncAndSyncTestApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace AsyncAndSyncTestApi.Controllers
{
    public class ProductsController : ApiController
    {
        /* 
        * 微软的web api是在vs2012上的mvc4项目绑定发行的，它提出的web api是完全基于RESTful标准的， 
        * 完全不同于之前的（同是SOAP协议的）wcf和webService，它是简单，代码可读性强的，上手快的， 
        * 如果要拿它和web服务相比，我会说，它的接口更标准，更清晰，没有混乱的方法名称， 
        *  
        * 有的只有几种标准的请求，如get,post,put,delete等，它们分别对应的几个操作，下面讲一下： 
        * GET：生到数据列表（默认），或者得到一条实体数据 
        * POST：添加服务端添加一条记录，记录实体为Form对象 
        * PUT：添加或修改服务端的一条记录，记录实体的Form对象，记录主键以GET方式进行传输 
        * DELETE：删除 服务端的一条记录          
        */
        static readonly IProductRepository repository = new ProductRepository();

        public IEnumerable<Product> GetAllProducts()
        {
            return repository.GetAll();
        }

        public Product GetProduct(int id)
        {
            Product item = repository.Get(id);
            if (item == null)
            {
                throw new HttpResponseException(HttpStatusCode.NotFound);
            }
            return item;
        }

        public IEnumerable<Product> GetProductsByCategory(string category)
        {
            return repository.GetAll().Where(
                p => string.Equals(p.Category, category, StringComparison.OrdinalIgnoreCase));
        }

        public HttpResponseMessage PostProduct(Product item)
        {
            item = repository.Add(item);
            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent("add success", System.Text.Encoding.UTF8, "text/plain")
            };
        }

        public void PutProduct(int id, Product product)
        {
            product.Id = id;
            if (!repository.Update(product))
            {
                throw new HttpResponseException(HttpStatusCode.NotFound);
            }
        }

        public void DeleteProduct(int id)
        {
            repository.Remove(id);
        }
    }
}