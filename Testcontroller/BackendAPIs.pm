package BackendAPIs;
use strict;
use warnings;

#function?BackendAPIs

use LWP 5.64; # load LWP classes


use Encode;     
use JSON;
use Data::Dumper;

# function : Get a new VM, and return the VM ID
sub NewGuest{
    
    my ($szServiceIp,$szProduct,$szTemplate,$szSample,$iTimeout) = @_;
    my $ret = 1; 
    #if exist NULL value
    if ($szServiceIp eq "" || $szProduct eq "" || $szTemplate eq "" || $szSample eq "") {
        #print "Usage: NewGuest(\$product,\$template,\$sample)\n";
        $ret = 0;
        goto _END_NewGuest;
    }
    
    if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to get new guest.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);
      
   #get request:
    my $url = "http:\/\/$szServiceIp\/NewGuest.ashx?product=$szProduct&template=$szTemplate&sample=$szSample"; 
    my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_NewGuest;
   }
   
   #fail if start with '{'
   if($response->content =~ m/^{/){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_NewGuest;
   }
   
_END_NewGuest:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to get new guest.\n");
        return $response->content;
    }
    else {
        Log::WriteLog("Fail to get new guest.\n");
        Log::WriteLog("$url \n");
        return $ret;
    }
    
    #return $ret;
}


# function : Copy sample files from File server to VM
sub CopyFileFromHostToGuest{
    
   # my $szSourcefile = $szParentFoldername;
    my ($szServiceIp,$szVm,$szSourcefile,$szDestfile,$iTimeout) = @_;
    my $ret = 1;
   
    #if exist NULL value
    if ($szServiceIp eq "" || $szVm eq "" || $szSourcefile eq "" || $szDestfile eq "") {
    #    print "Usage: CopyFileFromHostToGuest(\$szVm,\$szSourcefile,\$szDestfile)\n";
        $ret = 0;
        goto _END_CopyFileFromHostToGuest;
    }
    
    if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to copy file from host to guest.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);
    
  # get request:
    my $url = "http:\/\/$szServiceIp\/CopyFileFromHostToGuest.ashx?vm=$szVm&sourcefile=$szSourcefile&destfile=$szDestfile"; 
    my $response = $browser->get( $url );
  #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_CopyFileFromHostToGuest;
   }
   
    #fail if start with '{'
   if($response->content =~ m/^{/){
   #if(!$response->content eq "1"){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_CopyFileFromHostToGuest;
   }
   
_END_CopyFileFromHostToGuest:

    if ( $ret == 1 ) {
        Log::WriteLog("Success to copy file from host to guest.\n");
    }
    else {
        Log::WriteLog("Fail to copy file from host to guest.\n");
        Log::WriteLog("$url \n");
    }
    
    return $ret;
}

# function : Copy sample files from VM to File server 
sub CopyFileFromGuestToHost{
    
    my ($szServiceIp,$szVm,$szSourcefile,$szDestfile,$iTimeout) = @_;
    my $ret = 1;
    #if exist NULL value
    if ($szServiceIp eq ""  || $szVm eq "" || $szSourcefile eq "" || $szDestfile eq "") {
       # print "Usage: CopyFileFromGuestToHost(\$szVm,\$szSourcefile,\$szDestfile)\n";
        $ret = 0;
        goto _END_CopyFileFromGuestToHost;
    }
    if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to copy file from guest to host.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);

  # get request:
 # my $url = 'http://$szServiceIp/CopyFileFromGuestToHost.ashx?vm=c0546f4e-b265-4fbd-a6e3-146d6397e759&sourcefile=C:\log.txt&destfile=\\10.65.0.5\zfs_ivm_pool_instantvm\PRODUCT_AUTOMATION\DDES\samples\log'; 
  my $url = "http:\/\/$szServiceIp\/CopyFileFromGuestToHost.ashx?vm=$szVm&sourcefile=$szSourcefile&destfile=$szDestfile"; 
  my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_CopyFileFromGuestToHost;
   }
   
   #fail if start with '{'
   if($response->content =~ m/^{/){
   #if(!$response->content eq "1"){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_CopyFileFromGuestToHost;
   }
   
_END_CopyFileFromGuestToHost:

    if ( $ret == 1 ) {
        Log::WriteLog("Success to copy file from guest to host.\n");
    }
    else {
        Log::WriteLog("Fail to copy file from guest to host.\n");
        Log::WriteLog("$url \n");
    }
    
    return $ret;
}

# function : Execute file in the VM
sub ExecuteInGuest{
    
    my ($szServiceIp,$szVm,$szCmd,$iTimeout) = @_;
    my $ret = 1;   
    #if exist NULL value
    if ($szServiceIp eq "" || $szVm eq "" || $szCmd eq "" || $iTimeout eq "") {
        #print "Usage: ExecuteInGuest(\$szVm,\$szCmd,\$iTimeout)\n";
        $ret = 0;
        goto _END_ExecuteInGuest;
    }
    
    Log::WriteLog("Begin to execute in guest.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout+10);
    
   #get request:
    my $url = "http:\/\/$szServiceIp\/ExecuteInGuest.ashx?vm=$szVm&cmd=$szCmd&timeout=$iTimeout"; 
    my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_ExecuteInGuest;
   }
   
   #fail if start with '{'
   if($response->content =~ m/^{/){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        goto _END_ExecuteInGuest;
   }
   
_END_ExecuteInGuest:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to execute in guest.\n");
    }
    else {
        Log::WriteLog("Fail to execute in guest.\n");
        Log::WriteLog("$url \n");
    }
    
    return $ret;
}

