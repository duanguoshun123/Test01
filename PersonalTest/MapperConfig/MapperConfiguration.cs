using RobotMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapperConfig
{
    public static class MapperConfiguration
    {
        public static void Start()
        {
            Mapper.Initialize(ct =>
            {
          
            });
        }
    }
}
