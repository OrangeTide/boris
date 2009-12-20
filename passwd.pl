#! /usr/bin/perl
#
# generates a seeded SHA1 hash of a password and salt.
#
# Example:
# 'secret' 'salt' {SSHA}v6NHfU7qsQGm7kiR4Be5hisF4I5zYWx0Cg==
#
use strict;
use Digest::SHA1 qw(sha1);
use MIME::Base64 qw(encode_base64);
print "Password: ";
my $cleartext = <STDIN>;
print "Salt: ";
my $salt = <STDIN>;
chomp($cleartext);
chomp($salt);
print '{SSHA}' .  encode_base64(sha1($salt . $cleartext) . $salt);
