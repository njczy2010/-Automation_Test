#!/usr/bin/perl -w
use strict;

use HandleTest;

my @argv = @ARGV;
###???##
#@argv = "\\\\10.65.0.5\\zfs_ivm_pool_instantvm\\PRODUCT_AUTOMATION\\DDES\\VmClients\\VmClient1\\";
#@argv = "C:\\Data\\VmClients\\VmClient1\\";


if ( @argv == 0 ) {
    print "Usage: perl.exe HandleTest.pl Foldername\n";
    goto _END;
}

my $szParentFoldername = $argv[0];

my $iRet = HandleTest::HandleTest($szParentFoldername);

my $szOldStatus = "InTesting";
my $szNewStatus = "";
if ( $iRet == 1 ) {
    $szNewStatus = "Finish";
}
else {
    $szNewStatus = "TestReady";
}
my $szOldFilename = $szParentFoldername . $szOldStatus . ".txt";
my $szNewFilename = $szParentFoldername . $szNewStatus . ".txt";

my $i = 0;
for ( $i = 0; $i < 5; $i ++ ) {
    $iRet = rename($szOldFilename, $szNewFilename);
    if ( (!-e $szOldFilename) && (-e $szNewFilename) ) {
        $iRet = 1;
        last;
    }
    sleep(1);
}
if ( $iRet == 1 ) {
    Log::WriteLog("Succeed to change status for from \"$szOldStatus\" to \"$szNewStatus\".\n");
}
else {
    Log::WriteLog("Fail to change status for from \"$szOldStatus\" to \"$szNewStatus\".\n");
}

_END:

