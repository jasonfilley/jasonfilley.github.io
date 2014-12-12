#!/usr/bin/perl -T

# Copyright (c) 2007 Jason Filley <jason@snakelegs.org>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

# usage: perl -T convert_subscribers.pl LISTNAME-L < .subscribers
#
# input is a ListProc subscription file (6.0c tested).  Note that
# LISTERV command batches must be under 1MB, so for large lists, 
# you'll need to split the email messages up.

use strict;
use warnings;
use Email::Valid;

my $LISTSERV;
my $LISTSERVoptions;
my $listname = $ARGV[0];

while (<STDIN>) {

	chomp $_;

	# Listproc subscription
	# 	EMAILADDRESS@EXAMPLE.COM
	#	[ACK,NOACK,DIGEST,POSTPONE]
	# 	SUBSCRIPTION DATE 
	#	CONCEAL=(YES|NO)
	#   SOME.BODY@EXAMPLE.COM ACK 1063657245 NO Some Body Special
	my @ListProc = split(/ /, $_, 5);

	my $emailaddress = lc($ListProc[0]);
	my $option = $ListProc[1];
	my $subscriptiondate = $ListProc[2];
	my $concealment = $ListProc[3];
	my $name = $ListProc[4];

	if (Email::Valid->address("$emailaddress")) {

		my $LISTSERV = "QUIET ADD $listname $emailaddress";
		if ($name) {$LISTSERV .= " $name";} print "$LISTSERV\n";
	
		if ($option eq 'ACK') {$LISTSERVoptions = "REPRO"} 
		elsif ($option eq 'NOACK') {$LISTSERVoptions = "NOREPRO"} 
		elsif ($option eq 'DIGEST') {$LISTSERVoptions = "DIGEST"}
		elsif ($option eq 'POSTPONE') {$LISTSERVoptions = "NOMAIL"}
		else {print STDERR "option:$listname:bad option $option:for $emailaddress\n";}

		$LISTSERVoptions = "QUIET SET $listname $LISTSERVoptions FOR $emailaddress";
		print "$LISTSERVoptions\n";

	} else {
		print STDERR "email:$listname:bad address $emailaddress for $name\n";
	}
}
