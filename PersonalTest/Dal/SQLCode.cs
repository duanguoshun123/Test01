using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public class SQLCode : IDbCode
    {
        string Object;
        StringBuilder ExcuteString = new StringBuilder();
        List<SqlParameter> paras;
        Dictionary<string, List<PropertyInfo>> pro;
        static string[] s = { "select", "delect", "update", "insert" };

        public SQLCode()
        {
            paras = new List<SqlParameter>();
        }
        public SQLCode(Dictionary<string, List<PropertyInfo>> pro)
        {
            paras = new List<SqlParameter>();
            this.pro = pro;
        }
        public SQLCode(List<SqlParameter> paras, Dictionary<string, List<PropertyInfo>> pro)
        {
            this.paras = paras;
            this.pro = pro;
        }
        public IDbCode From(object Object)
        {
            Type t = Object.GetType();
            if (t.Name.ToLower().Equals("string"))
            {
                this.Object = Object.ToString();
            }
            else
            {
                this.Object = t.Name;
            }

            return this;
        }

        public IDbCode Select(string Fields = "*")
        {
            if (this.Object.Length <= 0)
                return this;
            if (!Check(0))
                return this;
            ExcuteString.AppendLine("select " + Fields + " from " + this.Object);
            ExcuteString.AppendLine(" where 1 = 1 ");
            return this;
        }

        bool Check(int Type)
        {
            int flag = 0;
            string b = ExcuteString.ToString();
            for (int i = 0; i < s.Length; i++)
                if (i != Type)
                    flag += b.Contains(s[i]) ? 1 : 0;
            return flag == 0;
        }

        public IDbCode Delete()
        {
            if (Object.Length <= 0)
                return this;
            if (!Check(1))
                return this;
            ExcuteString.AppendLine("delete " + this.Object);
            ExcuteString.AppendLine(" where 1 = 1 ");
            return this;
        }

        public IDbCode Update(object model, string Fields = "")
        {
            if (this.Object.Length <= 0)
                return this;
            if (!Check(2))
                return this;

            Type t = model.GetType();
            if (t.Name != Object)
                return this;

            ExcuteString.AppendLine("update " + this.Object + " set ");

            List<PropertyInfo> p;
            if (pro.ContainsKey(t.Name))
            {
                p = pro[t.Name];
            }
            else
            {
                p = t.GetProperties().ToList();
                pro.Add(t.Name, p);
            }
            string f = "";
            if (Fields.Length == 0)
            {
                p.ForEach(o =>
                {
                    f += o.Name + " = @" + o.Name;
                    paras.Add(new SqlParameter(o.Name, o.GetValue(model, null)));
                });
            }
            else
            {
                string[] a = Fields.Split(',');

                p.ForEach(o =>
                {
                    if (a.Contains(o.Name))
                    {
                        f += o.Name + " = @" + o.Name + ",";
                        paras.Add(new SqlParameter(o.Name, o.GetValue(model, null)));
                    }
                });
            }
            ExcuteString.AppendLine(f);
            ExcuteString.AppendLine("where 1 = 1");

            return this;
        }

        public IDbCode Insert(object model, string Fields = "")
        {
            if (this.Object.Length <= 0)
                return this;
            if (!Check(3))
                return this;

            Type t = model.GetType();
            if (t.Name != Object)
                return this;

            ExcuteString.AppendLine("insert " + this.Object);

            List<PropertyInfo> p;
            if (pro.ContainsKey(t.Name))
            {
                p = pro[t.Name];
            }
            else
            {
                p = t.GetProperties().ToList();
                pro.Add(t.Name, p);
            }

            string f = "( ";
            string f1 = "values( ";

            if (Fields.Length == 0)
            {
                p.ForEach(o =>
                {
                    f += o.Name + ",";
                    paras.Add(new SqlParameter(o.Name, o.GetValue(model, null)));
                    f1 += "@" + o.Name + ",";
                });
            }
            else
            {
                string[] a = Fields.Split(',');

                p.ForEach(o =>
                {
                    if (a.Contains(o.Name))
                    {
                        f += o.Name + ",";
                        paras.Add(new SqlParameter(o.Name, o.GetValue(model, null)));
                        f1 += "@" + o.Name + ",";
                    }
                });
            }
            f = f.Remove(f.LastIndexOf(','), 1) + " ) ";
            f1 = f1.Remove(f1.LastIndexOf(','), 1) + " ) ";
            ExcuteString.AppendLine(f);
            ExcuteString.AppendLine(f1);
            return this;
        }

        public IDbCode AndWhere(string Where)
        {
            ExcuteString.AppendLine(" and " + Where);
            return this;
        }

        public IDbCode AndWhere(string Field, object Value)
        {
            ExcuteString.AppendLine(" and " + Field + " = @" + Field);
            paras.Add(new SqlParameter(Field, Value));
            return this;
        }

        public IDbCode AndWhere(string Field, Func<IDbCode, string> Select)
        {
            ExcuteString.AppendLine(" and " + Field + " in " + Select(new SQLCode(this.paras, this.pro)));
            return this;
        }

        public IDbCode AndWhere<T>(string Field, List<T> Values)
        {
            string value = "(";

            Values.ForEach(o =>
            {
                value += o + ",";
            });
            ExcuteString.AppendLine(" and " + Field + " in " + value.Remove(value.LastIndexOf(','), 1) + ")");
            return this;
        }

        public IDbCode OrWhere(string Where)
        {
            ExcuteString.AppendLine(" or " + Where);
            return this;
        }

        public IDbCode OrWhere(string Field, object Value)
        {
            ExcuteString.AppendLine(" or " + Field + " = @" + Field);
            paras.Add(new SqlParameter(Field, Value));
            return this;
        }

        public IDbCode OrWhere(string Field, Func<IDbCode, string> Select)
        {
            ExcuteString.AppendLine(" or " + Field + " in " + Select(new SQLCode(this.paras, this.pro)));
            return this;
        }

        public IDbCode OrWhere<T>(string Field, List<T> Values)
        {
            string value = "(";

            Values.ForEach(o =>
            {
                value += o + ",";
            });
            ExcuteString.AppendLine(" or " + Field + " in " + value.Remove(value.LastIndexOf(','), 1) + ")");
            return this;
        }

        public IDbCode Top(int topCount)
        {
            if (!ExcuteString.ToString().Contains(s[0]))
                return this;
            ExcuteString.Replace("select", "select top " + topCount + " ");
            return this;
        }

        bool CheckHasOrderBy()
        {
            return this.ExcuteString.ToString().Contains("order by");
        }
        public IDbCode OrderByAsc(string Field)
        {
            if (CheckHasOrderBy())
                ExcuteString.AppendLine("," + Field + " asc");
            else
                ExcuteString.AppendLine(" order by " + Field + " asc");

            return this;
        }

        public IDbCode OrderByDesc(string Field)
        {
            if (CheckHasOrderBy())
                ExcuteString.AppendLine("," + Field + " desc");
            else
                ExcuteString.AppendLine(" order by " + Field + " desc");

            return this;
        }

        public IDbCode ForMulTable(string Fields)
        {
            List<string> tables = this.Object.Split(',').ToList();
            Fields.Split(',').ToList().ForEach(o =>
            {
                for (int i = 0; i < tables.Count - 1; i++)
                {
                    ExcuteString.AppendLine(" and " + tables[i] + "." + o + " = " + tables[i + 1] + "." + o);
                }
            });
            return this;
        }

        public override string ToString()
        {
            return this.ExcuteString.ToString();
        }

        public IDbCode Clear()
        {
            pro.Clear();
            return this;
        }


        public IDbCode CreateCode(string sql)
        {
            ExcuteString.AppendLine(sql);
            return this;
        }

        public object Paras
        {
            get
            {
                return this.paras;
            }
        }


        public void Dispose()
        {
            this.pro = null;
        }
    }
}
