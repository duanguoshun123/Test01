using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WebApi.Models;

namespace WebApi.Interface
{
    public interface IProduct : IDependency
    {
        IList<Product> GetList();
        Product GetById(int id);
        void Add(Product dto);
        void Update(Product dto);
        void Delete(int id);

    }
}
