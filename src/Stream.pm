package Stream;
use Video;
use Cipher;
use F4N;
use strict;
use warnings;

sub streams_as_array
{
    my $v = shift;
    my $player = Video::get_player $v;
    my $ops = Cipher::get_decipher_oplist $player;
    my $streams = Video::get_formats $v;
    my $url = "";
    my @s_array = ();
    
    for my $stream (@$streams)
    {
	if (defined $stream->{"cipher"})
	{
	    my $c = Cipher::parse_cipher $stream->{"cipher"};
	    my $sig = $c->{"s"};
	    $sig = Cipher::cipher_decipher $sig, $ops;
	    $url = $c->{"url"};
	    $url = join "", F4N::url_decode $url,
		"&", $c->{"sp"}, "=", F4N::url_encode $sig;
	}
	else
	{
	    $url = $stream->{"url"};
	}

	my %info;
	$info{"quality"} = $stream->{"qualityLabel"} ||
	    $stream->{"size"} || "";
	my @type = split /;/, $stream->{"mimeType"};
	my $type = $type[0];
	$info{"type"} = $type;
	$info{"url"} = $url;
	push @s_array, \%info;
    }
    return \@s_array;
}

"End...";
