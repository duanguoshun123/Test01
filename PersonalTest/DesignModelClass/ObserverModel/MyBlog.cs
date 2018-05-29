using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.ObserverModel
{
    public class MyBlog : Blog
    {
        public MyBlog(string symbol, string info)
               : base(symbol, info)
        {

        }
    }
}
