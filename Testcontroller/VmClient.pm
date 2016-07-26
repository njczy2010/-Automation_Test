package VmClient;
use strict;
use warnings;

use FileOperation;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw();

use Variables qw(
                $gszLogFilename
                $gszVmClientsFoldername
                );

sub WhetherIsIdle
{
    my ($szVmClientId) = @_;
    
    my $ret = 1;
    
    my $szFilename = $gszVmClientsFoldername . "VmClient " . $szVmClientId . "\\Idle.txt";
    if ( -e $szFilename ) {
        $ret = 1;
        Log::WriteLog("VmClient $szVmClientId status is Idle.\n");
    }
    else {
        $ret = 0;
        Log::WriteLog("VmClient $szVmClientId status is not Idle.\n");
    }
    
    return $ret;
}

sub WhetherIsTestReady
{
    my ($szVmClientId) = @_;
    
    my $ret = 1;
    
    my $szFilename = $gszVmClientsFoldername . "VmClient " . $szVmClientId . "\\TestReady.txt";
    if ( -e $szFilename ) {
        $ret = 1;
        Log::WriteLog("VmClient $szVmClientId status is TestReady.\n");
    }
    else {
        $ret = 0;
        Log::WriteLog("VmClient $szVmClientId status is not TestReady.\n");
    }
    
    return $ret;
}

sub WhetherIsInTesting
{
    my ($szVmClientId) = @_;
    
    my $ret = 1;
    
    my $szFilename = $gszVmClientsFoldername . "VmClient " . $szVmClientId . "\\InTesting.txt";
    if ( -e $szFilename ) {
        $ret = 1;
        Log::WriteLog("VmClient $szVmClientId status is InTesting.\n");
    }
    else {
        $ret = 0;
        Log::WriteLog("VmClient $szVmClientId status is not InTesting.\n");
    }
    
    return $ret;
}

sub WhetherIsFinish
{
    my ($szVmClientId) = @_;
    
    my $ret = 1;
    
    my $szFilename = $gszVmClientsFoldername . "VmClient " . $szVmClientId . "\\Finish.txt";
    if ( -e $szFilename ) {
        $ret = 1;
        Log::WriteLog("VmClient $szVmClientId status is Finish.\n");
    }
    else {
        $ret = 0;
        Log::WriteLog("VmClient $szVmClientId status is not Finish.\n");
    }
    
    return $ret;
}

sub ChangeStatus
{
    my ($szVmClientId, $szOldStatus, $szNewStatus) = @_;
    
    my $ret = 1;
    
    my $szOldFilename = $gszVmClientsFoldername . "VmClient " . $szVmClientId . "\\$szOldStatus.txt";
    my $szNewFilename = $gszVmClientsFoldername . "VmClient " . $szVmClientId . "\\$szNewStatus.txt";
    
    $ret = FileOperation::RenameFile($szOldFilename, $szNewFilename);
    
    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to change status for VmClient $szVmClientId from $szOldStatus to $szNewStatus.\n");
    }
    else {
        Log::WriteLog("Fail to change status for VmClient $szVmClientId from $szOldStatus to $szNewStatus.\n");
    }
    
    return $ret;
}

1;
