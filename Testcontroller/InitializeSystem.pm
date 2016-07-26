package InitializeSystem;
use strict;
use warnings;

use Config::IniFiles;
use Log;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw();

use Variables qw(
                $gszInstallFoldername
                $gszConfigFoldername $gszLogFoldername
                $gszLogFilename
                $gszDataFoldername
                $gszOriginalSamplesFoldername $gszOriginalSamplesMonitorFoldername
                $gszNewVirusesMonitorFoldername
                $gszNewTestsMonitorFoldername
                $gszResultsMonitorFoldername
                $gszVmClientsFoldername
                $gszFileStorageFoldername
                $gszResultStorageFoldername
                $gszBehaviorStorageFoldername
                
                $gszVmsStatusFilename
                
                $giSubmitSamplesIntervalTime
                
                $giExtendTestIntervalTime
                @gszExtendTestPlatforms
                
                $giDispatchTestIntervalTime
                
                $giHandleTestsIntervalTime
                $giHandleTestsTimeoutPerTest
                $gszTemplateTestStepsFilename $gszTemplateToolsFilename $gszTemplateWhitelistFilename
                $gszVmsConfigFilename
                
                $gszHandleTestInstallFoldername
                $gszHandleTestProgramname
                $gszVmrunOriginFilename
                
                @gszVmClientPlatforms
                
                $gszServer $gszUsername $gszPassword $gszDatabase
                $gsz7zipProgramname $gszMd5Programname $gszSha1Programname $gszGetFileTypeProgramname
                $gszDctCompilerProgramname $gszDctCompilerPacuFilename $gszDctCompilerDctFilename                
                @gszAutorunTypes
                @gszSurveyorFilenamesWL
                @gszMutantsWL
                @gszEventsWL
                @gszSemaphoresWL
                @gszLoadedModulesWL
                @gszSystemEnvVariables
                
                $giStatisticBehaviorIntervalTime
                
                $gszGeneralDctFoldername
                
                @gszRuleMatchOriginAutorunTypes @gszRuleMatchActualAutorunTypes
                
                $gszServiceIp
                $giDefaultTimeoutPerStep
                $gszCmd
                $gszSnapShotPath
                
                $gszFileserverFoldername
                $gszFileserverVmClientsFoldername
                
                $gszDataBaseIp
                );

sub ReadSubmitSamples
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Basic", "IntervalTime")) {
        $giSubmitSamplesIntervalTime = $cfg->val("Basic", "IntervalTime");
    }
    else {
        Log::WriteLog("Fail to read the value \"IntervalTime\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSubmitSamples;
    }
    
_END_ReadSubmitSamples:

    return $ret;
}

