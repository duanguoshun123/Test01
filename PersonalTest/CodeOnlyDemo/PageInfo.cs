using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeOnlyDemo
{
    public class PageInfo
    {
        public event EventHandler PageChanged; //事件：控件的当前页码发生变更。  
        private int pageSize;
        private int curPage;
        private int pageCount;
        /// <summary>  
        /// [属性]每页显示记录数。  
        /// </summary> 
        public int PageSize
        {
            get
            {
                if (pageSize <= 0)
                {
                    pageSize = 10;
                }
                return pageSize;
            }
            set
            {
                pageSize = value;
            }
        }

        /// <summary>  
        /// 当前页数  
        /// </summary>  
        public int CurPage
        {
            get
            {
                if (curPage <= 0)
                {
                    curPage = 1;
                }
                return curPage;
            }
            set
            {
                curPage = value;
                if (PageChanged != null)
                {
                    //SafeRaise.Raise(PageChanged, null);//触发当件页码变更事件。  
                }
            }
        }
        /// <summary>  
        /// [属性]总页数。  
        /// </summary>  
        public int PageCount
        {
            get
            {
                if (RecordCount > 0)
                {
                    int pageCount = RecordCount / PageSize;
                    if (RecordCount % PageSize == 0)
                    {
                        pageCount = RecordCount / PageSize;
                    }

                    else
                    {
                        pageCount = RecordCount / PageSize + 1;
                    }
                    return pageCount;
                }
                else
                {
                    return 0;
                }
            }
            set
            {
                pageCount = value;
            }
        }

        /// <summary>  
        /// [属性]总记录数。  
        /// </summary>  
        public int RecordCount
        {
            get;
            set;
        }

        /// <summary>  
        /// [属性]相对于当前页的上一页  
        /// </summary>  
        public int PrevPage
        {
            get
            {
                if (CurPage > 1)
                {
                    return CurPage - 1;
                }
                return 1;
            }
        }

        /// <summary>  
        /// [属性]相对于当前页的下一页  
        /// </summary>  
        public int NextPage
        {
            get
            {
                if (CurPage < PageCount)
                {
                    return CurPage + 1;
                }
                return PageCount;
            }
        }
    }
}
