using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Log4netApplication
{
    public class LoggerHelper
    {
        private static ILog Log { get; set; }
        private static readonly ILog logErr = LogManager.GetLogger("Err");
        private static StackTrace stackTrace;
        /// <summary>
        /// 记录正常的消息
        /// </summary>
        /// <param name="msg">消息内容</param>
        public static void Info(string msg)
        {
            stackTrace = new StackTrace();
            Log = LogManager.GetLogger(string.Format("类名:{0},方法名:{1}", stackTrace.GetFrame(1).GetMethod().ReflectedType.Name, stackTrace.GetFrame(1).GetMethod().Name));
            Log.Info(msg);
        }
        /// <summary>
        /// 记录正常的信息
        /// </summary>
        /// <param name="format"></param>
        /// <param name="args"></param>
        public static void Info(string format, params object[] args)
        {
            stackTrace = new StackTrace();
            Log = LogManager.GetLogger(string.Format("类名:{0},方法名:{1}", stackTrace.GetFrame(1).GetMethod().ReflectedType.Name, stackTrace.GetFrame(1).GetMethod().Name));
            Log.InfoFormat(format, args);
        }
        /// <summary>
        /// 记录异常信息
        /// </summary>
        /// <param name="msg">异常信息内容</param>
        public static void Error(string msg)
        {
            stackTrace = new StackTrace();
            Log = LogManager.GetLogger(string.Format("类名:{0},方法名:{1}", stackTrace.GetFrame(1).GetMethod().ReflectedType.Name, stackTrace.GetFrame(1).GetMethod().Name));
            Log.Error(msg);
        }
        /// <summary>
        /// 记录异常信息
        /// </summary>
        /// <param name="msg">异常信息内容</param>
        public static void Error(string format, params object[] args)
        {
            stackTrace = new StackTrace();
            Log = LogManager.GetLogger(string.Format("类名:{0},方法名:{1}", stackTrace.GetFrame(1).GetMethod().ReflectedType.Name, stackTrace.GetFrame(1).GetMethod().Name));
            Log.ErrorFormat(format, args);
        }
        /// <summary>
        /// 记录调试信息
        /// </summary>
        /// <param name="msg">异常信息内容</param>
        public static void Debug(string msg)
        {
            stackTrace = new StackTrace();
            Log = LogManager.GetLogger(string.Format("类名:{0},方法名:{1}", stackTrace.GetFrame(1).GetMethod().ReflectedType.Name, stackTrace.GetFrame(1).GetMethod().Name));
            Log.Debug(msg);
        }
        /// <summary>
        /// 记录调试信息
        /// </summary>
        /// <param name="msg">异常信息内容</param>
        public static void Debug(string format, params object[] args)
        {
            stackTrace = new StackTrace();
            Log = LogManager.GetLogger(string.Format("类名:{0},方法名:{1}", stackTrace.GetFrame(1).GetMethod().ReflectedType.Name, stackTrace.GetFrame(1).GetMethod().Name));
            Log.DebugFormat(format, args);
        }
    }


}