# function : Reboot VM and wait for OS Ready
sub RebootGuest{
    
    my ($szServiceIp,$szVm,$iTimeout) = @_;
    my $ret = 1;   
    #if exist NULL value
    if ($szServiceIp eq "" || $szVm eq "") {
        #print "Usage: RebootGuest(\$szVm)\n";
        $ret = 0;
        goto _END_RebootGuest;
    }
     if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to reboot guest.\n");
    
    my $browser = LWP::UserAgent->new;
        $browser->timeout($iTimeout);

    
    
   #get request:
    my $url = "http:\/\/$szServiceIp\/RebootGuest.ashx?vm=$szVm"; 
    my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_RebootGuest;
   }
   
   #fail if start with '{'
   if($response->content =~ m/^{/){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_RebootGuest;
   }
   
_END_RebootGuest:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to reboot guest.\n");
    }
    else {
        Log::WriteLog("Fail to reboot guest.\n");
        Log::WriteLog("$url \n");
    }
    
    return $ret;
}


# function : Screenshots, and upload the files to a specified location
sub ScreenSnapShot{
     
    my ($szServiceIp,$szVm,$szResultfile,$iTimeout) = @_;
    my $ret = 1;
    #if exist NULL value
    if ($szServiceIp eq "" || $szVm eq "" || $szResultfile eq "") {
        #print "Usage: ScreenSnapShot(\$szVm,\$Resultfile)\n";
        $ret = 0;
        goto _END_ScreenSnapShot;
    }
    if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to do ScreenSnapShot.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);
    
    my $time = localtime();
    while($time =~s/[:]+//){
        ;
    }
    while($time =~s/[\s]/-/){
        ;
    }
    my $filename = $time . ".png";
    
  # get request:
    my $url = "http:\/\/$szServiceIp\/ScreenSnapShot.ashx?vm=$szVm&resultfile=$szResultfile$filename";
    my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_ScreenSnapShot;
   }
   
   if($response->content eq "-100"){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_ScreenSnapShot;
   }
   
_END_ScreenSnapShot:

    if ( $ret == 1 ) {
        Log::WriteLog("Succeed to do ScreenSnapShot.  time=$time\n");
    }
    else {
        Log::WriteLog("Fail to do ScreenSnapShot.\n");
        Log::WriteLog("$url \n");
    }
    
    return $ret;
}


# function : Release VM, VM will be reverted to its original state, then VM can execute new sample file
sub FreeGuest{
    
    my ($szServiceIp,$szVm,$iTimeout) = @_;
    my $ret = 1;   
    #if exist NULL value
    if ($szServiceIp eq "" || $szVm eq "") {
       # print "Usage: Free(\$szVm)\n";
        goto _END_FreeGuest;
    }
    
    Log::WriteLog("Begin to free guest.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);
   
   #get request:
    my $url = "http:\/\/$szServiceIp\/FreeGuest.ashx?vm=$szVm"; 
    my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_FreeGuest;
   }
   
   #fail if match -100
   if($response->content eq "-100"){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_FreeGuest;
   }
   
_END_FreeGuest:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to free guest.\n");
    }
    else {
        Log::WriteLog("Fail to free guest.\n");
        Log::WriteLog("$url \n");
    }
    
    return $ret;
}


#function : Get all the VM state
sub GuestState{
    
    my ($szServiceIp,$iTimeout) = @_;
    my $ret = 1;   
    #if exist NULL value
    if ($szServiceIp eq "") {
       # print "Usage: Free(\$szVm)\n";
        goto _END_GuestState;
    }
    if($iTimeout eq ""){
        $iTimeout = 60;
    }
    
    Log::WriteLog("Begin to get guest state.\n");
    
    my $browser = LWP::UserAgent->new;
    $browser->timeout($iTimeout);

    
   #get request:
    my $url = "http:\/\/$szServiceIp\/GuestState.ashx"; 
    my $response = $browser->get( $url );
  
   #die "Can't get $url -- ", $response->status_line
   #unless $response->is_success;
   
   if(! $response->is_success){
        my $szResponseStatus_line = $response->status_line;
        Log::WriteLog("Can't get $url -- $szResponseStatus_line.\n");
        $ret = 0;
        goto _END_GuestState;
   }
   
   #fail if match -100
   if($response->content eq "-100"){
        $ret = 0;
        my $szResponseContent = $response->content;
        Log::WriteLog("$szResponseContent\n");
        
        goto _END_GuestState;
   }
   
    my $json = new JSON;
    my $obj = $json->decode($response->content);
    #print "json file:".Dumper($obj);
    
   
_END_GuestState:
    
    if ( $ret == 1 ) {
        Log::WriteLog("Success to get guest state.\n");
        return $obj;
    }
    else {
        Log::WriteLog("Fail to get guest state.\n");
        Log::WriteLog("$url \n");
        return $ret;
    }
    
    #return $ret;
    #return Dumper($obj);
}

1;