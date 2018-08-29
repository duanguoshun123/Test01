using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WebApi.Models;

namespace WebApi.Interface
{
    public interface IUser : IDependency
    {
        void Add(User createDto);
        User Update(User updateDto);
        void Delete(int id);
    }
}
