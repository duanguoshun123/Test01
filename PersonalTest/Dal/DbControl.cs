using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public class DbControl
    {
        //数据库服务
        private static Dictionary<string, IDbInstance> Server = new Dictionary<string, IDbInstance>();
        //存放缓存
        private static Dictionary<string, List<PropertyInfo>> pro = new Dictionary<string, List<PropertyInfo>>();
        private static DbControl control = new DbControl();
        public static DbControl getInstance()
        {
            return control;
        }
        private DbControl()
        {

        }
        public IDbInstance createInstance(string Name, string ConnectionString, string type)
        {
            string nspace = typeof(IDbInstance).Namespace;
            Type t = Type.GetType(nspace + "." + type);
            object obj = Activator.CreateInstance(t, new object[] { Name, pro, ConnectionString });

            IDbInstance instance = obj as IDbInstance;

            Server.Add(Name, instance);

            return instance;
        }

        public IDbInstance this[string Name]
        {
            get
            {
                if (Server.ContainsKey(Name))
                    return Server[Name];
                else
                    return null;
            }
        }
    }
}
