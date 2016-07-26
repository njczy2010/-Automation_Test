use strict;
use File::Copy;


my ($ver) = @ARGV;

my @verChars = split("", $ver);




my $ptnFile = ".\\sbptn.001";
my $bakPtnFile = $ptnFile . ".bak";
open NEWPATTERN, ">$bakPtnFile" or die "Can't open file $bakPtnFile!\n";
binmode(NEWPATTERN);

my @binArr = (0x56, 0x65, 0x72, 0x20, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0A, 0x00, 0x00, 0x00, 0x00);

my $i = 0;
foreach my $ch (@verChars)
{
	$binArr[$i + 4] = hex($ch) + 0x30;
	$i++;
}


foreach (@binArr)
{
	print NEWPATTERN chr($_);
}

my $buffer;
my $pos = 1;
my $bytes = 0;
open PATTERN, "$ptnFile" or die "Can't open file $ptnFile!\n";
binmode(PATTERN);
while (1)
{
	$bytes = read(PATTERN, $buffer, 1024, 0);
	if ($bytes == 0)
	{
		last;
	}
	print NEWPATTERN $buffer;
}
close PATTERN;
close NEWPATTERN;

File::Copy::move($bakPtnFile, $ptnFile);
unlink($bakPtnFile);