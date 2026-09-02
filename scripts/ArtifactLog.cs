using System;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A stand-in for log4net.
    ///
    /// The ported artifact code logs the way DOLSharp logs -- a static ILog
    /// per class, guarded by IsInfoEnabled and friends. The server's script
    /// compiler does not reference log4net, and none of the other scripts in
    /// this directory use it, so rather than strip several dozen log
    /// statements out of code we want to keep readable against its upstream,
    /// this gives them somewhere to go.
    ///
    /// The first attempt did strip them, and left "if (log.IsInfoEnabled)"
    /// with no body -- which is what a blunt regex does to real code.
    /// </summary>
    public interface ILog
    {
        bool IsInfoEnabled { get; }
        bool IsWarnEnabled { get; }
        bool IsErrorEnabled { get; }
        bool IsDebugEnabled { get; }

        void Info(object message);
        void Warn(object message);
        void Error(object message);
        void Debug(object message);
        void Error(object message, Exception t);
        void Warn(object message, Exception t);

        // DOLSharp calls the Format variants in a few places.
        void ErrorFormat(string format, params object[] args);
        void WarnFormat(string format, params object[] args);
        void InfoFormat(string format, params object[] args);
        void DebugFormat(string format, params object[] args);
    }

    public class ArtifactLog : ILog
    {
        public static readonly ILog Instance = new ArtifactLog();

        public bool IsInfoEnabled => false;
        public bool IsWarnEnabled => true;
        public bool IsErrorEnabled => true;
        public bool IsDebugEnabled => false;

        public void Info(object message) { }
        public void Debug(object message) { }

        public void Warn(object message)
        {
            Console.WriteLine("[artifacts] " + message);
        }

        public void Error(object message)
        {
            Console.WriteLine("[artifacts] ERROR " + message);
        }

        public void Warn(object message, Exception t)
        {
            Console.WriteLine("[artifacts] " + message + " :: " + t);
        }

        public void Error(object message, Exception t)
        {
            Console.WriteLine("[artifacts] ERROR " + message + " :: " + t);
        }

        public void ErrorFormat(string format, params object[] args)
        {
            Console.WriteLine("[artifacts] ERROR " + string.Format(format, args));
        }

        public void WarnFormat(string format, params object[] args)
        {
            Console.WriteLine("[artifacts] " + string.Format(format, args));
        }

        public void InfoFormat(string format, params object[] args) { }
        public void DebugFormat(string format, params object[] args) { }
    }

    public static class LogManager
    {
        public static ILog GetLogger(Type t) => ArtifactLog.Instance;
        public static ILog GetLogger(string name) => ArtifactLog.Instance;
    }
}