sub ReadExtendTest
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    @gszExtendTestPlatforms = ();
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Basic", "IntervalTime")) {
        $giExtendTestIntervalTime = $cfg->val("Basic", "IntervalTime");
    }
    else {
        Log::WriteLog("Fail to read the value \"IntervalTime\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadExtendTest;
    }
    
    my $iCount = 0;
    if ($cfg->val("Platform", "Count")) {
        $iCount = $cfg->val("Platform", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[Platform]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadExtendTest;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        if ($cfg->val("Platform", "Platform$i")) {
            $gszExtendTestPlatforms[@gszExtendTestPlatforms] = $cfg->val("Platform", "Platform$i");
        }
        else {
            Log::WriteLog("Fail to read the value \"Platfrom$i\" in the section \"[Platform]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadExtendTest;
        }
    }    
    
_END_ReadExtendTest:

    return $ret;
}

sub ReadDispatchTest
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Basic", "IntervalTime")) {
        $giDispatchTestIntervalTime = $cfg->val("Basic", "IntervalTime");
    }
    else {
        Log::WriteLog("Fail to read the value \"IntervalTime\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadDispatchTest;
    }
    
_END_ReadDispatchTest:

    return $ret;
}

sub ReadHandleTests
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Basic", "IntervalTime")) {
        $giHandleTestsIntervalTime = $cfg->val("Basic", "IntervalTime");
    }
    else {
        Log::WriteLog("Fail to read the value \"IntervalTime\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
    if ($cfg->val("Basic", "TimeoutPerTest")) {
        $giHandleTestsTimeoutPerTest = $cfg->val("Basic", "TimeoutPerTest");
    }
    else {
        Log::WriteLog("Fail to read the value \"TimeoutPerTest\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
    if ($cfg->val("Basic", "ServiceIp")) {
        $gszServiceIp = $cfg->val("Basic", "ServiceIp");
    }
    else {
        Log::WriteLog("Fail to read the value \"ServiceIp\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
    if ($cfg->val("Basic", "DefaultTimeoutPerStep")) {
        $giDefaultTimeoutPerStep = $cfg->val("Basic", "DefaultTimeoutPerStep");
    }
    else {
        Log::WriteLog("Fail to read the value \"DefaultTimeoutPerStep\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
    if ($cfg->val("Basic", "Cmd")) {
        $gszCmd = $cfg->val("Basic", "Cmd");
    }
    else {
        Log::WriteLog("Fail to read the value \"Cmd\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
    if ($cfg->val("Basic", "FileserverFoldername")) {
        $gszFileserverFoldername = $cfg->val("Basic", "FileserverFoldername");
    }
    else {
        Log::WriteLog("Fail to read the value \"FileserverFoldername\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
    if ($cfg->val("HandleTest", "DataBaseIp")) {
        $gszDataBaseIp = $cfg->val("HandleTest", "DataBaseIp");
    }
    else {
        Log::WriteLog("Fail to read the value \"DataBaseIp\" in the section \"[HandleTest]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
    if ($cfg->val("HandleTest", "InstallFoldername")) {
        $gszHandleTestInstallFoldername = $cfg->val("HandleTest", "InstallFoldername");
    }
    else {
        Log::WriteLog("Fail to read the value \"InstallFoldername\" in the section \"[HandleTest]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHandleTests;
    }
    
_END_ReadHandleTests:

    return $ret;
}

sub ReadVms
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iVmClientCount = 0;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Basic", "VMClientCount")) {
        $iVmClientCount = $cfg->val("Basic", "VMClientCount");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMClientCount\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVms;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iVmClientCount; $i ++ ) {
        if ($cfg->val("VMClient$i", "Platform")) {
            $gszVmClientPlatforms[@gszVmClientPlatforms] = $cfg->val("VMClient$i", "Platform");
        }
        else {
            Log::WriteLog("Fail to read the value \"Platfrom\" in the section \"[VMClient$i]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadVms;
        }
    }    
    
_END_ReadVms:

    return $ret;
}


sub ReadMalwareDb
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Database", "Server")) {
        $gszServer = $cfg->val("Database", "Server");
    }
    else {
        $gszServer = undef;        
    }
    
    if ($cfg->val("Database", "Username")) {
        $gszUsername = $cfg->val("Database", "Username");
    }
    else {
        Log::WriteLog("Fail to read the value \"Username\" in the section \"[Database]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadMalwareDb;
    }
    
    if ($cfg->val("Database", "Password")) {
        $gszPassword = $cfg->val("Database", "Password");
    }
    else {
        Log::WriteLog("Fail to read the value \"Password\" in the section \"[Database]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadMalwareDb;
    }
    
    if ($cfg->val("Database", "Database")) {
        $gszDatabase = $cfg->val("Database", "Database");
    }
    else {
        Log::WriteLog("Fail to read the value \"Database\" in the section \"[Database]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadMalwareDb;
    }
    
_END_ReadMalwareDb:
    return $ret;
}

sub ReadTools
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    
    if ($cfg->val("7zip", "Programname")) {
        $gsz7zipProgramname = $cfg->val("7zip", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[7zip]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }
    
    if ($cfg->val("Md5", "Programname")) {
        $gszMd5Programname = $cfg->val("Md5", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[Md5]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }
    
    if ($cfg->val("Sha1", "Programname")) {
        $gszSha1Programname = $cfg->val("Sha1", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[Sha1]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }
    
    if ($cfg->val("GetFileType", "Programname")) {
        $gszGetFileTypeProgramname = $cfg->val("GetFileType", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[GetFileType]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }
    
    if ($cfg->val("VMProgram", "VMRun")) {
        $gszVmrunOriginFilename = $cfg->val("VMProgram", "VMRun");
    }
    else {
        Log::WriteLog("Fail to read the valur \"VMRun\" in the section \"[VMProgram]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }    
    
    if ($cfg->val("DctCompiler", "Programname")) {
        $gszDctCompilerProgramname = $cfg->val("DctCompiler", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the value \"Programname\" in the section \"[DctCompiler]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }
    
    if ($cfg->val("DctCompiler", "PacuFilename")) {
        $gszDctCompilerPacuFilename = $cfg->val("DctCompiler", "PacuFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"PacuFilename\" in the section \"[DctCompiler]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }
    
    if ($cfg->val("DctCompiler", "DctFilename")) {
        $gszDctCompilerDctFilename = $cfg->val("DctCompiler", "DctFilename");
    }
    else {
        Log::WriteLog("Fail to read the value \"DctFilename\" in the section \"[DctCompiler]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadTools;
    }
    
_END_ReadTools:
    return $ret;
    
}

sub ReadAutorunTypes
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("AutorunsType", "Count")) {
        $iCount = $cfg->val("AutorunsType", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[AutorunsType]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadAutorunTypes;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        if ($cfg->val("AutorunsType", "$i")) {
            $gszAutorunTypes[$i - 1] = lc($cfg->val("AutorunsType", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[AutorunsType]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadAutorunTypes;
        }
    }
    
_END_ReadAutorunTypes:
    return $ret;
}

sub ReadSurveyorFilenamesWL
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("SurveyorFilenamesWL", "Count")) {
        $iCount = $cfg->val("SurveyorFilenamesWL", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[SurveyorFilenamesWL]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSurveyorFilenamesWL;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp;
        if ($cfg->val("SurveyorFilenamesWL", "$i")) {
            $szTemp = lc($cfg->val("SurveyorFilenamesWL", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[SurveyorFilenamesWL]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadSurveyorFilenamesWL;
        }
        
        $_ = $szTemp;
        if ( /(equal|match)$/ ) {
            $gszSurveyorFilenamesWL[$i - 1] = $szTemp;
        }
        else {
            Log::WriteLog("The format of \"$szTemp\" is wrong.\n");
            $ret = 0;
            goto _END_ReadSurveyorFilenamesWL;
        }
    }
    
_END_ReadSurveyorFilenamesWL:
    return $ret;
}

sub ReadMutantsWL
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("MutantsWL", "Count")) {
        $iCount = $cfg->val("MutantsWL", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[MutantsWL]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadMutantsWL;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp;
        if ($cfg->val("MutantsWL", "$i")) {
            $szTemp = lc($cfg->val("MutantsWL", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[MutantsWL]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadMutantsWL;
        }
        
        $_ = $szTemp;
        if ( /(equal|match)$/ ) {
            $gszMutantsWL[$i - 1] = $szTemp;
        }
        else {
            Log::WriteLog("The format of \"$szTemp\" is wrong.\n");
            $ret = 0;
            goto _END_ReadMutantsWL;
        }
    }
    
_END_ReadMutantsWL:
    return $ret;
}

sub ReadEventsWL
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("EventsWL", "Count")) {
        $iCount = $cfg->val("EventsWL", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[EventsWL]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadEventsWL;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp;
        if ($cfg->val("EventsWL", "$i")) {
            $szTemp = lc($cfg->val("EventsWL", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[EventsWL]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadEventsWL;
        }
        
        $_ = $szTemp;
        if ( /(equal|match)$/ ) {
            $gszEventsWL[$i - 1] = $szTemp;
        }
        else {
            Log::WriteLog("The format of \"$szTemp\" is wrong.\n");
            $ret = 0;
            goto _END_ReadEventsWL;
        }
    }
    
_END_ReadEventsWL:
    return $ret;
}

sub ReadSemaphoresWL
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("SemaphoresWL", "Count")) {
        $iCount = $cfg->val("SemaphoresWL", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[SemaphoresWL]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSemaphoresWL;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp;
        if ($cfg->val("SemaphoresWL", "$i")) {
            $szTemp = lc($cfg->val("SemaphoresWL", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[SemaphoresWL]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadSemaphoresWL;
        }
        
        $_ = $szTemp;
        if ( /(equal|match)$/ ) {
            $gszSemaphoresWL[$i - 1] = $szTemp;
        }
        else {
            Log::WriteLog("The format of \"$szTemp\" is wrong.\n");
            $ret = 0;
            goto _END_ReadSemaphoresWL;
        }
    }
    
_END_ReadSemaphoresWL:
    return $ret;
}

sub ReadLoadedModulesWL
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("LoadedModulesWL", "Count")) {
        $iCount = $cfg->val("LoadedModulesWL", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[LoadedModulesWL]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadLoadedModulesWL;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp;
        if ($cfg->val("LoadedModulesWL", "$i")) {
            $szTemp = lc($cfg->val("LoadedModulesWL", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[LoadedModulesWL]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadLoadedModulesWL;
        }
        
        $_ = $szTemp;
        if ( /(equal|match)$/ ) {
            $gszLoadedModulesWL[$i - 1] = $szTemp;
        }
        else {
            Log::WriteLog("The format of \"$szTemp\" is wrong.\n");
            $ret = 0;
            goto _END_ReadLoadedModulesWL;
        }
    }
    
_END_ReadLoadedModulesWL:
    return $ret;
}

sub ReadSystemEnvVariables
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("SystemEnvVariable", "Count")) {
        $iCount = $cfg->val("SystemEnvVariable", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[SystemEnvVariable]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSystemEnvVariable;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp;
        if ($cfg->val("SystemEnvVariable", "$i")) {
            $szTemp = lc($cfg->val("SystemEnvVariable", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[SystemEnvVariable]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadSystemEnvVariable;
        }
        
        $gszSystemEnvVariables[$i - 1] = $szTemp;
        
    }
    
_END_ReadSystemEnvVariable:
    return $ret;
}

sub ReadStatisticBehavior
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("Basic", "IntervalTime")) {
        $giStatisticBehaviorIntervalTime = $cfg->val("Basic", "IntervalTime");
    }
    else {
        Log::WriteLog("Fail to read the value \"IntervalTime\" in the section \"[Basic]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadStatisticBehavior;
    }
    
_END_ReadStatisticBehavior:

    return $ret;
}

sub ReadRuleMatchAutorunTypes
{
    my ($szConfigFilename) = @_;
    
    my $ret = 1;
    
    my $iCount = 0;
    
    my $cfg = new Config::IniFiles( -file => $szConfigFilename );
    if ($cfg->val("AutorunTypes", "Count")) {
        $iCount = $cfg->val("AutorunTypes", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[AutorunTypes]\" in the config file \"$szConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadRuleMatchAutorunTypes;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp = "";
        if ($cfg->val("AutorunTypes", "$i")) {
            $szTemp = $cfg->val("AutorunTypes", "$i");
            my (@szTemps) = split(/\|/, $szTemp);
            if ( @szTemps != 2 ) {
                Log::WriteLog("The format of \"$szTemp\" is wrong.\n");
                $ret = 0;
                goto _END_ReadRuleMatchAutorunTypes;
            }
            else {
                $gszRuleMatchOriginAutorunTypes[$i - 1] = $szTemps[0];
                $gszRuleMatchActualAutorunTypes[$i - 1] = $szTemps[1];                
            }
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[AutorunTypes]\" in the config file \"$szConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadRuleMatchAutorunTypes;
        }        
    }
    
_END_ReadRuleMatchAutorunTypes:

    return $ret;
}


sub ReadAllConfig
{
    my $ret = 1;
    
    my $szSubmitSamplesConfigFilename = $gszConfigFoldername . "SubmitSamples.ini";
    my $szExtendTestConfigFilename = $gszConfigFoldername . "ExtendTest.ini";
    my $szDispatchTestConfigFilename = $gszConfigFoldername . "DispatchTest.ini";
    my $szHandleTestsConfigFilename = $gszConfigFoldername . "HandleTests.ini";
    my $szMalwareDbConfigFilename = $gszConfigFoldername . "MalwareDb.ini";
    my $szToolsConfigFilename = $gszConfigFoldername . "Tools.ini";
    my $szWhitelistConfigFilename = $gszConfigFoldername . "Whitelist.ini";
    my $szSystemEnvConfigFilename = $gszConfigFoldername . "SystemEnvVariable.ini";
    my $szStatisticBehaviorConfigFilename = $gszConfigFoldername . "StatisticBehavior.ini";
    my $szRuleMatchConfigFilename = $gszConfigFoldername . "RuleMatch.ini";
    
  #  $ret = ReadSubmitSamples($szSubmitSamplesConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadExtendTest($szExtendTestConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadDispatchTest($szDispatchTestConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
    $ret = ReadHandleTests($szHandleTestsConfigFilename);
    goto _END_ReadAllConfig if ($ret == 0);
    
    $ret = ReadVms($gszVmsConfigFilename);
    goto _END_ReadAllConfig if ($ret == 0);
        
  #  $ret = ReadMalwareDb($szMalwareDbConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadTools($szToolsConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadAutorunTypes($szWhitelistConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadSurveyorFilenamesWL($szWhitelistConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
        
  #  $ret = ReadMutantsWL($szWhitelistConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadEventsWL($szWhitelistConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadSemaphoresWL($szWhitelistConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadLoadedModulesWL($szWhitelistConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadSystemEnvVariables($szSystemEnvConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadStatisticBehavior($szStatisticBehaviorConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadRuleMatchAutorunTypes($szRuleMatchConfigFilename);
  #  goto _END_ReadAllConfig if ($ret == 0);
            
_END_ReadAllConfig:
    return $ret;
}

sub InitializeSystem
{
    my $ret = 1;
    
    my $iRet = 1;
    
    $gszConfigFoldername = $gszInstallFoldername . "Config\\";
    $gszLogFoldername = $gszInstallFoldername . "Log\\";
    
    $gszOriginalSamplesFoldername = $gszDataFoldername . "OriginalSamples\\";
    $gszOriginalSamplesMonitorFoldername = $gszDataFoldername . "OriginalSamplesMonitor\\";
    $gszNewVirusesMonitorFoldername = $gszDataFoldername . "NewVirusesMonitor\\";
    $gszNewTestsMonitorFoldername = $gszDataFoldername . "NewTestsMonitor\\";
    $gszResultsMonitorFoldername = $gszDataFoldername . "ResultsMonitor\\";
    $gszVmClientsFoldername = $gszDataFoldername . "VmClients\\";
    $gszFileStorageFoldername = $gszDataFoldername . "FileStorage\\";
    $gszResultStorageFoldername = $gszDataFoldername . "ResultStorage\\";
    $gszBehaviorStorageFoldername = $gszDataFoldername . "BehaviorStorage\\";
    
    $gszTemplateTestStepsFilename = $gszConfigFoldername . "TestSteps_Template.ini";
    $gszTemplateToolsFilename = $gszConfigFoldername . "Tools_Template.ini";
    $gszTemplateWhitelistFilename = $gszConfigFoldername . "Whitelist.ini";
    $gszVmsConfigFilename = $gszConfigFoldername . "VMs.ini";
    
    $gszVmsStatusFilename = $gszInstallFoldername . "Status\\HandleTestsStatus\\VmsStatus.txt";
    
    $gszGeneralDctFoldername = $gszInstallFoldername . "Dcts\\";
    
    $iRet = ReadAllConfig();
    if ( $iRet == 0 ) {
        $ret = 0;
        goto _END_InitializeSystem;
    }
    
    $gszHandleTestProgramname = $gszHandleTestInstallFoldername . "HandleTest.pl";
    $gszSnapShotPath = $gszFileserverFoldername . "screen\\";
    $gszFileserverVmClientsFoldername = $gszFileserverFoldername . "VmClients\\";
    
_END_InitializeSystem:
    return $ret;
    
}

1;
