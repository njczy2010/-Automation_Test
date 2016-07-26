#!/usr/bin/perl -w
use strict;
use JSON;

#以邮件中第四个为例
#4.      /api/case/parsed      完成後 case status 會從finished=> parsed
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

#数组嵌套哈希：
my %filePath;
my @files;
$filePath{'filePath'}='path2';
push @files, {%filePath};
$filePath{'filePath'}='path3';
push @files, {%filePath};

#哈希嵌套数组：
$rec_hash{'files'}=[@files];

#my @array = (I, II, III);
#赋值与取值：[@array]表示复制数组值放入哈希，\@array则表示引用数组值，意味着此数组若更改，哈希中的数组也会相应更改
#$hash{four} = [@array];
my $json = encode_json \%rec_hash;
print "$json\n";


#Perl学习笔记之：数组哈希嵌套
#http://shuai.be/archives/perl-array-inc-hash/
#
#在 Perl 中使用 JSON
#http://wiki.jikexueyuan.com/project/json/with-perl.html
