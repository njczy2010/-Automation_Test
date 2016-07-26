#!/usr/bin/perl -w
use strict;
use BackendAPIs;

use DataBaseAPIs;

use Encode;
use JSON;
use Data::Dumper;

#my ($szDatabaseIp,$szAppName,$szOsName,$iTimeout) = ("192.168.0.40","cb","win7",60);

#my $szGetNextCaseJson=DataBaseAPIs::GetNextCase($szDatabaseIp,$szAppName,$szOsName,$iTimeout);

#print "$szGetNextCaseJson \n";
#print Dumper($szGetNextCaseJson);

my ($szDatabaseIp,$szCaseID,$szDetected,$szResult,$iTimeout) = ("192.168.0.40","2c9cb105-f27e-4b59-bb92-d3430de0b488","false","true",60);
my $ret = DataBaseAPIs::Finished($szDatabaseIp,$szCaseID,$szDetected,$szResult,$iTimeout);

print "$ret \n";

#find idle client
#my $start = -1;
#while( ($start = index($szStateInfo,"STATE",$start) ) != -1 )
#{
#    print "$start \n";
#    $start++;
#}


