using Common.Log;
using Quartz;
using Quartz.Impl;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TimeJonClassLir
{
    public class JobScheduler
    {
        // 相关属性
        public static NameValueCollection props = new NameValueCollection();
        // 调度器工厂
        public static StdSchedulerFactory factory;
        // 调度器
        public static IScheduler scheduler;
        public static async Task Start()
        {
            try
            {
                // 测试
                LoggerHelper.Debug("调试器启动{0}", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                // 调度器配置
                props["quartz.scheduler.instanceName"] = "ServiceScheduler";
                props["quartz.threadPool.type"] = "Quartz.Simpl.SimpleThreadPool, Quartz";
                props["quartz.threadPool.threadCount"] = "10";
                props["quartz.jobStore.misfireThreshold"] = "60000";
                props["quartz.jobStore.type"] = "Quartz.Simpl.RAMJobStore, Quartz";
                props["quartz.serializer.type"] = "binary";
                props["quartz.plugin.xml.type"] = "Quartz.Plugin.Xml.XMLSchedulingDataProcessorPlugin,Quartz.Plugins";
                props["quartz.plugin.xml.fileNames"] = "~/quartz_jobs.xml";
                // 调度器工厂
                factory = new StdSchedulerFactory(props);
                //factory = new StdSchedulerFactory();
                scheduler = await factory.GetScheduler();

                //启动
                await scheduler.Start();
            }
            catch (SchedulerException ex)
            {
                LoggerHelper.Info("日志调度器异常：{0}", ex.Message);
            }

        }
        public static async Task Shutdown()
        {
            try
            {
                // 测试
                LoggerHelper.Debug("调试器关闭{0}", DateTime.Now.ToString("yyyy-MM-dd HH;mm;ss"));
                await scheduler.Shutdown();
            }
            catch (SchedulerException ex)
            {
                LoggerHelper.Info("日志调度器异常：{0}", ex.Message);
            }

        }
    }
}
