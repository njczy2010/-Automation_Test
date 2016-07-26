package HandleTests;
use strict;
use warnings;

#function£ºControll the test process

use Log;
use FileOperation;
use VmClient;
use BackendAPIs;
#use MySqlServer;
#use MalwareDbForVirus;
#use MalwareDbForFile;
#use MalwareDbForRule;
#use Zip;
#use DctCompiler;

use LWP 5.64; # load LWP classes

#use Win32::Process::List;
use Win32::Process;
use Win32::Process qw ( STILL_ACTIVE );
use Encode;     
use JSON;
use Data::Dumper;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw();

use Variables qw(
                $gszInstallFoldername
                $gszLogFoldername $gszLogFilename
                $giHandleTestsIntervalTime
                $gszTemplateTestStepsFilename $gszTemplateToolsFilename $gszTemplateWhitelistFilename
                $gszHandleTestInstallFoldername $gszHandleTestProgramname
                $gszVmsConfigFilename
                $gszVmClientsFoldername
                $gszFileStorageFoldername
                
                $gszResultStorageFoldername
                $gszResultsMonitorFoldername
                $gszVmsStatusFilename
                @gszVmClientPlatforms
                $gszVmrunOriginFilename
                
                $giHandleTestsTimeoutPerTest
                
                $gszServer $gszUsername $gszPassword $gszDatabase
                
                $gsz7zipProgramname
		
		$gszDctCompilerDctFilename
		$gszGeneralDctFoldername
                
                $gszConfigFoldername
                $gszVmClientsFoldername
                
                $gszServiceIp
                $giDefaultTimeoutPerStep
                $gszCmd
                $gszSnapShotPath
                $gszFileserverFoldername
                $gszFileserverVmClientsFoldername
                $gszDataBaseIp
                );

my %gtStartTimes = ();
my %ghProcesses = ();

