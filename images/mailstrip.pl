#!/usr/bin/perl -T

use strict;
use warnings;
use diagnostics;
use Email::Valid;

# pod....
#
# jason.snakelegs.org
# replace first non-escaped period with an @ symbol 
&mailstrip("noc.example.com");


# and remove escapes
#&mailstrip('some\.user.example.com');


sub mailstrip {
	my $emailaddress = shift;

	# replace first non-escaped period with an @ symbol 
	# my $brain->hurts();
	$emailaddress =~ s/(?<!\\)(?=\.)/\@/;
	$emailaddress =~ s/\@\./\@/;
	$emailaddress =~ s/\\(.)/$1/g;

	print "$emailaddress\n";
}










