package Video;
use strict;
use warnings;
use F4N;
use Cipher;
use Cache::File;
use JSON::XS;
use Exporter qw/import/;

our @EXPORT_OK = qw/get_video_info get_formats/;

use constant
    EURL => "https://youtube.googleapis.com/v/";
use constant
    BASE => "https://youtube.com/";
use constant
    V_INFO => BASE . "get_video_info?video_id=";

=for quote
“Nobody ever figures out what life is all about,
and it doesn't matter. Explore the world. Nearly
everything is really interesting if you go into it
deeply enough.”  
    ― Richard P. Feynman
=cut

sub get_video_info
{
    my $id = shift;
    my $loc = V_INFO . "${id}&el=embedded&hl=en&eurl="
	. EURL;
    my $page = F4N::fetch ($loc);
    $page = F4N::split_query ($page);
    return $page;
}

sub get_embed_page
{
    my $id = shift;
    my $loc = "https://youtube.com/embed/${id}?"
	. "disable_polymer=true&hl=en";
    my $page = F4N::fetch ($loc);
    return $page;
}

sub get_player_config
{
    my $id = shift;
    my $embed_page = get_embed_page $id;
    my $config = $1 if $embed_page =~
	m/yt\.setConfig\(\{'PLAYER_CONFIG':(.*)\}\);/;
    die "Could not get config." unless $config;
    my $json = JSON::XS->new;
    my $config_json = $json->decode ($config);
    return $config_json;
}

sub get_player_response
{
    my $id = shift;
    my $player_config = get_video_info $id;
    my $json = JSON::XS->new;
    $player_config = $json->decode
	(F4N::url_decode ($player_config->{"player_response"}));
    return $player_config;
}

sub get_formats
{
    my $id = shift;
    my $player_response = get_player_response $id;
    die "Video not playable." unless
	$player_response->{"playabilityStatus"}->{"status"} eq "OK";
    my $formats = $player_response->{"streamingData"}->{"adaptiveFormats"};
    return $formats;
}

sub print_streams
{
    my $id = shift;
    my $fmts = get_formats $id;
    for my $i (@$fmts)
    {
	print $i->{"url"} . "\n";
    }
}

sub get_player
{
    my $id = shift;
    my $cache = Cache::File->new (cache_root => ".caches");
    my $player = $cache->get ("saved");
    if (!defined $player)
    {
	my $json = get_player_config $id;
	my $url = BASE . $json->{"assets"}->{"js"};
	$player = F4N::fetch ($url);
	$cache->set ("saved", $player, "10 d");
    }
    return $player;
}

"End...";
