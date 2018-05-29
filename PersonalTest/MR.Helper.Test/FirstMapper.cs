using Microsoft.Hadoop.MapReduce;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MR.Helper.Test
{
    public class FirstMapper : MapperBase
    {
        public override void Map(string inputLine, MapperContext context)
        {
            // 输入
            int inputValue = int.Parse(inputLine);
            // 任务
            var sqrt = Math.Sqrt(inputValue);
            // 写入输出
            context.EmitKeyValue(inputValue.ToString(), sqrt.ToString());
        }
    }
}
