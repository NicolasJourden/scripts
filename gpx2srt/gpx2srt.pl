#!/usr/bin/perl

#use strict;
#use warnings;
use Date::Parse;
use POSIX qw(strftime);
use Data::Dumper;
use Getopt::Long::Descriptive;
use Geo::Gpx;
use DateTime;
use Math::Trig qw(deg2rad pi great_circle_distance asin acos);

sub FlatEarth {
  my ($lat1, $long1, $lat2, $long2) = @_;
  my $r=6366 * 1000;
  my $a = (pi/2)- deg2rad($lat1);               
  my $b = (pi/2)- deg2rad($lat2);
  my $c = sqrt($a**2 + $b**2 - 2 * $a *$b *cos(deg2rad($long2)-deg2rad($long1)));
  my $dist = $c * $r;
  return $dist;
}

# Params:
my ( $opt, $usage ) = describe_options(
    'gpx_gopro2youtube.pl %o',
    ['input|i=s', 'GPX file.',          { required => 1 } ],
    ['video|v=s', 'Video to correlate GPX with.',         ],
    ['epoch|e=s', 'Video\'s epoch in time.',              ],
    ['debug|d',   'Debug info.'                           ],
    ['offset|o=s','Offset between video and GPX.',        ],
);

# GPX:
open(LOG, $opt->input) or die "Can't open: $!";
my $gpx = Geo::Gpx->new( input => $opt->input, use_datetime => 0 );
close (LOG);

# Open an output file
open my $fh_out, '>', 'v1.srt';

# WP:
my $size = @{$gpx->tracks()->[0]->{'segments'}->[0]->{'points'}};
my $last_wp = undef;
my $next_wp = undef;

# Duration:
my $duration = 0;
my $start = 0;
my $end = 0;
my $counter = 1;

if ($opt->video) {
  my $cmd = "";
  if (!$opt->epoch) {
    $cmd = "exiftool -api largefilesupport=1 ".$opt->video." | grep Create | tail -n1 | sed -e \"s/^Create Date                     : //\"";
    $start = str2time(`$cmd`) + $opt->offset;
  } else {
    $start = $opt->epoch;
  }
  $cmd = "ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 \"".$opt->video."\"";
  $duration = `$cmd`;
  printf("Video duration: %d\n", $duration);
  printf("Video creation: %d\n", $start);
} else {
  my $start_wp = $gpx->tracks()->[0]->{'segments'}->[0]->{'points'}[0];
  my $end_wp = $gpx->tracks()->[0]->{'segments'}->[0]->{'points'}[$size-1];  $duration = $end_wp->{'time'} - $start_wp->{'time'};
  $start = $start_wp->{'time'};
  $duration = $end_wp->{'time'} - $start_wp->{'time'};
  printf("GPX: Start WP: %f;%f - time %d, ele %d\n", $start_wp->{'lat'}, $start_wp->{'lon'}, $start_wp->{'time'}, $start_wp->{'ele'} );
  printf("GPX: End WP: %f;%f - time %d, ele %d\n", $end_wp->{'lat'}, $end_wp->{'lon'}, $end_wp->{'time'}, $end_wp->{'ele'} );
  printf("GPX: Distance: ~ %d meters\n", abs(FlatEarth( $end_wp->{'lat'}, $end_wp->{'lon'}, $start_wp->{'lat'}, $start_wp->{'lon'})) );
  printf("GPX: Duration: %d seconds\n", $duration);
}
$end = $duration + $start;


# The waypoints-method of the GEO::GPX-Object returns an array-ref
my $i = 0;
foreach my $wp ( @{ $gpx->tracks()->[0]->{'segments'}->[0]->{'points'} } ) 
{
  $i++;
  if ($opt->video) {
    # If this is before:
    if ($wp->{'time'} < $start) { next; }
    # And after:
    if ($wp->{'time'} > $end) { close $fh_out; exit; }
  }

  if (defined $last_wp)
  {
    # Percentage to the end:
    $wp->{'str_percent'} = sprintf("%02.2f", ( ($last_wp->{'time'} - $start) * 100 / $duration ) );

    # Climb in percent:
    $distance = abs(FlatEarth( $last_wp->{'lat'}, $last_wp->{'lon'}, $wp->{'lat'}, $wp->{'lon'} ));
    $wp->{'distance_total'} += $distance + $last_wp->{'distance_total'};
    $wp->{'str_distance_total'} += sprintf("%.2f", $wp->{'distance_total'} / 1000);

    # Climb:
    if ($distance > 1.0) {
      $wp->{'str_climb'} = sprintf("%.0f", (($wp->{'ele'} - $last_wp->{'ele'}) * 100) / $distance );
    } else {
      $wp->{'str_climb'} = "0";
    }

    # Elevation:
    $wp->{'str_elevation'} = sprintf("%.2f", $wp->{'ele'});

    # Get indication:
    my $ta = strftime("%H:%M:%S,000",gmtime($last_wp->{'time'} - $start));
    my $tb = strftime("%H:%M:%S,000",gmtime($wp->{'time'} - $start));
    my $e = $wp->{'str_elevation'};
    my $d = $wp->{'str_distance_total'};
    my $s = $wp->{'str_climb'};
    my $p = $wp->{'str_percent'};
    my $t = $wp->{'time'};

    print $fh_out qq{
$counter
$ta --> $tb
C <b>$s%</b> / E $e m / D <i>$d km - $p%</i>
};
    $counter++;
  }

  $last_wp = $wp;
}

close $fh_out;
