package Variables;
use strict;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                    $giDefaultTimeoutPerStep $giCurrentTimeout $gbTimeoutFlag
                    $gszParentFoldername
                    $gszLogFilename
                    $gszVmConfigFilename $gszToolsConfigFilename $gszTestStepsFilename $gszWhiteListConfigFilename
                    $gszSampleInfoFilename $gszTestInfoFilename $gszVirusMd5 $giVirusId $gszTestOs $giVmClientId
                    $gszVMRunOrigin $gszVMRun $gszVMRunAppname
                    $gszClientHostType $gszClientHostAddress $gszClientHostUsername $gszClientHostPassword $gszClientVmPathname $gszClientVmSnapshot $gszClientVmUsername $gszClientVmPassword $gszClientVmIp
                    $gszSampleFolderInHost $gszResultFolderInHost $gszTempFolderInHost $gszPatternFolderInHost
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

#default time out
our $giDefaultTimeoutPerStep = 0;
our $giCurrentTimeout = 0;
our $gbTimeoutFlag = 0;

#root folder
our $gszParentFoldername = "";

#Log file name
our $gszLogFilename = "";

#Config file name
our $gszVmConfigFilename = "";
our $gszToolsConfigFilename = "";
our $gszWhiteListConfigFilename = "";
our $gszTestStepsFilename = "";

#Virus
our $gszSampleInfoFilename = "";
our $gszTestInfoFilename = "";
our $gszVirusMd5 = "";
our $giVirusId = 0;
our $gszTestOs = "";
our $giVmClientId = 0;

#VMProgram
our $gszVMRunOrigin = "";
our $gszVMRun = "";
our $gszVMRunAppname = "";

#VMClient
our $gszClientHostType = "";
our $gszClientHostAddress = "";
our $gszClientHostUsername = "";
our $gszClientHostPassword = "";
our $gszClientVmPathname = "";
our $gszClientVmSnapshot = "";
our $gszClientVmUsername = "";
our $gszClientVmPassword = "";
our $gszClientVmIp = "";

our $gszVMId = "";
our $gszServiceIp = "";
our $gszCmd= "";
our $gszSnapShotPath = "";
our $gszFileserverVmClientFoldername = "";

#FolderInHost
our $gszSampleFolderInHost = "";
our $gszResultFolderInHost = "";
our $gszTempFolderInHost = "";

#FolderInGuest
our $gszSampleFolderInGuest = "";

#Autoruns
our $gszAutorunsProgramname = "";
our $gszAutorunsResultFilenameInGuest = "";

#Surveyor
our $gszSurveyorProgramnameForSnapshot = "";
our $gszSurveyorProgramnameForAnalyze = "";
our $gszSurveyorResultFilenameInGuest = "";
our @gszSurveyorFilenamesWL = ();

#SysObjects
our $gszSysObjectsProgramname = "";
our $gszSysObjectsResultFilenameInGuest = "";

#Catchme
our $gszCatchmeProgramname = "";
our $gszCatchmeOriginProgramname = "";
our $gszCatchmeResultFilenameInGuest = "";

#LoadedModules
our $gszLoadedModulesProgramname = "";
our $gszEndLoadedModulesProgramname = "";
our $gszLoadedModulesResultFilenameInGuest = "";

#Sic
our $gszSicProgramname = "";
our $gszSicLogFilenameInGuest = "";
our $gszSicSuspectFilenameInGuest = "";

#GetSuspiciousFiles
our $gszGetSuspiciousFilesProgramname = "";
our $gszGetSuspiciousFilesResultFolderInGuest = "";
our $gszGetSuspiciousFilesListFilenameInGuest = "";
our $gszGetSuspiciousFilesResultFilenameInGuest = "";

#HouseCall
our $gszHcTestProgramname = "";
our $gszHcTestResultFilenameInGuest = "";
our $gszHcTestDctFilenameInGuest = "";

#7zip
our $gsz7zipProgramname = "";

1;
