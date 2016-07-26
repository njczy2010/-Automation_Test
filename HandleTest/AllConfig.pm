package AllConfig;
use strict;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw();

use Config::IniFiles;
use Log;

use Variables qw(
                $giDefaultTimeoutPerStep
                $gszVmConfigFilename $gszToolsConfigFilename $gszTestStepsFilename $gszWhiteListConfigFilename
                $gszVMRunOrigin
                $gszClientHostType $gszClientHostAddress $gszClientHostUsername $gszClientHostPassword $gszClientVmPathname $gszClientVmSnapshot $gszClientVmUsername $gszClientVmPassword $gszClientVmIp
                $gszSampleFolderInGuest
                $gszAutorunsProgramname $gszAutorunsResultFilenameInGuest
                $gszSurveyorProgramnameForSnapshot $gszSurveyorProgramnameForAnalyze $gszSurveyorResultFilenameInGuest @gszSurveyorFilenamesWL
                $gszSysObjectsProgramname $gszSysObjectsResultFilenameInGuest
                $gszCatchmeProgramname $gszCatchmeOriginProgramname $gszCatchmeResultFilenameInGuest
                $gszLoadedModulesProgramname $gszEndLoadedModulesProgramname $gszLoadedModulesResultFilenameInGuest
                $gszSicProgramname $gszSicLogFilenameInGuest $gszSicSuspectFilenameInGuest
                $gszGetSuspiciousFilesProgramname $gszGetSuspiciousFilesResultFolderInGuest $gszGetSuspiciousFilesListFilenameInGuest $gszGetSuspiciousFilesResultFilenameInGuest
                $gszHcTestProgramname $gszHcTestResultFilenameInGuest $gszHcTestDctFilenameInGuest
                $gsz7zipProgramname
               
                $gszVMId $gszServiceIp $gszCmd $gszSnapShotPath $gszFileserverVmClientFoldername
                );

sub ReadTestStep
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszTestStepsFilename );
    if ($cfg->val("Basic", "DefaultTimeout")) {
        $giDefaultTimeoutPerStep = $cfg->val("Basic", "DefaultTimeout");
    }
    else {
        Log::WriteLog("Fail to read the valur \"DefaultTimeout\" in the section \"[Basic]\" in the config file \"$gszTestStepsFilename\".\n");
        $ret = 0;
        goto _END_ReadTestStep;
    }
        
_END_ReadTestStep:
    return $ret;
}
                    
sub ReadVMProgram
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    if ($cfg->val("VMProgram", "VMRun")) {
        $gszVMRunOrigin = $cfg->val("VMProgram", "VMRun");
    }
    else {
        Log::WriteLog("Fail to read the valur \"VMRun\" in the section \"[VMProgram]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVMProgram;
    }
        
_END_ReadVMProgram:
    return $ret;
}

