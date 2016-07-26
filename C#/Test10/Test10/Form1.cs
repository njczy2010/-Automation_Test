using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Collections;

namespace Test10
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            timer1.Interval = 1000;
            timer1.Start();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
           
            
        }

        //对事件的描述
        private void timer1_Tick(object sender, EventArgs e)
        {
            //实时显示时间
            DateTime dt = System.DateTime.Now;
            String now = dt.ToString();
            label1.Text = now;

            //listview行高设置代码
            //在默认情况下，listview行高很低，不太好看；而在 C# 中，listview 本身又不能设置行高，只能借住其它控件来间接设置，一般都是用 ImageList控件。

　　        //既可以拖一个ImageList控件到窗体中，也可以在程序中创建一个 ImageList 对象，然后设置 ImageList 的宽度和高度，再把 ImageList 赋给 listview 相应属性（SmallImageList 或 LargeImageList）。
            ImageList imgList = new ImageList();
　　　　　　imgList.ImageSize = new Size(1, 25);
　　　　　　listView1.SmallImageList = imgList;

            listView1.GridLines = true;//表格是否显示网格线
            listView1.FullRowSelect = true;//是否选中整行

            listView1.View = View.Details;//设置显示方式
            listView1.Scrollable = true;//是否自动显示滚动条
            listView1.MultiSelect = false;//是否可以选择多行


            //因为要实时显示，所以先清空
            listView1.Clear();
            //添加表头（列）
            listView1.Columns.Add("Id", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("VirusId", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("VMId", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("所用时间", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("进度", 100, HorizontalAlignment.Center);

            //添加表格内容

            StreamReader objReader = new StreamReader("D:\\display.ini");

            string sLine = "";
            int i = 0;
            // ListViewItem item = new ListViewItem();

            sLine = objReader.ReadLine();
            while (sLine != null)
            {
                i++;
                ListViewItem item = new ListViewItem();
                item.SubItems.Clear();
                if (sLine != null)
                    item.SubItems[0].Text = sLine;

                //表格前四列是文字
                for (int j = 1; j < 4; j++)
                {
                    sLine = objReader.ReadLine();
                    if (sLine != null)
                        item.SubItems.Add(sLine);
                }
                listView1.Items.Add(item);
                sLine = objReader.ReadLine();

                //第五列是进度条，即 ProgressBar控件
                if (sLine != null)
                {
                    ProgressBar progressbar = new ProgressBar();
                    progressbar.Name = "progressbar" + i;
                    progressbar.Location = new Point(400, 26*i);
                    //progressbar.Width = 25;
                    progressbar.Height = 20;
                    //this.Controls.Add(progressbar);
                    progressbar.Minimum = 0;
                    progressbar.Maximum = 10;                    

                    int result;
                    int.TryParse(sLine, out result);
                    progressbar.Step = result;
                   // progressbar.PerformStep();
                    //progressbar[i].PerformStep();
                    this.listView1.Controls.Add(progressbar);
                    progressbar.PerformStep();
                }

                //listView1.Items.Add(item);
                sLine = objReader.ReadLine();
            }
            objReader.Close();

            /*
            ProgressBar progressbar1 = new ProgressBar();
            progressbar1.Location = new Point(25, 25);
            this.Controls.Add(progressbar1);
            progressbar1.Minimum = 0;
            progressbar1.Maximum = 10;
            progressbar1.Step = 2;
            progressbar1.PerformStep();*/
            //for (int i = 0; i < 500; i++)
            //{
             //   progressbar1.PerformStep();
            //}
        }
    }
}