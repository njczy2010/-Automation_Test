package Variables;
use strict;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
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
                
                    $giSubmitSamplesIntervalTime
                    
                    $giExtendTestIntervalTime
                    @gszExtendTestPlatforms
                    
                    $giDispatchTestIntervalTime
                    
                    $giHandleTestsIntervalTime
                    $giHandleTestsTimeoutPerTest
                    $gszTemplateTestStepsFilename $gszTemplateToolsFilename $gszTemplateWhitelistFilename
                    $gszVmsConfigFilename
                    $gszVmsStatusFilename                    
                    
                    $gszHandleTestInstallFoldername
                    $gszHandleTestProgramname
                    $gszVmrunOriginFilename
                    
                    $giCollectInfoIntervalTime
                                        
                    @gszVmClientPlatforms

                    $gszSampleInfoFilename $gszTestInfoFilename
                    @gszSampleMd5s @gszSampleSha1s @gszSampleTypes @giSampleSizes
                    $giVirusId $gszTestOs $gszTestResultType $gszTestDatetime $gszBehaviorFilename
                    $gszAutorunscBeforeInfectionFilename $gszAutorunscAfterInfectionFilename $gszAutorunscAfterRebootFilename $gszAutorunscAfterCleanFilename
                    $gszLoadedModulesAfterInfectionFilename $gszLoadedModulesAfterRebootFilename $gszLoadedModulesAfterCleanFilename
                    $gszSurveyorAfterInfectionFilename $gszSurveyorAfterRebootFilename $gszSurveyorAfterCleanFilename
                    $gszSysObjectsBeforeInfectionFilename $gszSysObjectsAfterInfectionFilename $gszSysObjectsAfterRebootFilename $gszSysObjectsAfterCleanFilename
                    $gszCatchmeAfterRebootFilename $gszCatchmeAfterCleanFilename
                    $gszSuspiciousFileAfterRebootFilename $gszSuspciousFileAfterRebootFoldername
                    $gszPacuResultFoldername $gszPacuResultFilename
                    @gszAutorunTypes
                    @gszSurveyorFilenamesWL
                    @gszMutantsWL @gszEventsWL @gszSemaphoresWL
                    @gszLoadedModulesWL
                    @gszSystemEnvVariables
                    @gszAddedFilenamesAfterInfection @gszModifiedFilenamesAfterInfection @gszDeletedFilenamesAfterInfection
                    @gszAddedFilenamesAfterReboot @gszModifiedFilenamesAfterReboot @gszDeletedFilenamesAfterReboot
                    @gszAddedFilenamesAfterClean @gszModifiedFilenamesAfterClean @gszDeletedFilenamesAfterClean
                    @gszAddedProcessnamesAfterInfection @giAddedProcessIdsAfterInfection
                    @gszAddedAutorunEntriesAfterInfection @gszAddedAutorunImagenamesAfterInfection @gszAddedAutorunTypesAfterInfection
                    @gszAddedAutorunEntriesAfterReboot @gszAddedAutorunImagenamesAfterReboot @gszAddedAutorunTypesAfterReboot
                    @gszAddedAutorunEntriesAfterClean @gszAddedAutorunImagenamesAfterClean @gszAddedAutorunTypesAfterClean
                    $giHiddenProcessNumberAfterReboot $giHiddenServiceNumberAfterReboot $giHiddenFileNumberAfterReboot @gszHiddenFilenamesAfterReboot
                    $giHiddenProcessNumberAfterClean $giHiddenServiceNumberAfterClean $giHiddenFileNumberAfterClean @gszHiddenFilenamesAfterClean
                    @gszAddedMutantsAfterInfection @gszAddedEventsAfterInfection @gszAddedSemaphoresAfterInfection
                    @gszAddedMutantsAfterReboot @gszAddedEventsAfterReboot @gszAddedSemaphoresAfterReboot
                    @gszAddedMutantsAfterClean @gszAddedEventsAfterClean @gszAddedSemaphoresAfterClean
                    @gszAddedLoadedModulesAfterInfection @gszAddedLoadedModulesAfterReboot @gszAddedLoadedModulesAfterClean
                    %gszSuspiciousFileAfterReboot
                    @gszPacuMatchedRules
                                        
                    $gszVirusSourcingType
                    $gszSourceFilename $gszSourceFoldername $gszResultFoldername $gszResultFilename
                    $gszServer $gszUsername $gszPassword $gszDatabase
                    $gszTempFoldername
                    $gsz7zipProgramname $gszMd5Programname $gszSha1Programname $gszGetFileTypeProgramname
                    $gszDctCompilerProgramname $gszDctCompilerPacuFilename $gszDctCompilerDctFilename
                    $gszVirusInfoFilename
                    
                    $giStatisticBehaviorIntervalTime
                    
                    $gszGeneralDctFoldername
                    
                    @gszRuleMatchOriginAutorunTypes @gszRuleMatchActualAutorunTypes
                    
                    $gszServiceIp
                    $giDefaultTimeoutPerStep
                    $giReadyVmClientCount
                    $gszCmd
                    $gszSnapShotPath
                    
                    $gszFileserverFoldername
                    $gszFileserverVmClientsFoldername
                    $gszDataBaseIp
                    );

