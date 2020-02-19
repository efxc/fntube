use Video;
use Cipher;
use Stream;
use CGI ':standard';
use strict;
use warnings;

# “Be kind, for everyone you meet is fighting a
# harder battle.”
#     ― Plato

my $v = shift;
my $streams = Stream::streams_as_array $v;

# my $player = Video::get_player ($v);
# my $ops = Cipher::get_decipher_oplist ($player);
# my $streams = Video::get_formats ($v);

# for my $stream (@$streams)
# {
#     my $url = "";
#     if (defined $stream->{"cipher"})
#     {
# 	my $a = Cipher::parse_cipher ($stream->{"cipher"});
# 	my $sig = $a->{"s"};
	
# 	if (defined $a->{"s"})
# 	{
# 	    $sig = $a->{"s"};
# 	    my $temp = $a->{"url"};
# 	    $url = $temp;
# 	}
	
# 	$sig = Cipher::cipher_decipher ($sig, $ops);
# 	$url = F4N::url_decode $url . "\&$a->{sp}=" .
# 	    F4N::url_encode $sig;
#     }

#     else
#     {
# 	$url = $stream->{"url"};
#     }

#     my @type = split /;/, $stream->{"mimeType"};
#     my $type = $type[0];
#     print "$type: $url\n";
# }
