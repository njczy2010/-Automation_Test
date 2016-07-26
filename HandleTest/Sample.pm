package Sample;
use strict;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw();

#use MyVMWare;
use Config::IniFiles;
#use Sys::SigAction qw ( set_sig_handler );

#use PrepareClient;
#use PrepareSample;
#use ExecuteSample;
#use Autorunsc;
#use Surveyor;
#use SysObjects;
#use LoadedModules;
#use Sic;
#use Catchme;
#use PrepareDct;
#use HcTest;
use BackendAPIs;

use Variables qw(
		$giDefaultTimeoutPerStep $giCurrentTimeout
                $gszTestStepsFilename
                $gszSampleInfoFilename $gszVirusMd5
                $gszClientHostType $gszClientHostAddress $gszClientHostUsername $gszClientHostPassword $gszClientVmPathname $gszClientVmSnapshot $gszClientVmUsername $gszClientVmPassword
                $gszResultFolderInHost
                $gszParentFoldername
                
                $gszVMId $gszServiceIp $gszCmd $gszSnapShotPath $gszFileserverVmClientsFoldername
                );

sub AutorunscSnapshot
{    
    my ($szStepname) = @_;
 
    my $ret = 0;
       
    my $szResultFilename = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val($szStepname, "ResultFilename")) {
        $szResultFilename = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_AutorunscSnapshot;
    }
    
    $szResultFilename = $gszResultFolderInHost . $szResultFilename;
    $ret = Autorunsc::GetAutoruns($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szResultFilename);
    
_END_AutorunscSnapshot:
    return $ret;    
}

sub SurveyorAnalyze
{
    my ($szStepname) = @_;
    
    my $ret = 0;
       
    my $szResultFilename = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val($szStepname, "ResultFilename")) {
        $szResultFilename = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_SurveyorAnalyze;
    }
    
    $szResultFilename = $gszResultFolderInHost . $szResultFilename;
    $ret = Surveyor::SurveyorAnalyze($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szResultFilename);
    
_END_SurveyorAnalyze:
    return $ret;
}

sub GetSysObjects
{    
    my ($szStepname) = @_;
 
    my $ret = 1;
       
    my $szResultFilename = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val($szStepname, "ResultFilename")) {
        $szResultFilename = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_GetSysObjects;
    }
    
    $szResultFilename = $gszResultFolderInHost . $szResultFilename;
    $ret = SysObjects::GetSysObjects($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szResultFilename);
    
_END_GetSysObjects:
    return $ret;    
}

sub GetLoadedModules
{    
    my ($szStepname) = @_;
 
    my $ret = 1;
       
    my $szResultFilename = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val($szStepname, "ResultFilename")) {
        $szResultFilename = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_GetLoadedModules;
    }
    
    $szResultFilename = $gszResultFolderInHost . $szResultFilename;
    $ret = LoadedModules::GetLoadedModules($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szResultFilename);
    
_END_GetLoadedModules:
    return $ret;
}

sub GetCatchme
{    
    my ($szStepname) = @_;
 
    my $ret = 1;
       
    my $szResultFilename = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val($szStepname, "ResultFilename")) {
        $szResultFilename = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_GetCatchme;
    }
    
    $szResultFilename = $gszResultFolderInHost . $szResultFilename;
    $ret = Catchme::GetCatchme($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szResultFilename);
    
_END_GetCatchme:
    return $ret;
}