sub PrepareEnvironment
{
    my ($szVmClientId) = @_;
    
    Log::WriteLog("Begin to prepare environment for VmClient $szVmClientId.\n");
    
    my $ret = 1; 
    
    my $szVmClientFoldername = $gszVmClientsFoldername . "VmClient $szVmClientId\\";
    my $szFileserverVmClientFoldername = $gszFileserverVmClientsFoldername . "VmClient $szVmClientId\\";
    my $hDir;
    if( -e $szVmClientFoldername){
        if ( !opendir($hDir, $szVmClientFoldername) ) {
            Log::WriteLog("Fail to open folder \"$szVmClientFoldername\".\n");
            $ret = 0;
            goto _END_PrepareEnvironment;
        }
        my @szFilenames = readdir($hDir);
        closedir($hDir);
        
        #Check whether the folder is already exists
        #for (my $i = 0; $i < @szFilenames; $i ++ ) {
        #    next if ( $szFilenames[$i] eq "." );
        #    next if ( $szFilenames[$i] eq ".." );
        #
        #    my $szFilename = lc($szFilenames[$i]);
        #    if( $szFilename eq "testready.txt" ||  $szFilename eq "intesting.txt" || $szFilename eq "finish.txt" ||  $szFilename eq "fail.txt"  ){
        #        $ret = 0;
        #        Log::WriteLog("The folder is already existsVmClient $szVmClientId.\n");
        #        goto _END_PrepareEnvironment;
        #    }   
        #}
        
        if ( !FileOperation::DeleteFolder($szVmClientFoldername) ) {
            $ret = 0;
        }
    
    }
    
    if( -e $szFileserverVmClientFoldername){
        if ( !opendir($hDir, $szFileserverVmClientFoldername) ) {
            Log::WriteLog("Fail to open folder \"$szFileserverVmClientFoldername\".\n");
            $ret = 0;
            goto _END_PrepareEnvironment;
        }
        my @szFilenames = readdir($hDir);
        closedir($hDir);
    
        if ( !FileOperation::DeleteFolder($szFileserverVmClientFoldername) ) {
            $ret = 0;
        }
    }
    
    if ( !FileOperation::CreateFolder($szVmClientFoldername) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    my $szResultFoldername = $szVmClientFoldername . "Result\\";
    if ( !FileOperation::CreateFolder($szResultFoldername) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    my $szTempFoldername = $szVmClientFoldername . "Temp\\";
    if ( !FileOperation::CreateFolder($szTempFoldername) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    my $szSampleFoldername = $szVmClientFoldername . "Sample\\";
    if ( !FileOperation::CreateFolder($szSampleFoldername) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    $szSampleFoldername = $szVmClientFoldername . "Sample\\Sample\\";
    if ( !FileOperation::CreateFolder($szSampleFoldername) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    my $szPatternFoldername = $szVmClientFoldername . "Pattern\\";
    if ( !FileOperation::CreateFolder($szPatternFoldername) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
        
    my  $szDestFilename = $szVmClientFoldername . "TestSteps.ini";
    if ( !FileOperation::CopyFile($gszTemplateTestStepsFilename, $szDestFilename) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    $szDestFilename = $szVmClientFoldername . "Tools.ini";
    if ( !FileOperation::CopyFile($gszTemplateToolsFilename, $szDestFilename) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    $szDestFilename = $szVmClientFoldername . "TestInfo.ini";
    if ( !FileOperation::CopyFile($gszTemplateToolsFilename, $szDestFilename) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    $szDestFilename = $szVmClientFoldername . "Whitelist.ini";
    if ( !FileOperation::CopyFile($gszTemplateWhitelistFilename, $szDestFilename) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    my $szSampleFilename = $szVmClientFoldername . "sample.txt";
    if ( !FileOperation::CreateFileWithPathname($szSampleFilename) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    if ( !FileOperation::CreateFolder($szFileserverVmClientFoldername) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    $szDestFilename = $szFileserverVmClientFoldername . "sample.txt";
    if ( !FileOperation::CopyFile($szSampleFilename, $szDestFilename) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
    
    my $szStatusFilename = $szVmClientFoldername . "\\TestReady.txt";
    if ( !FileOperation::CreateFileWithPathname($szStatusFilename) ) {
        $ret = 0;
        goto _END_PrepareEnvironment;
    }
        
_END_PrepareEnvironment:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to prepare environment for VmClient $szVmClientId.\n");
    }
    else {
        Log::WriteLog("Fail to prepare environment for VmClient $szVmClientId.\n");
    }

    return $ret;
    
}

sub PrepareSample
{
    my ($szVmClientId,$szJSON) = @_;
    
    Log::WriteLog("Begin to prepare sample for VmClient $szVmClientId.\n");
    
    my $ret = 1;
    
    my $iVirusId = 0;
    
    my $szTestInfoFilename = $gszVmClientsFoldername . "VmClient $szVmClientId\\TestInfo.ini";
   # my $cfg = new Config::IniFiles( -file => $szTestInfoFilename );
   # if ($cfg->val("Basic", "VirusId")) {
   #     $iVirusId = $cfg->val("Basic", "VirusId");
   # }
   # else {
   #     Log::WriteLog("Fail to read the value \"VirusId\" in the section \"[Basic]\" in the config file \"$szTestInfoFilename\".\n");
   #     $ret = 0;
   #     goto _END_PrepareSample;
   # }
        
    my $iRet = 0;
    my $iFileCount = 0;
    
    my $szCaseId = "";
    
    #app
    my $szAppId = "";
    my $szAppName = "";
    my $szAppShortName = "";
    
    #os
    my $szOsId = "";
    my $szOsName = "";
    my $szOsShortName = "";
    
    #scan
    my $szScanId = "";
    my $szScanSampleId = "";
    my $szScanCreatedDate = "";
    
    #scan->files
    my @szFileSampleId = ();
    my @szFileId = ();
    my @szFilePath = ();
    my @szFileType = ();
    my @szFileCreatedDate = ();
    my @szFilename = ();
    my @iFileSize = ();
    my @szFileMd5 = ();
    my @szFileSha1 = ();
    my @szFileSha256 = ();
    
    my $szScanCases = "";
    my $szScanIsNewScan = "";
    
    #else
    my $szCreatedDate = "";
    my $szStatus = "";
    my $szStartDate = "";
    my $szEndDate = "";
    
    my $szError = "";
    
    
    
    #parse JSON
    $szCaseId = $szJSON->{'SuccessPayLoad'}->{'caseID'};
    
    #app
    $szAppId = $szJSON->{'SuccessPayLoad'}->{'app'}->{'appID'};
    $szAppName = $szJSON->{'SuccessPayLoad'}->{'app'}->{'appName'};
    $szAppShortName = $szJSON->{'SuccessPayLoad'}->{'app'}->{'shortName'};
    
    #os
    $szOsId = $szJSON->{'SuccessPayLoad'}->{'os'}->{'osID'};
    $szOsName = $szJSON->{'SuccessPayLoad'}->{'os'}->{'osName'};
    $szOsShortName = $szJSON->{'SuccessPayLoad'}->{'os'}->{'shortName'};
    
    #scan
    $szScanId = $szJSON->{'SuccessPayLoad'}->{'scan'}->{'scanID'};
    $szScanSampleId = $szJSON->{'SuccessPayLoad'}->{'scan'}->{'sampleID'};
    $szScanCreatedDate = $szJSON->{'SuccessPayLoad'}->{'scan'}->{'createdDate'};
    
    #scan->files
    for my $szFile( @{$szJSON->{'SuccessPayLoad'}->{'files'} } )
    {
        
        $iFileCount++;
        $szFileSampleId[ $iFileCount ] = $szFile->{'sampleID'};
        $szFileId[ $iFileCount ] = $szFile->{'fileID'};
        $szFilePath[ $iFileCount ] = $szFile->{'filePath'};
        $szFileType[ $iFileCount ] = $szFile->{'fileType'};
        $szFileCreatedDate[ $iFileCount ] = $szFile->{'createdDate'};
        $szFilename[ $iFileCount ] = $szFile->{'name'};
        $iFileSize[ $iFileCount ] = $szFile->{'size'};
        $szFileMd5[ $iFileCount ] = $szFile->{'md5'};
        $szFileSha1[ $iFileCount ] = $szFile->{'sha1'};
        $szFileSha256[ $iFileCount ] = $szFile->{'sha256'};
        
    }
    
    
    
    $szScanCases = $szJSON->{'SuccessPayLoad'}->{'scan'}->{'cases'};
    $szScanIsNewScan = $szJSON->{'SuccessPayLoad'}->{'scan'}->{'isNewScan'};
    
    #else
    $szCreatedDate = $szJSON->{'SuccessPayLoad'}->{'createdDate'};
    $szStatus = $szJSON->{'SuccessPayLoad'}->{'status'};
    $szStartDate = $szJSON->{'SuccessPayLoad'}->{'startDate'};
    $szEndDate = $szJSON->{'SuccessPayLoad'}->{'endDate'};
    
    $szError = $szJSON->{'Error'};
    
    #my @iFileIds = ();
    #($iRet, @iFileIds) = MalwareDbForVirus::GetRecordFromTableSample($hDb, $iVirusId);
    #if ( $iRet == 0 ) {
    #    $ret = 0;
    #    goto _END_PrepareSample;
    #}
    
   # my @szFileMd5s = ();
   # my $i = 0;
   # for ( $i = 0; $i < @iFileIds; $i ++ ) {
   #     my $iFileId = $iFileIds[$i];
   #     my $iSize = 0;
   #     my $szMd5 = "";
   #     my $szSha1 = "";
   #     my $szFileType = "";
   #     ($iRet, $iSize, $szMd5, $szSha1, $szFileType) = MalwareDbForFile::GetRecordFromTableFile($hDb, $iFileId);
   #     if ( $iRet == 0 ) {
   #         $ret = 0;
   #         goto _END_PrepareSample;
   #     }
   #     else {
   #         $szFileMd5s[@szFileMd5s] = $szMd5;
   #     }
   # }
    
  #  MySqlServer::Disconnect($hDb);
  #  $hDb = 0;
    
 #   for ( $i = 0; $i < @szFileMd5s; $i ++ ) {
 #       my $szMd5 = $szFileMd5s[$i];
 #       my $szSourceFilename = $gszFileStorageFoldername . $szMd5;
 #       my $szDestFilename = $gszVmClientsFoldername . "VmClient $szVmClientId\\Sample\\Sample\\" . $szMd5;
 #       if ( !FileOperation::CopyFile($szSourceFilename, $szDestFilename ) ) {
 #           $ret = 0;
 #           goto _END_PrepareSample;
 #       }
 #   }
    
    my $hFile;
    my $szSampleInfoFilename = $gszVmClientsFoldername . "VmClient $szVmClientId\\Sample\\Sample.ini";
    if ( !open($hFile, ">$szSampleInfoFilename") ) {
        Log::WriteLog("Fail to open file $szSampleInfoFilename.\n");
        $ret = 0;
        goto _END_PrepareSample;
    }
    
    print $hFile "\[Basic\]\n";
    print $hFile "FileCount=$iFileCount\n";
    print $hFile "CaseId=$szCaseId\n";

    print $hFile "\[app\]\n";
    print $hFile "AppId=$szAppId\n";
    print $hFile "AppName=$szAppName\n";
    print $hFile "AppShortName=$szAppShortName\n";
    print $hFile "\n";

    print $hFile "\[os\]\n";
    print $hFile "OsId=$szOsId\n";
    print $hFile "OsName=$szOsName\n";
    print $hFile "OsShortName=$szOsShortName\n";
    print $hFile "\n";
    
    print $hFile "\[scan\]\n";
    print $hFile "ScanId=$szScanId\n";
    print $hFile "ScanSampleId=$szScanSampleId\n";
    print $hFile "ScanCreatedDate=$szScanCreatedDate\n";
    print $hFile "ScanCases=$szScanCases\n";
    print $hFile "ScanIsNewScan=$szScanIsNewScan\n";
    print $hFile "\n";
       
    print $hFile "\[else\]\n";
    print $hFile "CreatedDate=$szCreatedDate\n";
    print $hFile "Status=$szStatus\n";
    print $hFile "StartDate=$szStartDate\n";
    print $hFile "EndDate=$szEndDate\n";
    print $hFile "Error=$szError\n";
    print $hFile "\n";
    
    #scan->files
    for(my $i = 1; $i <= $iFileCount ; $i++)
    {
        print $hFile "[Flie$i]\n";
        
        print $hFile "FileSampleId=$szFileSampleId[$i]\n";    
        print $hFile "szFileId=$szFileId[$i]\n";
        print $hFile "FilePath=$szFilePath[$i]\n"; 
        print $hFile "FileType=$szFileType[$i]\n";
        print $hFile "FileCreatedDate=$szFileCreatedDate[$i]\n";
        print $hFile "Filename=$szFilename[$i]\n";
        print $hFile "FileSize=$iFileSize[$i]\n";
        print $hFile "FileMd5=$szFileMd5[$i]\n";
        print $hFile "FileSha1=$szFileSha1[$i]\n";
        print $hFile "FileSha256=$szFileSha256[$i]\n";
        print $hFile "\n";
    }
    close($hFile);

    
    #print $hFile "\[Basic\]\n";
    #print $hFile "Virusname=$szFileMd5s[0]\n";
    #print $hFile "\n";
    #print $hFile "\[Sample\]\n";
    #print $hFile "FilenameInHost=$szFileMd5s[0]\n";
    #print $hFile "FilenameInGuest=$szFileMd5s[0].exe\n";
    #print $hFile "\n";
    #print $hFile "\[Execute\]\n";
    #print $hFile "Commandline=VIRUS\n";
    #print $hFile "OutbreakTime=90\n";
    #print $hFile "\n";
    #print $hFile "\[Client_AddedFile\]\n";
    #print $hFile "FileNumber=0\n";
    #print $hFile "Filename1=\|\|\n";
    #print $hFile "\n";
    #print $hFile "\[HttpServer\]\n";
    #print $hFile "FileNumber=0\n";
    #print $hFile "Filename1=\n";
    #print $hFile "\n";
    #print $hFile "\[IrcServer\]\n";
    #print $hFile "Port=0\n";
    #close($hFile);
    
_END_PrepareSample:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to prepare sample for VmClient $szVmClientId.\n");
    }
    else {
        Log::WriteLog("Fail to prepare sample for VmClient $szVmClientId.\n");
    }
    
    return $ret;
}

sub PrepareGuestState
{
    Log::WriteLog("Begin to prepare guest state.\n");
    #Log::WriteLog("Begin to prepare environment for VmClient$iVmClientId.\n");
    
    my $ret = 1;
    
    my $szGuestStateJson = BackendAPIs::GuestState($gszServiceIp,$giDefaultTimeoutPerStep);
    if ( !$szGuestStateJson) {
        $ret = 0;
        goto _END_PrepareGuestState;
    }
    
    my $iVmClientCount = 0;
    
    my $szServerTime = "";    
    my @szProduct = ();
    my @szTemplateId = ();
    my @szTemplateName = ();
    my @szId = ();
    my @szHostName = ();
    my @szSampleId = ();
    my @szTestLog = ();
    my @szTestTime = ();
    my @szIP = ();
    my @szState = ();
    my @szServer = ();
    my @szProductId = ();
    
    for my $szGuestState( @{$szGuestStateJson->{'GUSTSTATE'} } )
    {
        
        my $szTempProduct = $szGuestState->{'PRODUCT'};
        my $szTempServer = $szGuestState->{'SERVER'};
        my $szTempProductID = $szGuestState->{'PRODUCT_ID'};
        for my $szClient( @{$szGuestState->{'CLIENT'} })
        {
            $iVmClientCount++;
            $szProduct[ $iVmClientCount ] = $szTempProduct;
            
            $szTemplateId[ $iVmClientCount ] = $szClient->{'TEMPLATE'}->{'ID'};
            $szTemplateName[ $iVmClientCount ] = $szClient->{'TEMPLATE'}->{'NAME'};
    
            $szId[ $iVmClientCount ] = $szClient->{'ID'};
            $szHostName[ $iVmClientCount ] = $szClient->{'HOSTNAME'};
            $szSampleId[ $iVmClientCount ] = $szClient->{'SAMPLEID'};
            $szTestLog[ $iVmClientCount ] = $szClient->{'TESTLOG'};
            $szTestTime[ $iVmClientCount ] = $szClient->{'TESTTIME'};
            $szIP[ $iVmClientCount ] = $szClient->{'IP'};
            $szState[ $iVmClientCount ] = $szClient->{'STATE'};

            $szServer[ $iVmClientCount ] = $szTempServer;
            $szProductId[ $iVmClientCount ] = $szTempProductID;
        }
        
    }
    $szServerTime = $szGuestStateJson->{'SERVERTIME'};
       
    my $szFilename = $gszConfigFoldername . "\\GuestState.ini";
    my $hFile;
    if ( !open($hFile, ">$szFilename") ) {
        Log::WriteLog("Fail to open file \"$szFilename\".\n");
        $ret = 0;
        goto _END_PrepareGuestState;
    }
    
    print $hFile "[Basic]\n";
    print $hFile "VMClientCount=$iVmClientCount\n";
    print $hFile "ServerTime=$szServerTime\n";
    print $hFile "\n";
    
    for(my $i = 1; $i <= $iVmClientCount ; $i++)
    {
        print $hFile "[VMClient$i]\n";
    
        print $hFile "Product=$szProduct[$i]\n";
        
        print $hFile "TemplateId=$szTemplateId[$i]\n";
        print $hFile "TemplateName=$szTemplateName[$i]\n";
        
        print $hFile "Id=$szId[$i]\n";
        print $hFile "HostName=$szHostName[$i]\n";
        print $hFile "SampleId=$szSampleId[$i]\n";
        print $hFile "TestLog=$szTestLog[$i]\n";
        print $hFile "TestTime=$szTestTime[$i]\n";
        print $hFile "IP=$szIP[$i]\n";
        print $hFile "State=$szState[$i]\n";
        
        print $hFile "Server=$szServer[$i]\n";
        print $hFile "ProductId=$szProductId[$i]\n";
        print $hFile "\n";
    }
    
    close($hFile);   
    
_END_PrepareGuestState:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to prepare guest state.\n");
    }
    else {
        Log::WriteLog("Fail to prepare guest state.\n");
    }

    return $ret;
}

sub GetOsName()
{
    my $szTemplateId = @_;
    my $szOsName = "";
    if($szTemplateId == "FE424815-3CA3-4FE7-9713-3FFE244D87D6")
    {
        my $szOsName = "win7";
    }
    elsif($szTemplateId == "0604D371-2233-4037-BAB4-FB4BAB421BE7")
    {
        my $szOsName = "win8";
    }
    elsif($szTemplateId == "2604D371-2233-4037-BAB4-FB4BAB421BE9")
    {
        my $szOsName = "win8";
    }
    elsif($szTemplateId == "1604D371-2233-4037-BAB4-FB4BAB421BE8")
    {
        my $szOsName = "win7";
    }
    else
    {
        Log::WriteLog("Fail to get osname for TemplateId $szTemplateId.\n");
    }
    return $szOsName;
}

sub PrepareSampleInfo
{
    Log::WriteLog("Begin to prepare sample info.\n");
    #Log::WriteLog("Begin to prepare environment for VmClient$iVmClientId.\n");
    
    my $ret = 1;
    
    my $iVmClientCount = 0;
    
    #my $szServerTime = "";    
    my $szProduct = "";
    my $szTemplateId = "";
    my $szTemplateName = "";
    my $szId = "";
    my $szHostName = "";
    my $szSampleId = "";
    my $szTestLog = "";
    my $szTestTime = "";
    my $szIP = "";
    my $szState = "";
    my $szServer = "";
    my $szProductId = "";
    
    my $szVMId = "";
    
    my $szConfigFilename = $gszConfigFoldername . "GuestState.ini";
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Basic", "VMClientCount")) {
        $iVmClientCount = $cfg->val("Basic", "VMClientCount");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMClientCount\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVms;
    }
    
    #find idle VMClient
    for (my $i = 1; $i <= $iVmClientCount; $i ++ ) {
        if ($cfg->val("VMClient$i", "State")) {
            $szState = $cfg->val("VMClient$i", "State");
        }
        else {
            Log::WriteLog("Fail to read the value \"State\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_PrepareSampleInfo;
        }
        
        if($szState eq "Busy"){
            next;
        }
        
        if ($cfg->val("VMClient$i", "Product")) {
            $szProduct = $cfg->val("VMClient$i", "Product");
        }
        else {
            Log::WriteLog("Fail to read the value \"Product\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "TemplateId")) {
            $szTemplateId = $cfg->val("VMClient$i", "TemplateId");
        }
        else {
            Log::WriteLog("Fail to read the value \"TemplateId\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "TemplateName")) {
            $szTemplateName = $cfg->val("VMClient$i", "TemplateName");
        }
        else {
            Log::WriteLog("Fail to read the value \"TemplateName\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
      #      $ret = 0;
      #      goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "Id")) {
            $szId = $cfg->val("VMClient$i", "Id");
        }
        else {
            Log::WriteLog("Fail to read the value \"Id\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "HostName")) {
            $szHostName = $cfg->val("VMClient$i", "HostName");
        }
        else {
            Log::WriteLog("Fail to read the value \"HostName\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
     #       $ret = 0;
     #       goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "SampleId")) {
            $szSampleId = $cfg->val("VMClient$i", "SampleId");
        }
        else {
            Log::WriteLog("Fail to read the value \"SampleId\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
      #      $ret = 0;
       #     goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "szTestLog")) {
            $szTestLog = $cfg->val("VMClient$i", "szTestLog");
        }
        else {
            Log::WriteLog("Fail to read the value \"szTestLog\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
     #       $ret = 0;
     #       goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "TestTime")) {
            $szTestTime = $cfg->val("VMClient$i", "TestTime");
        }
        else {
            Log::WriteLog("Fail to read the value \"TestTime\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
       #     $ret = 0;
        #    goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "IP")) {
            $szIP = $cfg->val("VMClient$i", "IP");
        }
        else {
            Log::WriteLog("Fail to read the value \"IP\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "Server")) {
            $szServer = $cfg->val("VMClient$i", "Server");
        }
        else {
            Log::WriteLog("Fail to read the value \"Server\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
      #      $ret = 0;
      #      goto _END_PrepareSampleInfo;
        }
        
        if ($cfg->val("VMClient$i", "ProductId")) {
            $szProductId = $cfg->val("VMClient$i", "ProductId");
        }
        else {
            Log::WriteLog("Fail to read the value \"ProductID\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_PrepareSampleInfo;
        }
        
        ###??????
        #my $iTimeout = $giDefaultTimeoutPerStep;
        #my $szOsName = GetOsName($szTemplateId);
        #if(!$szOsName){
        #    next;
        #}
        #my $szGetNextCaseJson=DataBaseAPIs::GetNextCase($gszDataBaseIp,$szProductId,$??,$iTimeout);
        #if(!$szGetNextCaseJson){
        #    next;
        #}
        
       # my $szTempVMId = BackendAPIs::NewGuest($gszServiceIp,$szId,$szTemplateId,$szSampleId,$giDefaultTimeoutPerStep);
       # if(!$szTempVMId)
       # {
       #     next;
       # }
       # else{
       #     $szVMId = $szTempVMId;
       # }
        
        #prepare each idle case        
        if(!PrepareEnvironment($szId))
        {
        #    next;
        }
        
        #if(!PrepareSample($szId,$szGetNextCaseJson))
        #{
        ##    next;
        #}
        
        Log::WriteLog("Begin to prepare VmConfigFile for VmClient $szId.\n");
        
        my $szFileserverVmClientFoldername = $gszVmClientsFoldername . "VMClient $szId";
        my $szFilename = $szFileserverVmClientFoldername . "\\VM.ini";
        my $hFile;
        if ( !open($hFile, ">$szFilename") ) {
            Log::WriteLog("Fail to open file \"$szFilename\".\n");
            Log::WriteLog("Fail to prepare VmConfigFile for VmClient $szId.\n");
            next;
        }
        
        print $hFile "[VMClient]\n";
        print $hFile "Product=$szProduct\n";
        
        print $hFile "TemplateId=$szTemplateId\n";
        print $hFile "TemplateName=$szTemplateName\n";
        
        print $hFile "Id=$szId\n";
        print $hFile "HostName=$szHostName\n";
        print $hFile "SampleId=$szSampleId\n";
        print $hFile "TestLog=$szTestLog\n";
        print $hFile "TestTime=$szTestTime\n";
        print $hFile "IP=$szIP\n";
        print $hFile "State=$szState\n";
        
        print $hFile "Server=$szServer\n";
        print $hFile "ProductId=$szProductId\n";
        
        print $hFile "VMId=$szVMId\n";
        
        print $hFile "ServiceIp=$gszServiceIp\n";
        print $hFile "DefaultTimeoutPerStep=$giDefaultTimeoutPerStep\n";
        print $hFile "Cmd=$gszCmd\n";
        print $hFile "SnapShotPath=$gszSnapShotPath\n";
        print $hFile "FileserverVmClientFoldername=$szFileserverVmClientFoldername\n";
        print $hFile "\n";

        close($hFile);
        
        Log::WriteLog("Succeed to prepare VmConfigFile for VmClient $szId.\n");
    }    
        
_END_PrepareSampleInfo:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to prepare sample info.\n");
    }
    else {
        Log::WriteLog("Fail to prepare sample info.\n");
    }

    return $ret;
}


###useless####
sub PrepareVmConfigFile
{
    my ($iVmClientNo) = @_;
    
    Log::WriteLog("Begin to prepare VmConfigFile for VmClient$iVmClientNo.\n");
    
    my $ret = 1;
    
    my $szVmname = "VMClient$iVmClientNo";
    
    my $szPlatform = "";
    my $szHostType = "";
    my $szHostAddress = "";
    my $szHostUsername = "";
    my $szHostPassword = "";
    my $szVmPathname = "";
    my $szVmSnapshotname = "";
    my $szVmUsername = "";
    my $szVmPassword = "";
    my $szVmIp = "";
    my $szTestType = "";
    my $szServiceIp = "";
    my $szVMId = "";
    my $szCmd = "";
    my $szSnapShotPath = "";
    
    my $cfg = new Config::IniFiles( -file => $gszVmsConfigFilename );
    
    if ($cfg->val($szVmname, "Platform")) {
        $szPlatform = $cfg->val($szVmname, "Platform");
    }
    else {
        Log::WriteLog("Fail to read the value \"Platform\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "HostType")) {
        $szHostType = $cfg->val($szVmname, "HostType");
    }
    else {
        Log::WriteLog("Fail to read the value \"HostType\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "HostAddress")) {
        $szHostAddress = $cfg->val($szVmname, "HostAddress");
    }
    else {
        Log::WriteLog("Fail to read the value \"HostAddress\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "HostUsername")) {
        $szHostUsername = $cfg->val($szVmname, "HostUsername");
    }
    else {
        Log::WriteLog("Fail to read the value \"HostUsername\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "HostPassword")) {
        $szHostPassword = $cfg->val($szVmname, "HostPassword");
    }
    else {
        Log::WriteLog("Fail to read the value \"HostPassword\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "VMPathname")) {
        $szVmPathname = $cfg->val($szVmname, "VMPathname");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMPathname\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "VMSnapshotname")) {
        $szVmSnapshotname = $cfg->val($szVmname, "VMSnapshotname");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMSnapshotname\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "VMUsername")) {
        $szVmUsername = $cfg->val($szVmname, "VMUsername");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMUsername\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "VMPassword")) {
        $szVmPassword = $cfg->val($szVmname, "VMPassword");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMPassword\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "VMIp")) {
        $szVmIp = $cfg->val($szVmname, "VMIp");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMIp\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val($szVmname, "TestType")) {
        $szTestType = $cfg->val($szVmname, "TestType");
    }
    else {
        Log::WriteLog("Fail to read the value \"TestType\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val("$szVmname", "ServiceIp")) {
        $szServiceIp = $cfg->val("$szVmname", "ServiceIp");
    }
    else {
        Log::WriteLog("Fail to read the value \"ServiceIp\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val("$szVmname", "VMId")) {
        $szVMId = $cfg->val("$szVmname", "VMId");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMId\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val("$szVmname", "Cmd")) {
        $szCmd = $cfg->val("$szVmname", "Cmd");
    }
    else {
        Log::WriteLog("Fail to read the value \"Cmd\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    if ($cfg->val("$szVmname", "SnapShotPath")) {
        $szSnapShotPath = $cfg->val("$szVmname", "SnapShotPath");
    }
    else {
        Log::WriteLog("Fail to read the value \"SnapShotPath\" in the section \"[$szVmname]\" in the config file \"$gszVmsConfigFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    my $szFilename = $gszVmClientsFoldername . "VmClient$iVmClientNo\\VM.ini";
    my $hFile;
    if ( !open($hFile, ">$szFilename") ) {
        Log::WriteLog("Fail to open file \"$szFilename\".\n");
        $ret = 0;
        goto _END_PrepareVmConfigFile;
    }
    
    print $hFile "[VMClient]\n";
    print $hFile "Platform=$szPlatform\n";
    print $hFile "HostType=$szHostType\n";
    print $hFile "HostAddress=$szHostAddress\n";
    print $hFile "HostUsername=$szHostUsername\n";
    print $hFile "HostPassword=$szHostPassword\n";
    print $hFile "VMPathname=$szVmPathname\n";
    print $hFile "VMSnapshotname=$szVmSnapshotname\n";
    print $hFile "VMUsername=$szVmUsername\n";
    print $hFile "VMPassword=$szVmPassword\n";
    print $hFile "VMIp=$szVmIp\n";
    print $hFile "TestType=$szTestType\n";
    print $hFile "ServiceIp=$szServiceIp\n";
    print $hFile "VMId=$szVMId\n";
    print $hFile "Cmd=$szCmd\n";
    print $hFile "SnapShotPath=$szSnapShotPath\n";
    
    close($hFile);

_END_PrepareVmConfigFile:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to prepare VmConfigFile for VmClient$iVmClientNo.\n");
    }
    else {
        Log::WriteLog("Fail to prepare VmConfigFile for VmClient$iVmClientNo.\n");
    }
    
    return $ret;
    
}

sub BeginTest
{
    my ($szVmClientId) = @_;
    
    Log::WriteLog("Begin to begin test for VmClient $szVmClientId.\n");
    
    my $ret = 1;
       
    if ( !VmClient::ChangeStatus($szVmClientId, "TestReady", "InTesting") ) {
        $ret = 0;
        goto _END_BeginTest;
    }
    
    #call Handletest.pl
    
    my $hProcess;
    my $szVmClientFoldername = $gszVmClientsFoldername . "VmClient $szVmClientId\\";
    ##???##
    $gszHandleTestInstallFoldername = "C:\\HandleTest\\";
    my $szCmd = "perl\.exe $gszHandleTestProgramname $szVmClientFoldername";
    if ( Win32::Process::Create($hProcess, "c:\\perl\\bin\\perl.exe", $szCmd, 0, NORMAL_PRIORITY_CLASS|CREATE_NEW_CONSOLE, $gszHandleTestInstallFoldername) ) {
        $gtStartTimes{'$szVmClientId'} = time;
        $ghProcesses{'$szVmClientId'} = $hProcess;
        Log::WriteLog("Succeed to launch process \"$szCmd\".\n");
    }
    else {
        Log::WriteLog("Fail to launch process \"$szCmd\"\n.");        
        VmClient::ChangeStatus($szVmClientId, "InTesting", "TestReady");
        $ret = 0;
        goto _END_BeginTest;
    }
    
_END_BeginTest:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to begin test for VmClient $szVmClientId.\n");
    }
    else {
        Log::WriteLog("Fail to begin test for VmClient $szVmClientId.\n");
    }

    return $ret;
    
}

sub CheckTest
{
    my ($szVmClientId) = @_;
    
    Log::WriteLog("Begin to check test for VmClient $szVmClientId.\n");
    
    my $ret = 1;
    
    if ( (!defined $gtStartTimes{'$szVmClientId'}) ) {
        Log::WriteLog("Start time of Vmclient $szVmClientId does not exist.\n");
        $ret = 0;
        goto _END_CheckTest;
    }
    
    my $tCurrentTime = time;
    my $tTime = $tCurrentTime - $gtStartTimes{'$szVmClientId'};
    if ( $tTime < 0 ) {
        Log::WriteLog("Time exception:\tstart time is $gtStartTimes{'$szVmClientId'}, and current time is $tCurrentTime.\n");
    }
    if ( $tTime > $giHandleTestsTimeoutPerTest ) {
        Log::WriteLog("Timeout:\tstart time is $gtStartTimes{'$szVmClientId'}, and current time is $tCurrentTime.\n");
    }
    
    if ( ($tTime < 0) || ($tTime > $giHandleTestsTimeoutPerTest) ) {
        my $hProcess = $ghProcesses{'$szVmClientId'};
        my $i = 0;
        my $bFlag = 0;
        for ( $i = 0; $i < 3; $i ++ ) {
            my $iExitCode = 0;
            $hProcess->GetExitCode($iExitCode);
            if ( $iExitCode == STILL_ACTIVE ) {
                $hProcess->Kill(0);
                sleep(3);
            }
            else {
                $bFlag = 1;
                last;
            }
        }
        if ( $bFlag == 0 ) {
            Log::WriteLog("Fail to terminate process of VmClient $szVmClientId.\n");
            $ret = 0;
        }
        else {
            Log::WriteLog("Succeed to terminate process of VmClient $szVmClientId.\n");
            
            #???need to modify??
            if ( !VmClient::ChangeStatus($szVmClientId, "InTesting", "Finish") ) {
                $ret = 0;                
            }
        }
    }
    
_END_CheckTest:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to check test for VmClient $szVmClientId.\n");
    }
    else {
        Log::WriteLog("Fail to check test for VmClient $szVmClientId.\n");
    }
    
    return $ret;
}

sub FinishTest
{
    my ($szVmClientId) = @_;
    
    Log::WriteLog("Begin to finish test for VmClient $szVmClientId.\n");
    
    my $ret = 1;
    
    ###need to modify
    my $szCaseID = "2c9cb105-f27e-4b59-bb92-d3430de0b488";
    my $szDetected = "false";
    my $szResult = "true";
    my $iTimeout = $giDefaultTimeoutPerStep;
    
    if(!DataBaseAPIs::Finished($gszDataBaseIp,$szCaseID,$szDetected,$szResult,$iTimeout))
    {
        $ret = 0;
        goto _END_FinishTest;
    }
    
   # my $iVirusId = 0;
   # my $szVirusMd5 = "";
   # my $szTestGuid = "";
    
   # my $szTestInfoFilename = $gszVmClientsFoldername . "VmClient $szVmClientId\\TestInfo.ini";
   # my $cfg = new Config::IniFiles( -file => $szTestInfoFilename );
   # if ($cfg->val("Basic", "VirusId")) {
   #     $iVirusId = $cfg->val("Basic", "VirusId");
   # }
    #else {
    #    Log::WriteLog("Fail to read the value \"VirusId\" in the section \"[Basic]\" in the config file \"$szTestInfoFilename\".\n");
    #    $ret = 0;
    #    goto _END_FinishTest;
    #}
    
   # if ($cfg->val("Basic", "TestGuid")) {
   #     $szTestGuid = $cfg->val("Basic", "TestGuid");
   # }
   # else {
  #      Log::WriteLog("Fail to read the value \"TestGuid\" in the section \"[Basic]\" in the config file \"$szTestInfoFilename\".\n");
  #      $ret = 0;
  #      goto _END_FinishTest;
  #  }
    
 #   my $szSampleInfoFilename = $gszVmClientsFoldername . "VmClient $szVmClientId\\Sample\\Sample.ini";
 #   $cfg = new Config::IniFiles( -file => $szSampleInfoFilename );
 #   if ($cfg->val("Basic", "Virusname")) {
 #       $szVirusMd5 = $cfg->val("Basic", "Virusname");
 #   }
 #   else {
 #       Log::WriteLog("Fail to read the value \"Virusname\" in the section \"[Basic]\" in the config file \"$szSampleInfoFilename\".\n");
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }    
    
 #   my $szTempFoldername = $gszInstallFoldername . "Temps\\HandleTestsTemp\\ForCompressed\\";
 #   my $szDestFoldername = $szTempFoldername . "$iVirusId" . "_" . "$szVirusMd5" . "_" . $szTestGuid . "\\";
    
 #   if ( !FileOperation::DeleteFolder($szDestFoldername) ) {        
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }
    
 #   if ( !FileOperation::CreateFolder($szDestFoldername) ) {
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }
    
#    my $szSourceFilename = "";
#    my $szDestFilename = "";
    
 #   $szSourceFilename = $gszVmClientsFoldername . "VmClient $szVmClientId\\" . "TestInfo.ini";
 #   $szDestFilename = $szDestFoldername . "TestInfo.ini";
 #   if ( !FileOperation::CopyFile($szSourceFilename, $szDestFilename) ) {
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }
    
#    $szSourceFilename  = $gszVmClientsFoldername . "VmClient $szVmClientId\\" . "Sample\\Sample.ini";
#    $szDestFilename = $szDestFoldername . "Sample.ini";
#    if ( !FileOperation::CopyFile($szSourceFilename, $szDestFilename) ) {
#        $ret = 0;
#        goto _END_FinishTest;
#    }
    
 #   $szSourceFilename  = $gszVmClientsFoldername . "VmClient $szVmClientId\\" . "HandleTest.log";
 #   $szDestFilename = $szDestFoldername . "HandleTest.log";
 #   if ( !FileOperation::CopyFile($szSourceFilename, $szDestFilename) ) {
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }
    
#    my $hDir;
#    my $szResultFoldername = $gszVmClientsFoldername . "VmClient $szVmClientId\\" . "Result\\";
#    if ( !opendir($hDir, $szResultFoldername) ) {
#        Log::WriteLog("Fail to open folder $szResultFoldername.\n");
#        goto _END_FinishTest;
#    }
#    my @szFilenames = readdir($hDir);
#    closedir($hDir);
    
 #   my $i = 0;
 #   for ( $i = 0; $i < @szFilenames; $i ++ ) {
 #       next if ( $szFilenames[$i] eq "." );
 #       next if ( $szFilenames[$i] eq ".." );
 #       
 #       $szSourceFilename = $szResultFoldername . $szFilenames[$i];
 #       $szDestFilename = $szDestFoldername . $szFilenames[$i];
        
 #       if ( !FileOperation::CopyFile($szSourceFilename, $szDestFilename) ) {
 #           $ret = 0;
 #           goto _END_FinishTest;
 #       }
 #   }
        
#    my $szResultFilename = $gszResultStorageFoldername . $iVirusId . "_" . $szVirusMd5 . "_" . $szTestGuid . "\.zip";
    
 #   if ( !Zip::Compress($gsz7zipProgramname, $szDestFoldername, $szResultFilename) ) {
 #       FileOperation::DeleteFile($szResultFilename);
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }
    
 #   my $szResultMonitorFilename = $gszResultsMonitorFoldername . $iVirusId . "_" . $szVirusMd5 . "_" . $szTestGuid;
 #   if ( !FileOperation::CreateFile($szResultMonitorFilename) ) {
  #      FileOperation::DeleteFile($szResultFilename);
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }
#    else {
#    }
    
 #   delete $gtStartTimes{'$szVmClientId'};
 #   delete $ghProcesses{'$szVmClientId'};
    
 #   if ( !VmClient::ChangeStatus($szVmClientId, "Finish", "Idle") ) {
 #       $ret = 0;
 #       goto _END_FinishTest;
 #   }
    
_END_FinishTest:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to finish test for VmClient $szVmClientId.\n");
    }
    else {
        Log::WriteLog("Fail to finish test for VmClient $szVmClientId.\n");
    }

    return $ret;
}

#write log
sub WriteCurrentTestStatus
{
    #my ($sourcefile) = @_;
    my $sourcefile = "\\\\10.65.0.5\\zfs_ivm_pool_instantvm\\PRODUCT_AUTOMATION\\DDES\\result\\result.txt";
    my $browser = LWP::UserAgent->new;
    my $ret = 1;
    
    my $hFile;
    if ( !open($hFile, ">$sourcefile" ) ) {
        $ret = 0;
        Log::WriteLog("Fail to open file \"$sourcefile\".\n");
        goto _END_WriteCurrentTestStatus;
    }
    print $hFile "success\n";
    
_END_WriteCurrentTestStatus:

    if ( $hFile != 0 ) {
        close($hFile);
    }
    
    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to WriteCurrentTestStatus \"$sourcefile\".\n");
    }
    else {
        Log::WriteLog("Fail to WriteCurrentTestStatus \"$sourcefile\".\n");
    }
    
    return $ret;
    
    
    #my $ret = 1;
    
   # my $hFile;
  #  if ( !open($hFile, ">$gszVmsStatusFilename" ) ) {
   #     $ret = 0;
    ##    Log::WriteLog("Fail to open file \"$gszVmsStatusFilename\".\n");
   #     goto _END_WriteCurrentTestStatus;
   # }
    
  #  my $i = 0;
  #  for ( $i = 0; $i < @gtStartTimes; $i ++ ) {
  #      next if ( !defined($gtStartTimes[$i]) );
  #              
  #      print $hFile "VmClient$i\t\($gtStartTimes[$i]\)\t\($ghProcesses[$i]\)\n";
 #       Log::WriteLog("Write status:\tVmClient$i\t\($gtStartTimes[$i]\)\t\($ghProcesses[$i]\)\n");
 #   }
    
#_END_WriteCurrentTestStatus:

#    if ( $hFile != 0 ) {
#        close($hFile);
#    }
    
 #   if ( $ret == 1 ) {
 #       Log::WriteLog("Succeed to write file \"$gszVmsStatusFilename\".\n");
#    }
#    else {
#        Log::WriteLog("Fail to write file \"$gszVmsStatusFilename\".\n");
#    }
    
#    return $ret;
}

sub ReadCurrentTestStatus
{
    my $ret = 1;
    
    %gtStartTimes = ();
    %ghProcesses = ();
    
    my $hFile;
    if ( !open($hFile, "$gszVmsStatusFilename" ) ) {
        $ret = 0;
        Log::WriteLog("Fail to open file \"$gszVmsStatusFilename\".\n");
        goto _END_ReadCurrentTestStatus;
    }
    
    my $szLine = "";
    while ( $szLine = <$hFile> ) {
        chomp($szLine);
        
        Log::WriteLog("Read status:\t\"$szLine\".\n");
        
        $_ = $szLine;
        my ($iVmClientId, $tStartTime, $hProcess) = /^VmClient(\d+)\t\((.*)\)\t\((.*)\)$/;
        if ( !defined($iVmClientId) || !defined($tStartTime) || !defined($hProcess) ) {
            $ret = 0;
            Log::WriteLog("Exception format:\t\"$szLine\".\n");
            next;
        }
        
        $gtStartTimes{'$szVmClientId'} = $tStartTime;
        $ghProcesses{'$szVmClientId'} = $hProcess;
    }
        
_END_ReadCurrentTestStatus:

    if ( $hFile != 0 ) {
        close($hFile);
    }
    
    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to read file \"$gszVmsStatusFilename\".\n");
    }
    else {
        Log::WriteLog("Fail to read file \"$gszVmsStatusFilename\".\n");
    }
    
    return $ret;
}

my $iLogFileNo = 0;
my $iCurrentCount = 0;

sub HandleTestsOnce
{
    #put 360 cases in a log file
    if ( $iCurrentCount > 360 ) {
	$iLogFileNo ++;
	$gszLogFilename = $gszLogFoldername . "HandleTests_" . $iLogFileNo . ".log";
	$iCurrentCount = 0;
    }
    
    $iCurrentCount ++;
    
    #a flag indates whether success or fail
    my $ret = 1;
    
    Log::WriteLog("Begin to handle tests once.\n");
    
    #if ( !ReadCurrentTestStatus() ) {
    #    $ret = 0;
    #    goto _END_HandleTestsOnce;
    #}

    if ( !PrepareGuestState() ) {
        $ret = 0;
        goto _END_HandleTestsOnce;
    }
    
    if ( !PrepareSampleInfo() ) {
        $ret = 0;
        goto _END_HandleTestsOnce;
    }
    
    #run each case
    my $hDir;
    if( -e $gszVmClientsFoldername){
        if ( !opendir($hDir, $gszVmClientsFoldername) ) {
            Log::WriteLog("Fail to open folder \"$gszVmClientsFoldername\".\n");
            $ret = 0;
            goto _END_HandleTestsOnce;
        }
        my @szFilenames = readdir($hDir);
        closedir($hDir);
        
        for (my $i = 0; $i < @szFilenames; $i ++ ) {
            next if ( $szFilenames[$i] eq "." );
            next if ( $szFilenames[$i] eq ".." );
        
            my $szFilename = $szFilenames[$i];
            next if (index($szFilename,"VmClient")==-1);
            
            #$szFilename look like VmClient xxxxx
            my $szVmClientId = substr($szFilename,9);
            
            if ( VmClient::WhetherIsTestReady($szVmClientId) ) {
                if ( !BeginTest($szVmClientId) ) {
                    $ret = 0;
                }
                next;
            }
        
            if ( VmClient::WhetherIsInTesting($szVmClientId) ) {
                if ( !CheckTest($szVmClientId) ) {
                    $ret = 0;
                }
                next;
            }
        
            if ( VmClient::WhetherIsFinish($szVmClientId) ) {
                if ( !FinishTest($szVmClientId) ) {
                    $ret = 0;
                }
                next;
            }
        }
    }
    
    if ( !WriteCurrentTestStatus() ) {
        $ret = 0;
        goto _END_HandleTestsOnce;
    }

_END_HandleTestsOnce:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to finish to handle tests once.\n");
    }
    else {
        Log::WriteLog("Fail to finish to handle tests once.\n");
    }
    
    return $ret;
}

sub HandleTestsPeriodly
{
    my $count;
    for($count = 0 ; $count <=1 ; $count++){
    #for ( ; ; ) {
#        last if ( OperationProcess::CheckStopSystemFlag() );
        
        my $ret = 1;
       
        HandleTestsOnce();

        print "Wait for $giHandleTestsIntervalTime seconds for next handling tests.\n";
        sleep($giHandleTestsIntervalTime);
        
#        my $i = 0;
#        for ( $i = $giHandleTestsIntervalTime; $i > 0; $i -- ) {
#            print "Wait for $i seconds for next handling tests.\n";
#            sleep(1);
#        }
    }
    
_END_HandleTestsPeriodly:

}

1;