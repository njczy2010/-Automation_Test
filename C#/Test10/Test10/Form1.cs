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

        //���¼�������
        private void timer1_Tick(object sender, EventArgs e)
        {
            //ʵʱ��ʾʱ��
            DateTime dt = System.DateTime.Now;
            String now = dt.ToString();
            label1.Text = now;

            //listview�и����ô���
            //��Ĭ������£�listview�иߺܵͣ���̫�ÿ������� C# �У�listview �����ֲ��������иߣ�ֻ�ܽ�ס�����ؼ���������ã�һ�㶼���� ImageList�ؼ���

����        //�ȿ�����һ��ImageList�ؼ��������У�Ҳ�����ڳ����д���һ�� ImageList ����Ȼ������ ImageList �Ŀ�Ⱥ͸߶ȣ��ٰ� ImageList ���� listview ��Ӧ���ԣ�SmallImageList �� LargeImageList����
            ImageList imgList = new ImageList();
������������imgList.ImageSize = new Size(1, 25);
������������listView1.SmallImageList = imgList;

            listView1.GridLines = true;//����Ƿ���ʾ������
            listView1.FullRowSelect = true;//�Ƿ�ѡ������

            listView1.View = View.Details;//������ʾ��ʽ
            listView1.Scrollable = true;//�Ƿ��Զ���ʾ������
            listView1.MultiSelect = false;//�Ƿ����ѡ�����


            //��ΪҪʵʱ��ʾ�����������
            listView1.Clear();
            //��ӱ�ͷ���У�
            listView1.Columns.Add("Id", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("VirusId", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("VMId", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("����ʱ��", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("����", 100, HorizontalAlignment.Center);

            //��ӱ������

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

                //���ǰ����������
                for (int j = 1; j < 4; j++)
                {
                    sLine = objReader.ReadLine();
                    if (sLine != null)
                        item.SubItems.Add(sLine);
                }
                listView1.Items.Add(item);
                sLine = objReader.ReadLine();

                //�������ǽ��������� ProgressBar�ؼ�
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