sub CallSic
{
    my ($szStepname) = @_;
    
    my $ret = 1;
    
    my $szLogFilenameInHost = "";
    my $szSuspectFilenameInHost = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if (defined($cfg->val($szStepname, "LogFilename"))) {
        $szLogFilenameInHost = $cfg->val($szStepname, "LogFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"LogFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_CallSic;
    }
    $szLogFilenameInHost = $gszResultFolderInHost . $szLogFilenameInHost;
    
    if (defined($cfg->val($szStepname, "SuspectFilename"))) {
        $szSuspectFilenameInHost = $cfg->val($szStepname, "SuspectFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"SuspectFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_CallSic;
    }
    $szSuspectFilenameInHost = $gszResultFolderInHost . $szSuspectFilenameInHost;
    
    $ret = Sic::CallSic($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szLogFilenameInHost, $szSuspectFilenameInHost);
    
_END_CallSic:
    return $ret;
}

sub GetSuspiciousFiles
{
    my ($szStepname) = @_;
    
    my $ret = 1;
    
    my $szSourceFilenameInHost = "";
    my $szResultFilenameInHost = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if (defined($cfg->val($szStepname, "SourceFilename"))) {
        $szSourceFilenameInHost = $cfg->val($szStepname, "SourceFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"SourceFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_GetSuspiciousFiles;
    }
    $szSourceFilenameInHost = $gszResultFolderInHost . $szSourceFilenameInHost;
    
    if (defined($cfg->val($szStepname, "ResultFilename"))) {
        $szResultFilenameInHost = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_GetSuspiciousFiles;
    }
    $szResultFilenameInHost = $gszResultFolderInHost . $szResultFilenameInHost;
    
    $ret = Surveyor::SurveyorGetSuspiciousFiles($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szSourceFilenameInHost, $szResultFilenameInHost);
    
_END_GetSuspiciousFiles:
    return $ret;
}

sub CaptureScreenImage
{
    my ($szStepname) = @_;
    
    my $ret = 1;
    
    my $szResultFilename = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if (defined($cfg->val($szStepname, "ResultFilename"))) {
        $szResultFilename = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_CaptureScreen;
    }
    $szResultFilename = $gszResultFolderInHost . $szResultFilename;
    
   $ret = MyVMWare::MyVMCaptureScreenImage($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szResultFilename);
    
_END_CaptureScreenImage:
    return $ret;
}

sub HcTestClean
{    
    my ($szStepname) = @_;
 
    my $ret = 0;
       
    my $szResultFilename = "";
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val($szStepname, "ResultFilename")) {
        $szResultFilename = $cfg->val($szStepname, "ResultFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilename\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_HcTestClean;
    }
    
    $szResultFilename = $gszResultFolderInHost . $szResultFilename;
    $ret = HcTest::DoClean($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword, $szResultFilename);
    
_END_HcTestClean:
    return $ret;    
}



sub Sleep30
{
    sleep(30);
}

sub Sleep90
{
    sleep(90);
}

sub WaitforOutbreak
{
    my $ret = 1;
    
    my $iOutbreakTime = 0;
    
    my $cfg = new Config::IniFiles( -file => $gszSampleInfoFilename );
    if (defined($cfg->val("Execute", "OutbreakTime"))) {
        $iOutbreakTime = $cfg->val("Execute", "OutbreakTime");
    }
    else {
        Log::WriteLog("Fail to read the value \"OutbreakTime\" in the section \"[Execute]\" in the config file \"$gszSampleInfoFilename\".\n");
        $ret = 0;
        goto _END_WaitforOutbreak;
    }
    
    sleep($iOutbreakTime);
    
_END_WaitforOutbreak:
    return $ret;
}

sub PrepareSample
{
    #my ($gszServiceIp,$gszVm) = @_;
    
    my $ret = 1;
    
    Log::WriteLog("Begin to prepare sample.\n");
    
    my $szSourcefile =  $gszFileserverVmClientFoldername . "sample.txt";
    my $szDestfile = "C:\\test\\";
    $ret = BackendAPIs::CopyFileFromHostToGuest($gszServiceIp,$gszVMId,$szSourcefile,$szDestfile,$giCurrentTimeout);
    
    
    
_END_PrepareSample:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to prepare sample.\n");
    }
    else {
        Log::WriteLog("Fail to prepare sample.\n");
    }
    
    return $ret;
}

sub ReturnResult
{
   # my ($gszServiceIp,$gszVm) = @_;
    
    my $ret = 1;
    
    Log::WriteLog("Begin to return result.\n");
    
    my $szSourcefile = "C:\\test\\sample.txt";
    my $szDestfile = $gszFileserverVmClientFoldername;
    $ret = BackendAPIs::CopyFileFromGuestToHost($gszServiceIp,$gszVMId,$szSourcefile,$szDestfile,$giCurrentTimeout);
    
    
    
_END_ReturnResult:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to return result.\n");
    }
    else {
        Log::WriteLog("Fail to return result.\n");
    }
    
    return $ret;
}

sub TestSample
{
    Log::WriteLog("Begin to test sample.\n");
    my $ret = 1;
    
    my $iStepNum = 0;
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val("Basic", "StepNum")) {
        $iStepNum = $cfg->val("Basic", "StepNum");
    }
    else {
        Log::WriteLog("Fail to read the value \"StepNum\" in the section \"[TestSteps]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_TestSample;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iStepNum; $i ++ ) {
        my $szStepname = "Step" . $i;
        my $szStepTitle;
	if ($cfg->val($szStepname, "Title")) {
            $szStepTitle = $cfg->val($szStepname, "Title");
            Log::WriteLog("Step $i: $szStepTitle\n");
        }
        else {
            Log::WriteLog("Fail to read the value \"Title\" in the section \"[$szStepname]\" in the config file \"$gszTestStepsFilename\".\n");
            $ret = 0;
            last;
        }
	
	if ($cfg->val($szStepname, "Timeout")) {
            $giCurrentTimeout = $cfg->val($szStepname, "Timeout");
        }
        else {
	    $giCurrentTimeout = $giDefaultTimeoutPerStep;
        }
	
        my $iRet = 1;
        
        
        if ( $szStepTitle eq "ReturnResult" ) {
            #my $sourcefile = "C:\\log.txt";
            #$iRet = BackendAPIs::CopyFileFromGuestToHost($sourcefile);
            $iRet = ReturnResult();
#	    last if ( $iRet == 0 );
	}
	elsif ( $szStepTitle eq "PrepareSample" ) {
           # my $sourcefile = $gszParentFoldername . "sample.txt";
            #\\10.65.0.5\zfs_ivm_pool_instantvm\PRODUCT_AUTOMATION\DDES
	    #$iRet = BackendAPIs::CopyFileFromHostToGuest($sourcefile);
            $iRet = PrepareSample();
#	    last if ( $iRet == 0 );
	}
	elsif ( $szStepTitle eq "ExecuteInGuest" ) {
   #         my $szCmd = "C:\\windows\\system32\\" . "notepad.exe";
	    #$iRet = BackendAPIs::ExecuteInGuest($gszServiceIp,$gszVm,$szCmd,$giCurrentTimeout);
            $iRet = BackendAPIs::ExecuteInGuest($gszServiceIp,$gszVMId,$gszCmd,$giCurrentTimeout);
#           last if ( $iRet == 0 );
	}
#	elsif ( $szStepTitle eq "FreeGuest" ) {
#	    $iRet = BackendAPIs::FreeGuest($gszServiceIp,$gszVm,$giCurrentTimeout);
#	    last if ( $iRet == 0 );
#	}
#	elsif ( $szStepTitle eq "GuestState") {
#	    $iRet = BackendAPIs::GuestState($gszServiceIp,$giCurrentTimeout);
#	    last if ( $iRet == 0 );
#	}
#	elsif ( $szStepTitle eq "NewGuest") {
#            my $szProduct = "80298fa5-4c99-47c1-b757-0aa85a3fd7dd";
#            my $szTemplate = "fe424815-3ca3-4fe7-9713-3ffe244d87d6";
#            my $szSample = "AA424815-3ca3-4fe7-9713-3ffe244d87d6";
 #           $iRet = BackendAPIs::NewGuest($gszServiceIp,$szProduct,$szTemplate,$szSample,$giCurrentTimeout);
#	    last if ( $iRet == 0 );
#	}
        elsif ( $szStepTitle eq "RebootGuest") {
	    $iRet = BackendAPIs::RebootGuest($gszServiceIp,$gszVMId,$giCurrentTimeout);
#	    last if ( $iRet == 0 );
	}
        elsif ( $szStepTitle eq "ScreenSnapShot") {
            #my $szResultfile = "\\\\10.65.0.5\\zfs_ivm_pool_instantvm\\PRODUCT_AUTOMATION\\DDES\\samples\\screen\\";
	    #$iRet = BackendAPIs::ScreenSnapShot($gszServiceIp,$gszVm,$szResultfile,$giCurrentTimeout);
            $iRet = BackendAPIs::ScreenSnapShot($gszServiceIp,$gszVMId,$gszSnapShotPath,$giCurrentTimeout);
#	    last if ( $iRet == 0 );
	}
	elsif ( $szStepTitle eq "Sleep30" ) {
	    Sleep30();
	}
	elsif ( $szStepTitle eq "Sleep90" ) {
	    Sleep90();
	}
        else{
            Log::WriteLog("Step name is incorrect.\n");
            $ret = 0;
            goto _END_TestSample;
        }
	
        #if($iRet == 0){
        #    $ret = 0;
        #    goto _END_TestSample;
       # }
        
      #  if ( $szStepTitle eq "PrepareClient" ) {
       #     $iRet = PrepareClient::PrepareClient();
#	    last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "PrepareSample" ) {
	#    $iRet = PrepareSample::PrepareSample();
#	    last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "AutorunscSnapshot" ) {
	#    $iRet = AutorunscSnapshot($szStepname);
#           last if ( $iRet == 0 );
#	}
	#elsif ( $szStepTitle eq "ExecuteSample" ) {
	#    $iRet = ExecuteSample::ExecuteSample();
#	    last if ( $iRet == 0 );
#	}
	#elsif ( $szStepTitle eq "ResetClient") {
	#    $iRet = MyVMWare::MyVMResetSystem($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname);
#	    last if ( $iRet == 0 );
#	}
	#elsif ( $szStepTitle eq "StopClient") {
	#    $iRet = MyVMWare::MyVMStopSystem($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname);
#	    last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "Sleep30" ) {
	#    Sleep30();
	#}
	#elsif ( $szStepTitle eq "Sleep90" ) {
	#    Sleep90();
	#}
	#elsif ( $szStepTitle eq "SurveyorSnapshot" ) {
	#    $iRet = Surveyor::SurveyorSnapshot($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword);
#	    last if ( $iRet == 0 );
#	}#
	#elsif ( $szStepTitle eq "SurveyorAnalyze" ) {
	#    $iRet = SurveyorAnalyze($szStepname);
#           last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "WaitforOutbreak" ) {
	#    $iRet = WaitforOutbreak();
#	    last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "GetSysObjects" ) {
	#    $iRet = GetSysObjects($szStepname);
#           last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "GetLoadedModules" ) {
	#    $iRet = GetLoadedModules($szStepname);
#           last if ( $iRet == 0 );
	#}
#	elsif ( $szStepTitle eq "CallSic" ) {
	    #$iRet = CallSic($szStepname);
#           last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "GetCatchme" ) {
	#    $iRet = GetCatchme($szStepname);
#           last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "GetSuspiciousFiles" ) {
	#    $iRet = GetSuspiciousFiles($szStepname);
#           last if ( $iRet == 0 );
	#}
	#elsif ( $szStepTitle eq "CaptureScreenImage" ) {
	#    $iRet = CaptureScreenImage($szStepname);
#           last if ( $iRet == 0 );
	#}
        #elsif ( $szStepTitle eq "PrepareDct" ) {
       #     $iRet = PrepareDct::PrepareDct();
#            last if ( $iRet == 0 );
      #  }
      #  elsif ( $szStepTitle eq "HcTestClean" ) {
     #       $iRet = HcTestClean($szStepname);
#            last if ( $iRet == 0 );
    #    }
	
    }
        
_END_TestSample:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to test sample.\n");
    }
    else {
        Log::WriteLog("Fail to test sample.\n");
    }
    
    return $ret;
}


1;
