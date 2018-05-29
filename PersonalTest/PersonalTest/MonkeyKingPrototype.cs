using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PersonalTest
{
    public abstract class MonkeyKingPrototype
    {
        public string Id { get; set; }
        public MonkeyKingPrototype(string id)
        {
            this.Id = id;
        }

        // 克隆方法，即孙大圣说“变”
        public abstract MonkeyKingPrototype Clone();
    }
}
