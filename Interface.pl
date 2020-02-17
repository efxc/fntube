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
my $ops = Cipher::get_decipher_oplist ($player);
print Dumper $ops;
my $streams = Video::get_formats ($v);
for my $stream (@$streams)
{
    my $url = "";
    if (defined $stream->{"cipher"})
    {
	my $a = Cipher::parse_cipher ($stream->{"cipher"});
	my $sig = $a->{"s"};
	$sig = Cipher::cipher_decipher ($sig, $ops);
	$url = F4N::url_decode $a->{"url"};
	$url .= "&" . $a->{"sp"} . "=" . $sig;
    }
    else
    {
	$url = $stream->{"url"};
    }
    print "$url\n";
}
