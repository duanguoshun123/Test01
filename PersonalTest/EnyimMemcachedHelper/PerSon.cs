using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EnyimMemcachedHelper
{
    [Serializable]
    public class PerSon
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
    }
}
