package HandleTest;
use strict;
use warnings;

use Log;
use AllConfig;
#use MyVMWare;
use Sample;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw();

use Variables qw(
                $giCurrentTimeout
                $gszParentFoldername
                $gszLogFilename
                $gszSampleInfoFilename $gszTestInfoFilename $gszWhiteListConfigFilename
                $gszVirusMd5 $giVirusId $gszTestOs $giVmClientId
                $gszVmConfigFilename $gszToolsConfigFilename $gszTestStepsFilename
                $gszSampleFolderInHost $gszResultFolderInHost $gszTempFolderInHost $gszPatternFolderInHost
                $gszClientHostType $gszClientHostAddress $gszClientHostUsername $gszClientHostPassword $gszClientVmPathname $gszClientVmSnapshot $gszClientVmUsername $gszClientVmPassword $gszClientVmIp
                $gszVMRunAppname $gszVMRun
                );

sub HandleTest
{
    ($gszParentFoldername) = @_;

    my $ret = 1;

    my $bClientFlag = 1;

    $gszLogFilename = $gszParentFoldername . "HandleTest.log";

    $gszVmConfigFilename = $gszParentFoldername . "VM.ini";
    $gszToolsConfigFilename = $gszParentFoldername . "Tools.ini";
    $gszWhiteListConfigFilename = $gszParentFoldername . "Whitelist.ini";
    $gszTestStepsFilename = $gszParentFoldername . "TestSteps.ini";

    $gszSampleFolderInHost = $gszParentFoldername . "Sample\\";
    $gszResultFolderInHost = $gszParentFoldername . "Result\\";
    $gszTempFolderInHost = $gszParentFoldername . "Temp\\";
    $gszPatternFolderInHost = $gszParentFoldername . "Pattern\\";

    $gszSampleInfoFilename = $gszSampleFolderInHost . "Sample.ini";
    $gszTestInfoFilename = $gszParentFoldername . "TestInfo.ini";

    unlink($gszLogFilename);
    if ( -e $gszLogFilename ) {
        print("Warning: File \"$gszLogFilename\" still exists.\n");
    }

   # my $cfg = new Config::IniFiles( -file => $gszSampleInfoFilename );
   # if ($cfg->val("Basic", "Virusname")) {
   #     $gszVirusMd5 = $cfg->val("Basic", "Virusname");
   # }
   # else {
   #     Log::WriteLog("Fail to read the value \"Virusname\" in the section \"[Basic]\" in the config file \"$gszSampleInfoFilename\".\n");
   #     $ret = 0;
   #     goto _END_HandleTest;
   # }
    
  #  $cfg = new Config::IniFiles( -file => $gszTestInfoFilename );
  #  if ($cfg->val("Basic", "VirusId")) {
  #      $giVirusId = $cfg->val("Basic", "VirusId");
  #  }
  #  else {
  #      Log::WriteLog("Fail to read the value \"VirusId\" in the section \"[Basic]\" in the config file \"$gszTestInfoFilename\".\n");
  #      $ret = 0;
  #      goto _END_HandleTest;
  #  }
    
 #   if ($cfg->val("Basic", "OS")) {
 #       $gszTestOs = $cfg->val("Basic", "OS");
  #  }
  #  else {
  #      Log::WriteLog("Fail to read the value \"OS\" in the section \"[Basic]\" in the config file \"$gszTestInfoFilename\".\n");
  #      $ret = 0;
  #      goto _END_HandleTest;
  #  }
  #  
  #  if ($cfg->val("Basic", "VmClientId")) {
  #      $giVmClientId = $cfg->val("Basic", "VmClientId");
  #  }
  #  else {
  #      Log::WriteLog("Fail to read the value \"VmClientId\" in the section \"[Basic]\" in the config file \"$gszTestInfoFilename\".\n");
  #      $ret = 0;
  #      goto _END_HandleTest;
  #  }
    
    
    Log::WriteLog("================Md5:$gszVirusMd5 VirusId:$giVirusId OS:$gszTestOs VmClientId:$giVmClientId==========================\n");

    $ret = AllConfig::ReadAllConfig();
   # goto _END_HandleTest if ( $ret == 0 );

   # if ( $bClientFlag == 1) {
   #     $giCurrentTimeout = 30;
   #     $ret = MyVMWare::MyVMRevertToSnapshot($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmSnapshot);
   #     goto _END_HandleTest if ( $ret == 0 );
   # }

  #  if ( $bClientFlag == 1 ) {
  #      $giCurrentTimeout = 120;
  #      $ret = MyVMWare::MyVMPowerOn($gszClientHostType, $gszClientHostAddress, $gszClientHostUsername, $gszClientHostPassword, $gszClientVmPathname, $gszClientVmUsername, $gszClientVmPassword);
  #      goto _END_HandleTest if ( $ret == 0 );
  #  }

   # if ( $bClientFlag == 1 ) {
   #     sleep(10);
   # }

    $ret = Sample::TestSample();
    goto _END_HandleTest if ( $ret == 0 );

_END_HandleTest:

    return $ret;

}

1;
