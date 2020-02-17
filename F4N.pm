package F4N;
use strict;
use warnings;
use Exporter qw/import/;
use LWP::UserAgent;

our @EXPORT_OK = qw/url_encode fetch split_query/;

=for quote
“I cannot teach anybody anything. I can only make
them think” 
    ― Socrates
=cut

sub url_encode
{
    my $st = shift;
    $st =~ s/ /\+/;
    $st =~
	s/([^a-zA-Z0-9_\.~-])/sprintf ("%%%02X", ord ($1))/eg;
    return $st;
}

sub url_decode
{
    my $st = shift;
    $st =~ s/\+/ /;
    $st =~
	s/%([a-fA-F0-9]{2})/pack ('C', hex ($1))/eg;
    return $st;
}

sub fetch
{
    my $loc = shift;
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get ($loc);
    die "Invalid response" unless $response->is_success;
    return $response->decoded_content;
}

sub split_query
{
    my $data = shift;
    my @fields = split '&', $data;
    my %params = map { split '=', $_, 2 } @fields;
    return \%params;
}

"End...";