sub ReadVMClient
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszVmConfigFilename );
    
    if ($cfg->val("VMClient", "VMId")) {
        $gszVMId = $cfg->val("VMClient", "VMId");
    }
    else {
        Log::WriteLog("Fail to read the value \"VMId\" in the section \"[VMClient]\" in the config file \"$gszVmConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVMClient;
    }
    
    if ($cfg->val("VMClient", "ServiceIp")) {
        $gszServiceIp = $cfg->val("VMClient", "ServiceIp");
    }
    else {
        Log::WriteLog("Fail to read the value \"ServiceIp\" in the section \"[VMClient]\" in the config file \"$gszVmConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVMClient;
    }
    
    if ($cfg->val("VMClient", "Cmd")) {
        $gszCmd = $cfg->val("VMClient", "Cmd");
    }
    else {
        Log::WriteLog("Fail to read the value \"Cmd\" in the section \"[VMClient]\" in the config file \"$gszVmConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVMClient;
    }
    
    if ($cfg->val("VMClient", "DefaultTimeoutPerStep")) {
        $giDefaultTimeoutPerStep = $cfg->val("VMClient", "DefaultTimeoutPerStep");
    }
    else {
        Log::WriteLog("Fail to read the value \"DefaultTimeoutPerStep\" in the section \"[VMClient]\" in the config file \"$gszVmConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVMClient;
    }
    
    if ($cfg->val("VMClient", "SnapShotPath")) {
        $gszSnapShotPath = $cfg->val("VMClient", "SnapShotPath");
    }
    else {
        Log::WriteLog("Fail to read the value \"SnapShotPath\" in the section \"[VMClient]\" in the config file \"$gszVmConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVMClient;
    }
    
    if ($cfg->val("VMClient", "FileserverVmClientFoldername")) {
        $gszFileserverVmClientFoldername = $cfg->val("VMClient", "FileserverVmClientFoldername");
    }
    else {
        Log::WriteLog("Fail to read the value \"FileserverVmClientFoldername\" in the section \"[VMClient]\" in the config file \"$gszVmConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadVMClient;
    }
    
    
_END_ReadVMClient:
    return $ret;
}

sub ReadFolderInGuest
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    
    if ($cfg->val("FolderInGuest", "SampleFolderInGuest")) {
        $gszSampleFolderInGuest = $cfg->val("FolderInGuest", "SampleFolderInGuest");
    }
    else {
        Log::WriteLog("Fail to read the value \"SampleFolderInHost\" in the section \"[FolderInGuest]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadFolderInGuest;
    }
   
_END_ReadFolderInGuest:
    return $ret;
        
}

sub ReadAutoruns
{    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    if ($cfg->val("Autoruns", "Programname")) {
        $gszAutorunsProgramname = $cfg->val("Autoruns", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[Autoruns]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadAutoruns;
    }
    
    if ($cfg->val("Autoruns", "ResultFilenameInGuest")) {
        $gszAutorunsResultFilenameInGuest = $cfg->val("Autoruns", "ResultFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ResultFilenameInGuest\" in the section \"[Autoruns]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadAutoruns;
    }
    
_END_ReadAutoruns:
    return $ret;
    
}

sub ReadSurveyor
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    
    if ($cfg->val("Surveyor", "ProgramnameForSnapshot")) {
        $gszSurveyorProgramnameForSnapshot = $cfg->val("Surveyor", "ProgramnameForSnapshot");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ProgramnameForSnapshot\" in the section \"[Surveyor]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSurveyor;
    }
    
    if ($cfg->val("Surveyor", "ProgramnameForAnalyze")) {
        $gszSurveyorProgramnameForAnalyze = $cfg->val("Surveyor", "ProgramnameForAnalyze");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ProgramnameForAnalyze\" in the section \"[Surveyor]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSurveyor;
    }
        
    if ($cfg->val("Surveyor", "ResultFilenameInGuest")) {
        $gszSurveyorResultFilenameInGuest = $cfg->val("Surveyor", "ResultFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ResultFilenameInGuest\" in the section \"[Surveyor]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSurveyor;
    }
    
    my $iCount = 0;
    
    $cfg = new Config::IniFiles( -file => $gszWhiteListConfigFilename );
    if ($cfg->val("SurveyorFilenamesWL", "Count")) {
        $iCount = $cfg->val("SurveyorFilenamesWL", "Count");
    }
    else {
        Log::WriteLog("Fail to read the value \"Count\" in the section \"[SurveyorFilenamesWL]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSurveyor;
    }
    
    my $i = 0;
    for ( $i = 1; $i <= $iCount; $i ++ ) {
        my $szTemp;
        if ($cfg->val("SurveyorFilenamesWL", "$i")) {
            $szTemp = lc($cfg->val("SurveyorFilenamesWL", "$i"));
        }
        else {
            Log::WriteLog("Fail to read the value \"$i\" in the section \"[SurveyorFilenamesWL]\" in the config file \"$gszToolsConfigFilename\".\n");
            $ret = 0;
            goto _END_ReadSurveyor;
        }
        
        $_ = $szTemp;
        if ( /(equal|match)$/ ) {
            $gszSurveyorFilenamesWL[$i - 1] = $szTemp;
        }
        else {
            Log::WriteLog("The format of \"$szTemp\" is wrong.\n");
            $ret = 0;
            goto _END_ReadSurveyor;
        }
    }
    
_END_ReadSurveyor:
    return $ret;
    
}

sub ReadSysObjects
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    if ($cfg->val("SysObjects", "Programname")) {
        $gszSysObjectsProgramname = $cfg->val("SysObjects", "Programname");        
    }
    else {
        Log::WriteLog("Fail to read the value \"Programname\" in the section \"[SysObjects]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSysObjects;
    }
    
    if ($cfg->val("SysObjects", "ResultFilenameInGuest")) {
        $gszSysObjectsResultFilenameInGuest = $cfg->val("SysObjects", "ResultFilenameInGuest");        
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilenameInGuest\" in the section \"[SysObjects]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSysObjects;
    }
    
_END_ReadSysObjects:
    return $ret;
}

sub ReadCatchme
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    if ($cfg->val("Catchme", "Programname")) {
        $gszCatchmeProgramname = $cfg->val("Catchme", "Programname");        
    }
    else {
        Log::WriteLog("Fail to read the value \"Programname\" in the section \"[Catchme]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadCatchme;
    }
    
    if ($cfg->val("Catchme", "OriginProgramname")) {
        $gszCatchmeOriginProgramname = $cfg->val("Catchme", "OriginProgramname");        
    }
    else {
        Log::WriteLog("Fail to read the value \"OriginProgramname\" in the section \"[Catchme]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadCatchme;
    }
        
    if ($cfg->val("Catchme", "ResultFilenameInGuest")) {
        $gszCatchmeResultFilenameInGuest = $cfg->val("Catchme", "ResultFilenameInGuest");        
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilenameInGuest\" in the section \"[Catchme]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadCatchme;
    }
    
_END_ReadCatchme:
    return $ret;
}

sub ReadLoadedModules
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    if ($cfg->val("LoadedModules", "Programname")) {
        $gszLoadedModulesProgramname = $cfg->val("LoadedModules", "Programname");        
    }
    else {
        Log::WriteLog("Fail to read the value \"Programname\" in the section \"[LoadedModules]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadLoadedModules;
    }
    
    if ($cfg->val("LoadedModules", "EndProgramname")) {
        $gszEndLoadedModulesProgramname = $cfg->val("LoadedModules", "EndProgramname");        
    }
    else {
        Log::WriteLog("Fail to read the value \"EndProgramname\" in the section \"[LoadedModules]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadLoadedModules;
    }
        
    if ($cfg->val("LoadedModules", "ResultFilenameInGuest")) {
        $gszLoadedModulesResultFilenameInGuest = $cfg->val("LoadedModules", "ResultFilenameInGuest");        
    }
    else {
        Log::WriteLog("Fail to read the value \"ResultFilenameInGuest\" in the section \"[LoadedModules]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadLoadedModules;
    }
    
_END_ReadLoadedModules:
    return $ret;
}

sub ReadSic
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    if ($cfg->val("Sic", "Programname")) {
        $gszSicProgramname = $cfg->val("Sic", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the value \"Programname\" in the section \"[Sic]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSic;
    }
    
    if ($cfg->val("Sic", "LogFilenameInGuest")) {
        $gszSicLogFilenameInGuest = $cfg->val("Sic", "LogFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the value \"LogFilenameInGuest\" in the section \"[Sic]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSic;
    }
    
    if ($cfg->val("Sic", "SuspectFilenameInGuest")) {
        $gszSicSuspectFilenameInGuest = $cfg->val("Sic", "SuspectFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the value \"SuspectFilenameInGuest\" in the section \"[Sic]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadSic;
    }
        
_END_ReadSic:
    return $ret;
}

sub ReadGetSuspiciousFiles
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    
    if ($cfg->val("GetSuspiciousFiles", "Programname")) {
        $gszGetSuspiciousFilesProgramname = $cfg->val("GetSuspiciousFiles", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[GetSuspiciousFiles]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadGetSuspiciousFiles;
    }
            
    if ($cfg->val("GetSuspiciousFiles", "ResultFolderInGuest")) {
        $gszGetSuspiciousFilesResultFolderInGuest = $cfg->val("GetSuspiciousFiles", "ResultFolderInGuest");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ResultFolderInGuest\" in the section \"[GetSuspiciousFiles]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadGetSuspiciousFiles;
    }
    
    if ($cfg->val("GetSuspiciousFiles", "ListFilenameInGuest")) {
        $gszGetSuspiciousFilesListFilenameInGuest = $cfg->val("GetSuspiciousFiles", "ListFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ListFilenameInGuest\" in the section \"[GetSuspiciousFiles]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadGetSuspiciousFiles;
    }
    
    if ($cfg->val("GetSuspiciousFiles", "ResultFilenameInGuest")) {
        $gszGetSuspiciousFilesResultFilenameInGuest = $cfg->val("GetSuspiciousFiles", "ResultFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ResultFilenameInGuest\" in the section \"[GetSuspiciousFiles]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadGetSuspiciousFiles;
    }
        
_END_ReadGetSuspiciousFiles:
    return $ret;
    
}

sub Read7zip
{
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    
    if ($cfg->val("7zip", "Programname")) {
        $gsz7zipProgramname = $cfg->val("7zip", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[7zip]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_Read7zip;
    }
    
_END_Read7zip:
    return $ret;
    
}

sub ReadHcTest
{    
    my $ret = 1;
    
    my $cfg = new Config::IniFiles( -file => $gszToolsConfigFilename );
    if ($cfg->val("HCTest", "Programname")) {
        $gszHcTestProgramname = $cfg->val("HCTest", "Programname");
    }
    else {
        Log::WriteLog("Fail to read the valur \"Programname\" in the section \"[HCTest]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHcTest;
    }
    
    if ($cfg->val("HCTest", "ResultFilenameInGuest")) {
        $gszHcTestResultFilenameInGuest = $cfg->val("HCTest", "ResultFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the valur \"ResultFilenameInGuest\" in the section \"[HCTest]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHcTest;
    }
    
    if ($cfg->val("HCTest", "DctFilenameInGuest")) {
        $gszHcTestDctFilenameInGuest = $cfg->val("HCTest", "DctFilenameInGuest");
    }
    else {
        Log::WriteLog("Fail to read the valur \"DctFilenameInGuest\" in the section \"[HCTest]\" in the config file \"$gszToolsConfigFilename\".\n");
        $ret = 0;
        goto _END_ReadHcTest;
    }
        
_END_ReadHcTest:
    return $ret;
    
}

sub ReadAllConfig
{
    my $ret = 0;
    
    $ret = ReadTestStep();
    goto _END_ReadAllConfig if ($ret == 0);
    
#    $ret = ReadVMProgram();
#    goto _END_ReadAllConfig if ($ret == 0);
    
    $ret = ReadVMClient();
    goto _END_ReadAllConfig if ($ret == 0);
    
#    $ret = ReadFolderInGuest();
 #   goto _END_ReadAllConfig if ($ret == 0);
    
#    $ret = ReadAutoruns();
#    goto _END_ReadAllConfig if ($ret == 0);
    
   # $ret = ReadSurveyor();
   # goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadSysObjects();
  #  goto _END_ReadAllConfig if ($ret == 0);
    
 #   $ret = ReadCatchme();
 #   goto _END_ReadAllConfig if ($ret == 0);
    
#    $ret = ReadLoadedModules();
#    goto _END_ReadAllConfig if ($ret == 0);
    
   # $ret = ReadSic();
   # goto _END_ReadAllConfig if ($ret == 0);
    
  #  $ret = ReadGetSuspiciousFiles();
  #  goto _END_ReadAllConfig if ($ret == 0);
    
 #   $ret = ReadHcTest();
 #   goto _END_ReadAllConfig if ($ret == 0);
    
#    $ret = Read7zip();
#    goto _END_ReadAllConfig if ($ret == 0);
    
_END_ReadAllConfig:
    return $ret;
}

1;
