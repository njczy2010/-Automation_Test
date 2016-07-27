# Automation_Test

ps : 非最终版  

## 系统流程  
1. Web service receives users’ submission for new sample test, and saves the new test case to database.  
2. When one test client in backend is idle, test controller sends a request for a test case to web service, and web service retrieves a queued test case from database and returns it to test controller.  
3. When a test case finishes in backend, test controller sends the test result to web service, then web service update the status of the test case, and save the test result into database.  

步骤  
1) 服务器接到用户上传的新测试用例，保存到数据库中  
2) 当有虚拟机处于空闲状态时(循环查询)，test controller向服务器发送请求，准备好测试环境，并从数据库中取出需要测试的测试用例，放到虚拟机中执行  
3) 当测试用例执行结束(可能失败或成功)，test controller将数据库中测试用例的相应状态修改(finish,retest,daily-test (过24h再测) )  

## 程序功能：  
1. \HandleTest  
主程序，整体控制
2. \Testcontroller  
test case 在一台虚拟机上的具体执行  
3. \C#\Test10  
实时显示虚拟机执行测试用例的情况(Id, VirusId, VMId, 所用时间, 进度)

## 准备：  
安装ActivePerl-5.10.1.1007-MSWin32-x86-291969.msi  

## 对于1，2：  
### 修改：  
    HandleTests.pm(Testcontroller 的主程序)，修改准备环境(删除、创建文件夹，生成配置文件)的代码，将程序主体由数组循环变为了查找路径，相应的，由于没有了数组的概念，将 CheckTest里面涉及到的  \$gtStartTimes{'$szVmClientId'}; 变为了哈希结构。  
    
主要流程是HandleTestsOnce 先执行PrepareGuestState ，将返回的JSON写入 GuestState.ini。  

PrepareSampleInfo读取GuestState.ini，找出Idle的VmClient，依次进行DataBaseAPIs::GetNextCase，BackendAPIs::NewGuest，PrepareEnvironment，PrepareSample（将DataBaseAPIs::GetNextCase返回的JSON写入sample.ini），均成功则创建一个VmClient xxxxx的文件夹。  

Sample.pm(读取配置文件信息)  
HandleTest.pm(在一台虚拟机上跑case的过程)  
    
### 编写：  
BackendAPIs.pm (与服务器交互，http request调用,比如CopyFileFromHostToGuest, ExecuteInGuest,ScreenSnapShot，GuestState等),共8个函数,484行

其中GuestState 功能为获得并解析服务器传来的 Json, HandleTests.pm 调用该函数将结果写入GuestState.ini  

DataBaseAPIs.pm  (与数据库交互，GetNextCase,Finished,只是编写，没有测试)   共2个函数，131行  

CreateJSON.pl,perl 生成JSON，传给数据库,43行   

### Testcontroller执行过程
然后通过TestStep.ini执行 类似步骤：  
1) copy sample to Guest  
2) execute sample  
3) rebort  
4) execute tool auto.exe  
5) copy result to host  
6) screensnapshot  
7) 改状态为finish 或 TestReady  

用 txt的方式记录状态(Idle.txt, TestReady.txt ,InTesting.txt,Finish.txt)  

### 问题  
1）如何把虚拟机信息存下来：  
建文件夹，以id相关作为名称，把信息存入 VM.ini  

2）计算用时：  
hash  

## 对于3：
将display.ini放到D:\下，运行Test10.exe，实现从文件读入信息，显示 。  
目前还有待完善的地方：  
1.  改变界面大小的话，ListView的大小并不会发生变化。  
2.  display.ini中存入的只是结果，数据顺序不一样的话，显示的也不一样。  

### note
实时显示：  
界面里面拖个Timer控件就可以了，属性设置里面设置timer的Enable=true;Interval=1000  
timer1_Tick  

//第五列是进度条，即 ProgressBar控件  