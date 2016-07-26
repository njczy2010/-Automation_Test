package Zip;
use strict;
use warnings;

use Log;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw();

sub Compress
{
    my ($szProgramname, $szSourceFoldername, $szDestFilename) = @_;
    
    my $ret = 0;
    
    my $szCmd = "\"$szProgramname\"" . " a -pvirus " . $szDestFilename . " $szSourceFoldername";
    my @szLogs = `$szCmd`;
    
    my $i = 0;
    for ( $i = 0; $i < @szLogs; $i ++ ) {
        chomp($szLogs[$i]);
        my $szLine = $szLogs[$i];
            
        if ( $szLine eq "Everything is Ok" ) {
            $ret = 1;
            last;
        }
    }
    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to compress folder \"$szSourceFoldername\" to file \"$szDestFilename\".\n");        
    }
    else {
        Log::WriteLog("Fail to compress folder \"$szSourceFoldername\" to file \"$szDestFilename\".\n");        
        goto _END_Compress;
    }

_END_Compress:

    return $ret;
    
}


sub Decompress
{
    my ($szProgramname, $szSourceFilename, $szDestFoldername) = @_;
    
    my $ret = 0;
    
    if ( !-e $szSourceFilename ) {
        Log::WriteLog("File \"$szSourceFilename\" does not exist.\n");
        goto _END_Decompress;
    }
    
    my $szCmd = "\"$szProgramname\"" . " x -pvirus " . $szSourceFilename . " -o" . $szDestFoldername;
    my @szLogs = `$szCmd`;
    
    my $i = 0;
    for ( $i = 0; $i < @szLogs; $i ++ ) {
        chomp($szLogs[$i]);
        my $szLine = $szLogs[$i];
            
        if ( $szLine eq "Everything is Ok" ) {
            $ret = 1;
            last;
        }
    }
    
_END_Decompress:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to decompress file \"$szSourceFilename\".\n");        
    }
    else {
        Log::WriteLog("Fail to decompress file \"$szSourceFilename\".\n");
    }

    return $ret;
    
}

1;
