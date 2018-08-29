using Enyim.Caching;
using Enyim.Caching.Configuration;
using Enyim.Caching.Memcached;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace EnyimMemcachedHelper
{
    public class DataCatch
    {
        private static MemcachedClient MemClient;
        static readonly object padlock = new object();
        public static MemcachedClient GetInstance()
        {
            if (MemClient == null)
            {
                lock (padlock)
                {
                    if (MemClient == null)
                    {
                        MemClientInit();
                    }
                }
            }
            return MemClient;
        }
        static void MemClientInit()
        {
            try
            {
                ////初始化缓存
                MemcachedClientConfiguration memConfig = new MemcachedClientConfiguration();
                //IPAddress newaddress = IPAddress.Parse(Dns.GetHostEntry("ocs.m.cnhzalicm10pub001.ocs.aliyuncs.com").AddressList[0].ToString()); //xxxx替换为ocs控制台上的“内网地址”
                //IPEndPoint ipEndPoint = new IPEndPoint(newaddress, 11211);
                //// 配置文件 - ip
                //memConfig.Servers.Add(ipEndPoint);
                //memConfig.AddServer("localhost:11211");
                //// 配置文件 - 协议
                //memConfig.Protocol = MemcachedProtocol.Binary;
                //// 配置文件-权限，如果使用了免密码功能，则无需设置userName和password
                //memConfig.Authentication.Type = typeof(PlainTextAuthenticator);
                //memConfig.Authentication.Parameters["zone"] = "";
                //memConfig.Authentication.Parameters["userName"] = "guoshun.duan";
                //memConfig.Authentication.Parameters["password"] = "duan123";
                ////下面请根据实例的最大连接数进行设置
                //memConfig.SocketPool.MinPoolSize = 5;
                //memConfig.SocketPool.MaxPoolSize = 200;
                //MemClient = new MemcachedClient(memConfig);
                MemClient = new MemcachedClient();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// memcached缓存数据
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="mc"></param>
        /// <param name="key"></param>
        /// <param name="exp">过期时间</param>
        public static bool StoreCache(Object dt, MemcachedClient mc, String key, int exp)
        {
            var finish = mc.Store(StoreMode.Set, key, dt, DateTime.Now.AddDays(exp));
            return finish;
        }

        /// <summary>
        /// 获取缓存数据
        /// </summary>
        /// <param name="key">缓存键</param>
        /// <returns></returns>
        public static object GetCache(string key)
        {
            var mc = GetInstance();
            object obj = mc.Get(key);
            return obj;
        }
        /// <summary>
        /// 获取缓存数据 泛型
        /// </summary>
        /// <param name="key">缓存键</param>
        /// <returns></returns>
        public static T GetCache<T>(string key)
        {
            var mc = GetInstance();
            T obj = mc.Get<T>(key);
            return obj;
        }
        /// <summary>
        /// 获取缓存数据 
        /// </summary>
        /// <param name="key">缓存键数组</param>
        /// <returns></returns>
        public static IDictionary<string, object> GetCache(IEnumerable<string> key)
        {
            var mc = GetInstance();
            IDictionary<string, object> obj = mc.Get(key);
            return obj;
        }
        /// <summary>
        /// 设置缓存
        /// </summary>
        /// <param name="key">缓存键</param>
        /// <param name="obj">缓存对象</param>
        /// <param name="exp">缓存天数</param>
        public static bool SetCache(string key, object obj, int exp)
        {
            var mc = GetInstance();
            return StoreCache(obj, mc, key, exp);
        }
        /// <summary>
        /// 清空缓存服务器上的缓存
        /// </summary>
        public static void FlushCache()
        {
            MemcachedClient mc = GetInstance();

            mc.FlushAll();
        }
        /// <summary>
        /// 删除指定缓存
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool Remove(string key)
        {
            MemcachedClient mc = GetInstance();

            return mc.Remove(key);
        }
    }
}
