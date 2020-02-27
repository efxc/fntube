#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
my $cgi = CGI->new;
my $type = $cgi->param ("t");
my $name = $cgi->param ("n");
do { print $cgi->header;
     die "Yanlış kullanım" } unless ($name && $type);
print $cgi->header (-type => $type);
my $fh;
open $fh, "</tmp/$name" or die "Hata, $!";
print while <$fh>;
