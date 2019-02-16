#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode 'decode';
use Encode 'encode';

sub usage();

if ($#ARGV != 0) {
  usage();
  exit 1;
};

my $dq10_dic = shift(@ARGV);

die("Cannot read ${dq10_dic}.") if (!(-f $dq10_dic && -r $dq10_dic));
open(IN, "<", $dq10_dic) or die("Cannot open ${dq10_dic}.");
binmode(IN);

my %entries;

while (my $line = decode('Shift_JIS', <IN>)) {

  next if $line =~ m/^\s*$/;

  my($reading, $writing, $comment) = split(/[\t\r\n]/, $line);
  $entries{$reading} = {
    'writing' => $writing,
    'comment' => $comment,
  };
}
close(IN);

# Output the tag.
print STDOUT ";; -*- mode: fundamental; coding: utf-8 -*-\n";
print STDOUT ";; okuri-ari entries.\n";
print STDOUT ";; okuri-nasi entries.\n";

foreach my $key (sort keys %entries) {
  print STDOUT encode(
    'UTF-8',
    "${key} /$entries{$key}{'writing'};$entries{$key}{'comment'}/\n"
  );
}

exit 0;

sub usage() {
  print STDERR "\n",
               "usage:\n",
               "\t\$ ${0} /path/to/dq10_dic.txt\n\n";
}
