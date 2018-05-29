using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.ObserverModel
{
    // 委托充当订阅者接口类
    public delegate void NotifyEventHandler(object sender);
    public class Blog
    {
        public NotifyEventHandler NotifyEvent;
        public string Symbol { get; set; }//描写订阅号的相关信息
        public string Info { get; set; }//描写此次update的信息
        public Blog(string symbol, string info)
        {
            this.Symbol = symbol;
            this.Info = info;
        }

        #region 新增对订阅号列表的维护操作
        public void AddObserver(NotifyEventHandler ob)
        {
            NotifyEvent += ob;
        }
        public void RemoveObserver(NotifyEventHandler ob)
        {
            NotifyEvent -= ob;
        }

        #endregion

        public void Update()
        {
            if (NotifyEvent != null)
            {
                NotifyEvent(this);
            }
        }
    }
}
