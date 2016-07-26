package DataBaseAPIs;
use strict;
use warnings;

#function : DataBaseAPIs

use LWP 5.64; # load LWP classes

use Encode;     
use JSON;
use Data::Dumper;
use Log;

#function : Get Next Case
sub GetNextCase{
    
    my ($szDatabaseIp,$szAppName,$szOsName,$iTimeout) = @_;
    my $ret = 1;   
    #if exist NULL value
    if ($szDatabaseIp eq "" || $szAppName eq "" || $szOsName eq "") {
       # print "Usage: Free(\$szVm)\n";
        goto _END_GetNextCase;
    }
    if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to get next case.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);

    
   #get request:
    my $url = "http:\/\/$szDatabaseIp\/api\/case\/getnext\/$szAppName\/$szOsName"; 
    my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_GetNextCase;
   }
   
   #fail if match "Error"
   if(index($response->content,"\"Message\": \"Case Not Found\"")!=-1){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_GetNextCase;
   }
   
    my $json = new JSON;
    my $obj = $json->decode($response->content);
    #print "json file:".Dumper($obj);
    
   
_END_GetNextCase:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to get next case.\n");
        return $obj;
    }
    else {
        Log::WriteLog("Fail to get next case.\n");
        Log::WriteLog("$url \n");
        return $ret;
    }
    
    #return $ret;
    #return Dumper($obj);
}

####need to modify####
sub Finished{
    
    my ($szDatabaseIp,$szCaseID,$szDetected,$szResult,$iTimeout) = @_;
    my $ret = 1;   
    #if exist NULL value
    if ($szDatabaseIp eq "" || $szCaseID eq "" || $szDetected eq "" || $szResult eq "") {
       # print "Usage: Free(\$szVm)\n";
 #       goto _END_Finished;
        ;
    }
 
    if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to post result to database.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);
    
    my %szResult =  ('caseID' => $szCaseID, 'detected' => $szDetected, 'result' => $szResult);
    my $json = encode_json (\%szResult);

    
   #get request:
    my $url = "http:\/\/$szDatabaseIp\/api\/case\/finished"; 
    my $response = $browser->post( $url,$json );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        #print "Can't post $url -- $szResponseStatus_line.\n";
        Log::WriteLog("Can't post $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_Finished;
   }
   
   
_END_Finished:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to post result to database.\n");
    }
    else {
        Log::WriteLog("Fail to post result to database.\n");
        Log::WriteLog("$url \n");
    }  
    return $ret;
}

1;