#Information of program
our $gszInstallFoldername = "C:\\Testcontroller\\";
our $gszConfigFoldername = "";
our $gszLogFoldername = "";
our $gszLogFilename = "";

#Folder name of data
our $gszDataFoldername = "C:\\Data\\";
our $gszOriginalSamplesFoldername = "";
our $gszOriginalSamplesMonitorFoldername = "";
our $gszNewVirusesMonitorFoldername = "";
our $gszNewTestsMonitorFoldername = "";
our $gszResultsMonitorFoldername = "";
our $gszVmClientsFoldername = "";

#File storage
our $gszFileStorageFoldername = "";

#Result storage
our $gszResultStorageFoldername = "";

#Behavior storage
our $gszBehaviorStorageFoldername = "";

#SubmitSamples related
our $giSubmitSamplesIntervalTime = 0;

#ExtendTest related
our $giExtendTestIntervalTime = 0;
our @gszExtendTestPlatforms = ();

#DispatchTest related
our $giDispatchTestIntervalTime = 0;

#HandleTests related
our $giHandleTestsIntervalTime = 0;
our $giHandleTestsTimeoutPerTest = 0;
our $gszTemplateTestStepsFilename = "";
our $gszTemplateToolsFilename = "";
our $gszTemplateWhitelistFilename = "";
our $gszVmsConfigFilename = "";
our $gszVmsStatusFilename = "";
our $giReadyVmClientCount = "";

#HandleTest related
our $gszHandleTestInstallFoldername = "";
our $gszHandleTestProgramname = "";
our $gszVmrunOriginFilename = "";

#CollectInfo related
our $giCollectInfoIntervalTime = 0;

#VMClient related
our @gszVmClientPlatforms = ();

#Virus sourcing
our $gszVirusSourcingType = "";

#Database
our $gszServer = "";
our $gszUsername = "";
our $gszPassword = "";
our $gszDatabase = "";

#Tools
our $gsz7zipProgramname = "";
our $gszMd5Programname = "";
our $gszSha1Programname = "";
our $gszGetFileTypeProgramname = "";

our $gszDctCompilerProgramname = "";
our $gszDctCompilerPacuFilename = "";
our $gszDctCompilerDctFilename = "";

#Parse behavior related
our $gszSampleInfoFilename = "";
our $gszTestInfoFilename = "";

#malware information
our @gszSampleMd5s = ();
our @gszSampleSha1s = ();
our @gszSampleTypes = ();
our $giSampleSizes = ();

#Test information
our $giVirusId = 0;
our $gszTestOs = "";
our $gszTestResultType = "";
our $gszTestDatetime = "";
our $gszBehaviorFilename = "";

our $gszAutorunscBeforeInfectionFilename = "";
our $gszAutorunscAfterInfectionFilename = "";
our $gszAutorunscAfterRebootFilename = "";
our $gszAutorunscAfterCleanFilename = "";

our $gszLoadedModulesAfterInfectionFilename = "";
our $gszLoadedModulesAfterRebootFilename = "";
our $gszLoadedModulesAfterCleanFilename = "";

