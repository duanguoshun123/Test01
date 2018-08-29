using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NLogHelper
{
    public class NLogHelperFunc
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();
        public void LoggerInfo(string msg)
        {
            logger.Info(msg);
        }
        public void LoggerInfo(string format,params object[] arg)
        {
            logger.Info(format,arg);
        }
        public void LoggerErr(string msg)
        {
            logger.Error(msg);
        }
        public void LoggerErr(string format, params object[] arg)
        {
            logger.Error(format, arg);
        }
        public void LoggerWarn(string msg)
        {
            logger.Warn(msg);
        }
        public void LoggerWarn(string format, params object[] arg)
        {
            logger.Warn(format, arg);
        }
        public void LoggerDebug(string msg)
        {
            logger.Debug(msg);
        }
        public void LoggerDebug(string format, params object[] arg)
        {
            logger.Debug(format, arg);
        }
    }
}
