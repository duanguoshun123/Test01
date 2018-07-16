using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EnumHelperApplication
{
    [Flags]
    public enum EnumsRoles
    {
        /// <summary>
        /// 管理员
        /// </summary>
        Admin = 1,
        /// <summary>
        /// 普通用户
        /// </summary>
        User = 2,
        /// <summary>
        /// 系统管理员
        /// </summary>
        SysAdmin = 4,
        /// <summary>
        /// 超级系统管理员
        /// </summary>
        SupAdmin=8,
    }
}
