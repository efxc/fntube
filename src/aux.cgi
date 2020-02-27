#!/usr/bin/perl
use lib "/usr/lib/cgi-bin";
use strict;
use warnings;
use F4N qw(url_decode);
use LWP::UserAgent;

my ($loc, $fname) = @ARGV;
my $ua = LWP::UserAgent->new;
my $request = $ua->mirror (url_decode ($loc), "/tmp/$fname");
die $request->error_as_HTML if ($request->is_error);
