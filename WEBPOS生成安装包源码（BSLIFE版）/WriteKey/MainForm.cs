using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace WriteKey
{
    public partial class MainForm : Form
    {
        protected Thread t = null;
        private SoftKeyPWD ytsoftkey = new SoftKeyPWD();
        private string KeyPath;

        public delegate void MyInvoke();

        string os = "";
        string un = "";
        string pw = "";

        public MainForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text == "")
            {
                MessageBox.Show("请输入要写入的内容！", "提示！");
                return ;
            }

            string KeyId = textBox1.Text;
            string username = textBox2.Text;
            string pwd = textBox3.Text;
            if (KeyId.Length > 6)
            {
                MessageBox.Show("写入的内容长度不能大于6字符！", "提示！");
                return ;
            }
            int a = 0;
            try { a = Convert.ToInt32(KeyId); }
            catch { }
            if (a <= 0)
            {
                MessageBox.Show("请输入正整数！", "提示！");
                return ;
            }
            KeyId = KeyId.PadLeft(6, '0');
            username = username.PadRight(20, ' ');
            pwd = pwd.PadRight(20, ' ');
            if (username.Length > 20 || pwd.Length > 20)
            {
                MessageBox.Show("用户名密码长度不能大于20！", "提示！");
                return;
            }

            int ret;
            int nlen;
            nlen = SoftKeyPWD.lstrlenA(KeyId);

            ret = ytsoftkey.YWriteString(KeyId, 0, "ffffffff", "ffffffff", KeyPath);
            if (ret != 0)
            {
                MessageBox.Show("写入字符串错误。错误码：" + ret.ToString()); return;
            }
            else
            {
                if (username != "")
                    ytsoftkey.YWriteString(username, 6, "ffffffff", "ffffffff", KeyPath);
                if (pwd != "")
                    ytsoftkey.YWriteString(pwd, 26, "ffffffff", "ffffffff", KeyPath);
                MessageBox.Show("写入成功！");
            }
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            t = new Thread(new ThreadStart(GetKey));
            t.IsBackground = true;
            t.Start();
        }
        void GetKey()
        {
            bool f = false;
            while (true)
            {
                if (ytsoftkey.FindPort(0, ref KeyPath) == 0)
                {
                    if (os == "")
                    {
                        int r = ytsoftkey.YReadString(ref os, 0, 6, "ffffffff", "ffffffff", KeyPath);
                        if (r == 0)
                        {
                            ytsoftkey.YReadString(ref un, 6, 20, "ffffffff", "ffffffff", KeyPath);
                            ytsoftkey.YReadString(ref pw, 26, 20, "ffffffff", "ffffffff", KeyPath);
                            

                            MyInvoke _myInvoke = new MyInvoke(GetStr);
                            this.Invoke(_myInvoke);
                        }
                    }
                    f = false;
                }
                else
                {
                    if (!f)
                    {
                        MessageBox.Show("未找到加密锁,请插入加密锁后，再进行操作。");
                        f = true;
                    }
                }

                Thread.Sleep(1000);
            }
        }

        private void GetStr()
        {
            textBox1.Text = os.Trim('').Trim();
            textBox2.Text = un.Trim('').Trim();
            textBox3.Text = pw.Trim('').Trim();
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (t != null)
                t.Abort();
            t = null;
        }
    }
}