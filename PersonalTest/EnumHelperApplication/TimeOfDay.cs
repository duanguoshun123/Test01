using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EnumHelperApplication
{
    public enum TimeOfDay
    {
        [Description("上午")]
        Moning,
        [Description("下午")]
        Afternoon,
        [Description("晚上")]
        Evening,
    }
}
