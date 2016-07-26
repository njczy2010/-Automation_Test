#!/usr/bin/perl -w
use strict;
use JSON;

#���ʼ��е��ĸ�Ϊ��
#4.      /api/case/parsed      ����� case status ����finished=> parsed
#http post
#Success:
#{
    #caseID: guid,
    #result: true,
    #detected: true,
    #report: {filePath: path},
    #files: [{filePath: path2 }, {filePath: path3}]
#}


my $szCaseID = 'guid';
my %rec_hash = ('caseID' => $szCaseID,'result' =>'true','detected' =>'true', 'report' => {'filePath' => "path"} );

#����Ƕ�׹�ϣ��
my %filePath;
my @files;
$filePath{'filePath'}='path2';
push @files, {%filePath};
$filePath{'filePath'}='path3';
push @files, {%filePath};

#��ϣǶ�����飺
$rec_hash{'files'}=[@files];

#my @array = (I, II, III);
#��ֵ��ȡֵ��[@array]��ʾ��������ֵ�����ϣ��\@array���ʾ��������ֵ����ζ�Ŵ����������ģ���ϣ�е�����Ҳ����Ӧ����
#$hash{four} = [@array];
my $json = encode_json \%rec_hash;
print "$json\n";


#Perlѧϰ�ʼ�֮�������ϣǶ��
#http://shuai.be/archives/perl-array-inc-hash/
#
#�� Perl ��ʹ�� JSON
#http://wiki.jikexueyuan.com/project/json/with-perl.html
