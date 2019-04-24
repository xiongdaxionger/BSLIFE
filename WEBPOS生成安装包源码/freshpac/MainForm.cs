using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Threading;
using cwber;

namespace freshpac
{
    public partial class MainForm : Form
    {
        public string ShopID = "";
        protected string username = "";
        protected string pwd = "";

        protected Thread t = null;
        SoftKeyPWD skp = new SoftKeyPWD();
        public static string KeyPath;

        public delegate void MyInvoke();

        public MainForm()
        {
            try
            {
                InitializeComponent();
            }
            catch (Exception ee)
            {
                MessageBox.Show(ee.Message);
                this.Close();
            }
        }

        protected bool waifingclose = false;
        protected override void WndProc(ref Message m)
        {
            if (m.WParam.ToInt32() == 103 && !waifingclose)
            {
                waifingclose = true;
                if (MessageBox.Show("关闭系统吗？", "提示！", MessageBoxButtons.OKCancel) == DialogResult.OK)
                {
                    try
                    {
                        if (t != null)
                            t.Abort();

                        webBrowser1.Dispose();
                    }
                    catch { }
                    t = null;
                    this.Close();
                }
                else
                    waifingclose = false;
            }
            base.WndProc(ref m);
        }

        protected void SetShopID()
        {
            try
            {
                string script = "document.getElementById(\"store\").value=" + ShopID + ";FreshPac_SetShop();";
                script += "try{";
                if (username != "")
                    script += "document.getElementsByName(\"uname\")[0].value=\"" + username + "\";";
                if (pwd != "")
                    script += "document.getElementsByName(\"password\")[0].value=\"" + pwd + "\";";
                script += "}catch(e){}";

                webBrowser1.ExecuteScript(script);
            }
            catch { }
        }

        void MyInit()
        {
            string Url = "http://xcfec.qsit.com.cn/index.php/pos"; //"http://www.freshpac.net/index.php/storepassport.html"  http://pos.pzfresh.com/index.php/storepassport.html

            webBrowser1.OpenUrl(Url);
            webBrowser1.DocumentCompletedEventHandler += new EventHandler(webBrowser1_DocumentCompletedEventHandler);
            
            if (Screen.AllScreens.Length > 1)
            {
                CusForm cusform = new CusForm("http://xcfec.qsit.com.cn/index.php/pos/cartshow");
                cusform.Left = Screen.GetBounds(this).Width;
                cusform.Show();
            }

            //webBrowser1.newWindowEventHandler += new NewWindowEventHandler(webBrowser1_newWindowEventHandler);
        }

        void webBrowser1_newWindowEventHandler(object sender, NewWindowEventArgs e)
        {
            
        }


        void webBrowser1_DocumentCompletedEventHandler(object sender, EventArgs e)
        {
            if (ShopID != "")
            {
                MyInvoke _myInvoke = new MyInvoke(SetShopID);
                this.Invoke(_myInvoke);
            }

            t = new Thread(new ThreadStart(GetKey));
            t.IsBackground = true;
            t.Start();
        }
        void GetKey()
        {
            while (true)
            {
                if (skp.FindPort(0, ref KeyPath) == 0)
                {
                    if (ShopID == "")
                    {
                        string outstring = "";
                        int r = skp.YReadString(ref outstring, 0, 6, "ffffffff", "ffffffff", KeyPath);
                        if (r == 0)
                        {
                            try
                            {
                                ShopID = Convert.ToInt32(outstring).ToString();
                            }
                            catch { }
                            try
                            {
                                skp.YReadString(ref username, 6, 20, "ffffffff", "ffffffff", KeyPath);
                                skp.YReadString(ref pwd, 26, 20, "ffffffff", "ffffffff", KeyPath);
                                username = username.Trim('').Trim();
                                pwd = pwd.Trim('').Trim();
                            }
                            catch { }
                        }

                        if (ShopID != "")
                        {
                            MyInvoke _myInvoke = new MyInvoke(SetShopID);
                            this.Invoke(_myInvoke);
                        }
                    }
                }
                else
                {
                    if (ShopID != "")
                    {
                        ShopID = "";

                        MyInvoke _myInvoke = new MyInvoke(SetShopID);
                        this.Invoke(_myInvoke);

                        MessageBox.Show("请插入加密锁！", "温馨提示！");
                    }
                }

                Thread.Sleep(1000);
            }
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            MyInit();

            try
            {
                HotKey.RegisterHotKey(Handle, 103, HotKey.KeyModifiers.None, Keys.Escape);
            }
            catch { }
        }

        public void softclose()
        {
            try
            {
                if (t != null)
                    t.Abort();

                webBrowser1.Dispose();
            }
            catch { }
            t = null;
            this.Close();
        }


        #region 打印
        string PrintText = "";
        public void softprint(string text)
        {
            PrintText = text;
            try
            {
                PrintDocument printDoc = new PrintDocument();
                printDoc.DocumentName = "小票";
                printDoc.PrintPage += new PrintPageEventHandler(printDoc_PrintPage);
                Margins margin = new Margins(0, 0, 0, 0);
                printDoc.DefaultPageSettings.Margins = margin;
                //PaperSize pSize = new PaperSize("Custom", 58, 58);
                //printDoc.DefaultPageSettings.PaperSize = pSize;
                printDoc.DefaultPageSettings.Landscape = false;

                PrintController printController1 = new StandardPrintController();
                printDoc.PrintController = printController1;
                printDoc.Print();

                //PrintPreviewDialog printPreviewDialog1 = new PrintPreviewDialog();
                //printPreviewDialog1.Document = printDoc;
                //DialogResult result = printPreviewDialog1.ShowDialog();
            }
            catch { }
        }

        void printDoc_PrintPage(object sender, PrintPageEventArgs e)
        {
            PrintDocument printDoc = (PrintDocument)sender;

            string[] arrPrintText = PrintText.Split('\n');

            int top = 10;
            for (int i = 0; i < arrPrintText.Length; i++)
            {
                if (i == 0)
                {
                    e.Graphics.DrawString(arrPrintText[i].ToString(), new Font(new FontFamily("宋体"), 14), System.Drawing.Brushes.Black, 10, top);
                    top += 25;
                }
                else {
                    e.Graphics.DrawString(arrPrintText[i].ToString(), new Font(new FontFamily("宋体"), 9), System.Drawing.Brushes.Black, 10, top);
                    top += 15;
                }
            }
        }
        #endregion
    }

    public class HotKey
    {
        //如果函数执行成功，返回值不为0。 
        //如果函数执行失败，返回值为0。要得到扩展错误信息，调用GetLastError。 
        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool RegisterHotKey(
            IntPtr hWnd, //要定义热键的窗口的句柄 
            int id, //定义热键ID（不能与其它ID重复）
            KeyModifiers fsModifiers, //标识热键是否在按Alt、Ctrl、Shift、Windows等键时才会生效 
            Keys vk//定义热键的内容 
        );
        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool UnregisterHotKey(
            IntPtr hWnd, //要取消热键的窗口的句柄 
            int id //要取消热键的ID 
            );
        //定义了辅助键的名称（将数字转变为字符以便于记忆，也可去除此枚举而直接使用数值） 
        [Flags()]
        public enum KeyModifiers
        {
            None = 0, Alt = 1, Ctrl = 2, Shift = 4, WindowsKey = 8
        }
    }
}