#!/usr/bin/perl -w
# Copyright 2011 Jason Filley
#
#
# tcpdump -r capture.cap -s 65535 'dst port 3389 and tcp[37] == 0xe0'

use 5.10.0;
use strict;
use Net::PcapUtils;
use NetPacket::Ethernet qw(:strip);
use NetPacket::IP;
use NetPacket::TCP;

my $filename = $ARGV[0];
my $filter   = "dst port 3389 and tcp[37] == 0xe0";
my $filter_t;
my $err = '';

my $pcap = Net::Pcap::open_offline( "$filename", \$err )
  or die "Cannot open file...$err\n";
Net::Pcap::compile( $pcap, \$filter_t, $filter, 1, 0 );
Net::Pcap::setfilter( $pcap, $filter_t );

sub get_cookie {
    my $cookie = shift;
    $cookie =~ /Cookie: (.*)\x0d\x0a/;
    return $1;
}

sub parse_cookie {

    my $ipcookie = shift;

    #e.g. "msts=420247818.15629.0000";

	if (length ($ipcookie // '')) {

        if ( $ipcookie =~ /^msts=(\d*)\.(\d*)\./ ) {
            my $iphex = sprintf( "%8X", $1 );
            my $porthex = sprintf( "%4X", $2 );
            $iphex =~ /(..)(..)(..)(..)/sg;
            my $return = $ipcookie . 
              "(" . hex($4) . "." . hex($3) . "." . hex($2) . "." . hex($1);
            $porthex =~ /(..)(..)/sg;
            $porthex = "$2" . "$1";
            $return .= ":" . hex($porthex) . ")";
            return $return;
        } elsif ( $ipcookie =~ /^mstshash=/ ) {
            print $ipcookie;
        } else {
            print '';
        }
    }
}

sub process_pkt {
    my ( $user, $hdr, $pkt ) = @_;

    my $ip_obj  = NetPacket::IP->decode( eth_strip($pkt) );
    my $tcp_obj = NetPacket::TCP->decode( $ip_obj->{data} );

    print( "$ip_obj->{src_ip}" . ":" . "$tcp_obj->{src_port}" . ":" );
    print( "$ip_obj->{dest_ip}" . ":" . "$tcp_obj->{dest_port}" . ":" );

    #print get_cookie( $tcp_obj->{data} ) . "\n";
    print parse_cookie( get_cookie( $tcp_obj->{data} ) ) . "\n";

}

Net::Pcap::loop( $pcap, -1, \&process_pkt, '' );

