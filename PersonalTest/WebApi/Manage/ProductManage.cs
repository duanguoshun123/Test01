using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApi.Interface;
using WebApi.Models;

namespace WebApi.Manage
{
    public class ProductManage : IProduct
    {
        public List<Product> lists = new List<Product>()
        {
            new Product()
            {
                Id=1,
                Orin="上海",
                ProductName="机器人",
                SNumber="ID2018001"
            },
             new Product()
            {
                Id=2,
                Orin="北京",
                ProductName="手机",
                SNumber="ID2018002"
            },
              new Product()
            {
                Id=3,
                Orin="广州",
                ProductName="电脑",
                SNumber="ID2018003"
            },
               new Product()
            {
                Id=1,
                Orin="安徽",
                ProductName="书包",
                SNumber="ID2018004"
            },
        };
        public void Add(Product dto)
        {
            throw new NotImplementedException("未实现");
        }
        public IList<Product> GetList()
        {
            return lists;
        }
        public Product GetById(int id)
        {
            return lists.Find(x => x.Id == id);
        }

        public void Update(Product dto)
        {
            throw new NotImplementedException("未实现");
        }

        public void Delete(int id)
        {
            throw new NotImplementedException("未实现");
        }
    }
}