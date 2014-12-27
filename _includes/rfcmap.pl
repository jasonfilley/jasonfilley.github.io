#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

if ( $#ARGV < 0 ) {
	die "Specify the RFC's to use as command-line parameters\n";
}

sub stripwhitespace {
	my $string = shift;
	$string =~ s/[\n\r\s]+//g;
	return $string;
}

sub trim {
	my $a = shift;
	$a =~ s/^[\n\r\s]+//g;
	$a =~ s/[\n\r\s]+$//g;
	return $a;
}

sub grabyear {
	my $year = shift;
	$year =~ /(\d{4})\.$/;
	return $1;
}

sub uniq {
	my %h;
	return grep { !$h{$_}++ } @_;
}

sub GetTitleOnly {
	my $title = shift;
	$title =~ /([A-Za-z]*)(0*)(\d*)/;
	my $toreturn = $1 . " " . $3;
	return $toreturn;
}

sub GetFullTitle {
	my $title = shift;
	$title =~ /([A-Za-z]*)(0*)(\d*)/;
	$title =~ /(\"(.*)\\\")/;
	my $toreturn = $2;
	return $toreturn;
}

my @lines   = ();
my @todo    = ();
my @done    = ();
my @final   = ();
my %srcHoA  = ();
my %srcbib  = ();
my %srcdate = ();

push( @todo, @ARGV );
@todo = uniq(@todo);

my $file = "rfc-ref.txt";

open( RFCREF, "<$file" ) || die "Can't open file.\n";
while (<RFCREF>) {
	if (/^RFC/) {
		push( @lines, $_ );
	}
}
close(RFCREF);

while ( scalar(@todo) > 0 ) {
	my $item = shift(@todo);
	foreach my $entry (@lines) {
		my @line = split( '\|', $entry );
		my $RFC = stripwhitespace( $line[0] );

		#hash of arrays (RFC -> @ObsoletedByList)
		my $ObsoletedBy = stripwhitespace( $line[1] );
		my @ObsoletedByList = split( ',', $ObsoletedBy );
		$srcHoA{$RFC} = [@ObsoletedByList];

		#hash (RFC -> Bib)
		my $Bib = $line[2];
		chomp $Bib;
		$Bib = trim($Bib);
		$Bib =~ s/(\")/\\$1/g;
		$srcbib{$RFC} = $Bib;

		#hash (RFC -> date)
		my @working = ();
		push( @working, $RFC );
		push( @working, @ObsoletedByList );

		if ( $item ~~ @working ) {
			unless ( $entry ~~ @final ) {
				push( @final, $entry );    #only if not already in @final
				$srcdate{$RFC} = grabyear($Bib);
			}

			foreach my $workitem (@working) {
				unless ( ( $workitem ~~ @done ) || ( $workitem ~~ @todo ) ) {
					push( @todo, $workitem );
				}
			}
		}
	}
	@todo = grep { $_ ne $item } @todo;
	push( @done, $item );
}

# find lowest to highest quoted years (e.g., 1981..2010)
my $highest_val = ( sort { $b <=> $a } values %srcdate )[0];
my $lowest_val  = ( sort { $a <=> $b } values %srcdate )[0];
my @dates = ( $lowest_val .. $highest_val );

# DRAW THE GRAPH
print
"digraph test { graph [ratio=fill, fontsize=24];\nnode [label=\"\\N\", fontsize=24];\n";

my $yearnodes;
my $yearedges;

#draw the years
for ( my $count = 0 ; $count <= $#dates ; $count++ ) {
	$yearnodes .=
	  $dates[$count] . " [label=" . $dates[$count] . ", shape=plaintext];\n";
	unless ( $count == 0 ) {
		$yearedges .=
		    $dates[ $count - 1 ] . " -> "
		  . $dates[$count]
		  . " [style=dotted, shape=none];\n";
	}
}

print $yearnodes;
print $yearedges;

# draw the bib nodes
foreach my $rfcnode (@done) {
	if ( $rfcnode =~ /^RFC/ ) {

		print $rfcnode
		  . " [label = \""
		  . GetTitleOnly($rfcnode) . "\\n"
		  . GetFullTitle( $srcbib{$rfcnode} )
		  . "\" shape=plaintext, style=filled, color=lightskyblue];\n";
	}
	else {
		print $rfcnode
		  . " [label = \""
		  . GetTitleOnly($rfcnode)
		  . "\" shape=box, style=filled, color=mediumorchid];\n";
	}
}

# set ranks
foreach my $srcnode (@done) {
	if ( $srcnode =~ /^RFC/ ) {
		print "{rank=same; " . $srcnode . " " . $srcdate{$srcnode} . ";}\n";
	}
}

# draw the edges
foreach my $srcnode (@done) {
	if ( $srcnode =~ /^RFC/ ) {
		if ( @{ $srcHoA{$srcnode} } ) {
			foreach my $ref ( @{ $srcHoA{$srcnode} } ) {
				print $srcnode . " -> " . $ref . ";\n";
			}
		}
	}
}

#close the graph
print "}\n"

  #my $outputfilename = trim("@ARGV") . "\." . "dot";
