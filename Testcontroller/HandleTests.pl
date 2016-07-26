#!/usr/bin/perl -w
use strict;
#function£ºControll the tests process
use InitializeSystem;
use HandleTests;

use Win32::Process;

use Variables qw(
                $gszLogFoldername
                $gszLogFilename                
                );

goto _END if ( !InitializeSystem::InitializeSystem );
$gszLogFilename = $gszLogFoldername . "HandleTests.log";

##???###
#unlink($gszLogFilename);

HandleTests::HandleTestsPeriodly();

_END:
