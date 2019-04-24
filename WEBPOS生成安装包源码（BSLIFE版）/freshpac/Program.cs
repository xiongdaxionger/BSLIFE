using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace freshpac
{
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点。
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            bool Running = false;

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            MainForm mainfrom = new MainForm();

            try
            {
                System.Threading.Mutex mutex = new System.Threading.Mutex(false, "ThisShouldOnlyRunOnce");
                Running = !mutex.WaitOne(0, false);
            }
            catch { }

            if (!Running)
            {
                if (args.Length > 0)
                    mainfrom.ShopID = args[0].ToString();
                //else
                //{
                //    MessageBox.Show("请先插入U key！", "提示！");
                //    return;
                //}

                Application.Run(mainfrom);
            }
            else
            {
                MessageBox.Show("程序正在运行...", "温馨提示！");
            }
        }
    }
}