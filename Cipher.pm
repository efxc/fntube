package Cipher;
use Data::Dumper;
use strict;
use warnings;
use Exporter qw/import/;

our @EXPORT_OK = qw/get_decipher_statements/;

sub get_decipher_func
{
    my $player = shift;
    my $func_name = $1
	if $player =~
	m/([a-zA-Z0-9]{2})=function\(a\)\{a=a\.split.*?return a\.join/;
    die "Couldn't find decipherer function name." unless $func_name;
    return $func_name;
}

sub get_decipher_body
{
    my $player = shift;
    my $stmts = get_decipher_statements ($player);
    my $ident = qr/[a-zA-Z0-9]{2}/;
    my $f = $stmts->[0];
    my $name = $1 if $f =~ m/([a-zA-Z0-9]{2})\./;
    die "Couldn't find decipherer definition name." unless $name;
    my $body = $1 if $player
	=~ m/var $name=\{(($ident:function\(.*?\)\{.*?\},?)*)\};/s;
    return $body;
}

sub get_decipher_statements
{
    my $player = shift;
    my $func = get_decipher_func $player;
    my $body = $1
	if $player =~
	m/$func=function\(a\)\{a=a\.split\(""\);(.*?);return a\.join/;
    my @statements = split /;/, $body;
    return \@statements;
}

sub get_decipher_oplist
{
    my $player = shift;
    my $ident = qr/[a-zA-Z0-9]{2}/;
    my $args  = qr/([a-zA-Z],)*([a-zA-Z])/;
    my @ops;
    my $defbody = get_decipher_body $player;
    my $decstmts = get_decipher_statements $player;
    for my $stmt (@$decstmts)
    {
	my $fname = $1 if $stmt =~ m/$ident\.($ident)\(/;
	next unless $fname;
	if ($defbody =~ m/$fname:function\($args\)\{a\.reverse/)
	{
	    push @ops, { "reverse" => 0 };
	}
	if ($defbody =~ m/$fname:function\($args\)\{a\.splice\(/)
	{
	    my $operand = $1 if $stmt =~ m/\(.*?,(.*?)\)/;
	    push @ops, { "splice" => $operand };
	}
	else
	{
	    my $operand = $1 if $stmt =~ m/\(.*?,(.*?)\)/;
	    push @ops, { "replace" => $operand };
	}
    }
    return \@ops;
}

sub cipher_reverse
{
    my $cipher = shift;
    return reverse $cipher;
}

sub cipher_replace
{
    my ($cipher, $idx) = @_;
    my $first = substr $cipher, 0, 1;
    my $loc = $idx % length $cipher;
    my $item = substr $cipher, $loc, 1;
    substr $cipher, 0, 1, $item;
    substr $cipher, $loc, 1, $first;
    return $cipher;
}

sub cipher_splice
{
    my ($cipher, $idx) = @_;
    my @c = split //, $cipher;
    splice @c, 0, $idx;
    $cipher = join "", @c;
    return $cipher;
}

sub cipher_decipher
{
    my ($sig, $ops) = @_;
    for my $op (@$ops)
    {
	$sig = cipher_reverse $sig if defined $op->{"reverse"};
	$sig = cipher_splice $sig, $op->{"splice"} if defined $op->{"splice"};
	$sig = cipher_replace $sig, $op->{"replace"} if defined $op->{"replace"};
    }
    return $sig;
}

sub parse_cipher
{
    my $c = shift;
    $c = F4N::split_query ($c);
    $c->{"s"} = F4N::url_decode $c->{"s"};
    return $c;
}

"End...";