our $gszSurveyorAfterInfectionFilename = "";
our $gszSurveyorAfterRebootFilename = "";
our $gszSurveyorAfterCleanFilename = "";

our $gszSysObjectsBeforeInfectionFilename = "";
our $gszSysObjectsAfterInfectionFilename = "";
our $gszSysObjectsAfterRebootFilename = "";
our $gszSysObjectsAfterCleanFilename = "";

our $gszCatchmeAfterRebootFilename = "";
our $gszCatchmeAfterCleanFilename = "";

our $gszSuspiciousFileAfterRebootFilename = "";
our $gszSuspciousFileAfterRebootFoldername = "";

our $gszPacuResultFoldername = "";
our $gszPacuResultFilename = "";

#Autoruns type
our @gszAutorunTypes = ();

#Surveyor file names WL
our @gszSurveyorFilenamesWL = ();

#Mutants WL
our @gszMutantsWL = ();

#Events WL
our @gszEventsWL = ();

#Semaphores WL
our @gszSemaphoresWL = ();

#Loaded modules WL
our @gszLoadedModulesWL = ();

#System environment variables
our @gszSystemEnvVariables = ();

our @gszAddedFilenamesAfterInfection = ();
our @gszModifiedFilenamesAfterInfection = ();
our @gszDeletedFilenamesAfterInfection = ();

our @gszAddedFilenamesAfterReboot = ();
our @gszModifiedFilenamesAfterReboot = ();
our @gszDeletedFilenamesAfterReboot = ();

our @gszAddedFilenamesAfterClean = ();
our @gszModifiedFilenamesAfterClean = ();
our @gszDeletedFilenamesAfterClean = ();

our @gszAddedProcessnamesAfterInfection = ();
our @giAddedProcessIdsAfterInfection = ();
    
our @gszAddedAutorunEntriesAfterInfection = ();
our @gszAddedAutorunImagenamesAfterInfection = ();
our @gszAddedAutorunTypesAfterInfection = ();

our @gszAddedAutorunEntriesAfterReboot = ();
our @gszAddedAutorunImagenamesAfterReboot = ();
our @gszAddedAutorunTypesAfterReboot = ();

our @gszAddedAutorunEntriesAfterClean = ();
our @gszAddedAutorunImagenamesAfterClean = ();
our @gszAddedAutorunTypesAfterClean = ();

our $giHiddenProcessNumberAfterReboot = 0;
our $giHiddenServiceNumberAfterReboot = 0;
our $giHiddenFileNumberAfterReboot = 0;
our @gszHiddenFilenamesAfterReboot = ();

our $giHiddenProcessNumberAfterClean = 0;
our $giHiddenServiceNumberAfterClean = 0;;
our $giHiddenFileNumberAfterClean = 0;
our @gszHiddenFilenamesAfterClean = ();

our @gszAddedMutantsAfterInfection = ();
our @gszAddedEventsAfterInfection = ();
our @gszAddedSemaphoresAfterInfection = ();

our @gszAddedMutantsAfterReboot = ();
our @gszAddedEventsAfterReboot = ();
our @gszAddedSemaphoresAfterReboot = ();

our @gszAddedMutantsAfterClean = ();
our @gszAddedEventsAfterClean = ();
our @gszAddedSemaphoresAfterClean = ();

our @gszAddedLoadedModulesAftetInfection = ();
our @gszAddedLoadedModulesAfterReboot = ();
our @gszAddedLoadedModulesAfterClean = ();

our %gszSuspiciousFileAfterReboot = ();

our @gszPacuMatchedRules = ();

#Statistic behavior
our $giStatisticBehaviorIntervalTime = 0;

#General Dct folder name
our $gszGeneralDctFoldername = "";

our @gszRuleMatchOriginAutorunTypes = ();
our @gszRuleMatchActualAutorunTypes = ();

#BackendAPIs
our $gszServiceIp = "";
our $giDefaultTimeoutPerStep = 0;
our $gszCmd= "";
our $gszSnapShotPath = "";

#Fileserver
our $gszFileserverFoldername = "";
our $gszFileserverVmClientsFoldername = "";

#DataBaseAPIs
our $gszDataBaseIp = "";

1;

