use Video;
use Cipher;
use Data::Dumper qw/Dumper/;

=for quote
“Be kind, for everyone you meet is fighting a
harder battle.”
    ― Plato
=cut

my $v = shift;
my $player = Video::get_player ($v);
my $vinfo = Video::get_video_info $v;
my $ops = Cipher::get_decipher_oplist ($player);
my $streams = Video::get_formats ($v);

for my $stream (@$streams)
{
    my $url = "";
    if (defined $stream->{"cipher"})
    {
	my $a = Cipher::parse_cipher ($stream->{"cipher"});
	my $sig = $a->{"s"};
	if (defined $a->{"s"})
	{
	    $sig = $a->{"s"};
	    print "sig: $sig\n";
	    my $temp = $a->{"url"};
	    $url .= F4N::url_decode ($temp);
	}
	$sig = Cipher::cipher_decipher ($sig, $ops);
	$url = F4N::url_decode $stream->{"url"};
	$url = $url . "&" . $a->{"sp"} . "=" . $sig;
    }
    else
    {
	$url = $stream->{"url"};
    }
    my @type = split /;/, $stream->{"mimeType"};
    print "$type[0]:$stream->{qualityLabel}: $url\n";
}
