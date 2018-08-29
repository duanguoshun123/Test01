using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApi.Interface;
using WebApi.Models;
namespace WebApi.Manage
{
    public class UserManage : IUser
    {
        public void Add(User createDto)
        {
            throw new NotImplementedException();
        }

        public User Update(User updateDto)
        {
            return updateDto;
        }

        public void Delete(int id)
        {
            throw new NotImplementedException();
        }
    }
}