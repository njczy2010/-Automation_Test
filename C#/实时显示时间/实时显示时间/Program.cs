using System;
using System.Collections.Generic;
//using System.Linq;
using System.Text;
using System.Threading;

namespace 实时显示时间
{
    class Program
    {
        static Program P = new Program();
        static void Main(string[] args)
        {
            while (true)
            {
                Thread thread = new Thread(new ThreadStart(P.ShowTime));
                thread.Start();
                Thread.Sleep(1000);
                thread.Abort();
            }
            //Console.Read();
        }
        private void ShowTime()
        {
            Console.Clear();
            DateTime dt = System.DateTime.Now;
            String now = dt.ToString();
            Console.WriteLine("当前时间：" + now);
        }
    }
}
