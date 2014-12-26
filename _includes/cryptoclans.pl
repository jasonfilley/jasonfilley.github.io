#!/usr/bin/perl -T

# Copyright (c) 2010 Jason Filley jason@snakelegs.org
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED 'AS IS' AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
# Purpose: create cryptoclans
# Usage:  create a pipe-delimited file with the first field being the topic,
#       and each additional field is the item.
# cat yourfile.txt | cryptoclans.pl
#
# Example:
# Pets|dog|cat|fish|parakeet|lemur|skunk|guinea pig|iguana
# Car Make|Ford|Dodge|Chrysler|Toyota|Honda|Hyundai|Jeep
# Dog Breeds|Sheltie|Boxer|German Shepherd|Poodle|Rottweiler|Australian Terrier|Whippet

use List::Util 'shuffle';

my $AllowedLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
my $AllowedPunctuation = ' \'-';

while (<STDIN>) {

 my @line = split( '\|', $_ );
 $topic = shift(@line);

 # Create ciphertext alphabet
 @ciphertext = split '', $AllowedLetters;
 @ciphertext = shuffle(@ciphertext);
 my $cipher = join '', @ciphertext;
 my @outlist = ();

 print '$topic\n';
 print('-' x length ($topic));
 print '\n';

 foreach $item (@line) {
     $item = uc($item);
     chomp $item;

     $output = '';

     foreach my $byte ( split //, $item ) {

         if ( $AllowedPunctuation =~ /$byte/ ) {
             $output .= $byte;

         } elsif ( $AllowedLetters =~ /$byte/ ) {
             #find its index in the plaintext array
             $index = index( $AllowedLetters, $byte );

             #find the ciphertext character with the same index
             $char = substr( $cipher, $index, 1);
             $output .= $char;
         } else {
             die 'Bad character in input!\n'; }
         }

         push @outlist, '$output';
    }

    print map { '$_ \n' } @outlist;
    print '\n\n';
}

