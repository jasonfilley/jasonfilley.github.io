#!/usr/bin/perl
# This is a plodding, quick script to migrate Excalibur EFS
# filerooms (my version at 3.7) to Adobe Acrobat PDF’s. Since
# EFS stores the images in .tiff files, it’s rather easy.
#
# Use efsbatch to export a list of the contents of your fileroom
# (see pg. 6-23 in the Technical Reference).
#
# Create a file “bob.whatever” with contents “DETAILS f:”.
# Then cd to the fileroom (e.g. /image/users/africa_fileroom) and
# run ‘efsbatch bob.whatever >> africa_fileroom.details’.
#
# I copied the fileroom dirs off to a separate machine, hence the
# different paths.  Play around with your setup. This should get
# you close.
#
# requires libtiff for tiffcp and tiff2pdf
# http://www.remotesensing.org/libtiff/

use warnings;
use File::Basename;
use File::Path;

$basepath = '/pickup/EFS/';
$destpath = '/pickup/EFS/processed/';

while (<STDIN>) {
    chop $_;
    if (/^Document/) {
        @docinfo = split( / /, $_, 3 );

        #zero out @sourcetiffs
        $#sourcetiffs = -1;

        #print "$_\n";

        $numofpages = $docinfo[1];
        #print "$numofpages\n";

        $fullpathname = $docinfo[2];
        #print "$fullpathname\n";

        $fullpathname = substr( $fullpathname, 2 );
        #print "$fullpathname\n";

        $dirname = dirname($fullpathname);
        #print "$dirname\n";

        $relativepathname = substr( $dirname, 1 );
        #print "$relativepathname\n";

        $documentname = basename($fullpathname);
        #print "$documentname\n";

    }

    if (/^\d.*\/image\/users\/.*\.tif$/) {

        #print $_;
        #print "\n";

        @imageinfo = split( / /, $_, 3 );

        $tiffdocnum = $imageinfo[0];
        #print "$tiffdocnum\n";

        $tiffpath = $imageinfo[2];
        #print "$tiffpath\n";

        $reltiffpath = substr( $tiffpath, 13 );
        #print "$reltiffpath\n";

        $srctiffpath = $basepath . $reltiffpath;
        #print "srctiffpath = $srctiffpath\n";

        push( @sourcetiffs, $srctiffpath );

        # If this is the last file in the document,
        # create the directory and call tiffcp to merge
        # them into one tiff.  Then run tiff2pdf to create
        # the PDF.

        if ( $tiffdocnum == $numofpages ) {

            #Create the target directory
            $desttiffpath = $destpath . $relativepathname . "\/";

            #print "mkpath($desttiffpath, 1, 0770)\n";
            #mkpath($desttiffpath, 1, 0770);

            #Call tiffcp on @sourcetiffs to final .tiff
            $cmdtiffcp =
              "tiffcp -c lzw @sourcetiffs \"$desttiffpath$documentname.tiff\"";

            #print "sourcetiffs = @sourcetiffs\n";
            print "$cmdtiffcp\n\n";

            #Convert final .tiff to PDF
            $cmdtiff2pdf =
"tiff2pdf \"$desttiffpath$documentname.pdf\" \"$desttiffpath$documentname.tiff\"";
            print "$cmdtiff2pdf\n\n";

        }

    }

}

