using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;

namespace DeepShallowCopy
{
    public class DeepCopyAchieve
    {
        // 用一个字典来存放每个对象的反射次数来避免反射代码的循环递归
        static Dictionary<Type, int> typereflectionCountDic = new Dictionary<Type, int>();
        static object DeepCopyDemoClasstypeRef = null;
        private static int Add(Dictionary<Type, int> dict, Type key)
        {
            if (key.Equals(typeof(String)) || key.IsValueType) return 0;
            if (!dict.ContainsKey(key))
            {
                dict.Add(key, 1);
                return dict[key];
            }

            dict[key] += 1;
            return dict[key];
        }
        // 利用反射实现深拷贝
        public static T DeepCopyWithReflection<T>(T obj)
        {

            Type type = obj.GetType();

            // 如果是字符串或值类型则直接返回
            if (obj is string || type.IsValueType) return obj;

            if (type.IsArray)
            {
                Type elementType = Type.GetType(type.FullName.Replace("[]", string.Empty));
                var array = obj as Array;
                Array copied = Array.CreateInstance(elementType, array.Length);
                for (int i = 0; i < array.Length; i++)
                {
                    copied.SetValue(DeepCopyWithReflection(array.GetValue(i)), i);
                }

                return (T)Convert.ChangeType(copied, obj.GetType());
            }
            // 对于类类型开始记录对象反射的次数
            int reflectionCount = Add(typereflectionCountDic, obj.GetType());
            if (reflectionCount > 1 && obj.GetType() == typeof(DeepCopyDemoClass))
                return (T)DeepCopyDemoClasstypeRef; // 返回deepCopyClassB对象
            object retval = Activator.CreateInstance(obj.GetType());
            if (retval.GetType() == typeof(DeepCopyDemoClass))
                DeepCopyDemoClasstypeRef = retval; // 保存一开始创建的DeepCopyDemoClass对象
            PropertyInfo[] properties = obj.GetType().GetProperties(
                BindingFlags.Public | BindingFlags.NonPublic
                | BindingFlags.Instance | BindingFlags.Static);
            foreach (var property in properties)
            {
                var propertyValue = property.GetValue(obj, null);
                if (propertyValue == null)
                    continue;
                property.SetValue(retval, DeepCopyWithReflection(propertyValue), null);
            }

            return (T)retval;
        }
        // 利用XML序列化和反序列化实现
        public static T DeepCopyWithXmlSerializer<T>(T obj)
        {
            object retval;
            using (MemoryStream ms = new MemoryStream())
            {
                XmlSerializer xml = new XmlSerializer(typeof(T));
                xml.Serialize(ms, obj);
                ms.Seek(0, SeekOrigin.Begin);
                retval = xml.Deserialize(ms);
                ms.Close();
            }

            return (T)retval;
        }

        // 利用二进制序列化和反序列实现
        public static T DeepCopyWithBinarySerialize<T>(T obj)
        {
            object retval;
            using (MemoryStream ms = new MemoryStream())
            {
                BinaryFormatter bf = new BinaryFormatter();
                // 序列化成流
                bf.Serialize(ms, obj);
                ms.Seek(0, SeekOrigin.Begin);
                // 反序列化成对象
                retval = bf.Deserialize(ms);
                ms.Close();
            }

            return (T)retval;
        }

        // 利用DataContractSerializer序列化和反序列化实现
        public static T DeepCopy<T>(T obj)
        {
            object retval;
            using (MemoryStream ms = new MemoryStream())
            {
                DataContractSerializer ser = new DataContractSerializer(typeof(T));
                ser.WriteObject(ms, obj);
                ms.Seek(0, SeekOrigin.Begin);
                retval = ser.ReadObject(ms);
                ms.Close();
            }
            return (T)retval;
        }

        // 表达式树实现
        // ....
    }
}
