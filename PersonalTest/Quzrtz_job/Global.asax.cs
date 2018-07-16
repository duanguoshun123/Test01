using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Routing;
using TimeJonClassLir;
namespace Quzrtz_job
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);

            //注册定时任务
            TimeJonClassLir.JobScheduler.Start().GetAwaiter().GetResult();
        }
        protected void Application_End(object sender, EventArgs e)
        {
            // 在应用程序关闭时运行的代码
            // 注册定时任务
            TimeJonClassLir.JobScheduler.Shutdown().GetAwaiter().GetResult();
        }
    }
}
