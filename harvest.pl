#!/usr/bin/perl
# harvest.pl
# Download records from OAI-PMH DPs

use warnings;
use strict;
use Net::OAI::Harvester;
use Getopt::Long;

# Command line options
use vars qw( $baseURL $setSpec $schema $dir $from $until $noauto $help %opts);

# Capture options
GetOptions(
	"baseurl=s" => \$baseURL,
	"set=s"		=> \$setSpec,
	"schema=s"	=> \$schema,
	"dir=s"		=> \$dir,
	"from=s"	=> \$from,
	"until=s"	=> \$until,
	"noauto"	=> \$noauto,
	"h"		=> \$help,
);

# Exit with usage display
if ( $help || !$baseURL ) {
   _show_usage();
   exit 1;
}

$dir ||= '.';
$opts{'metadataPrefix'} = $schema	? $schema	: 'oai_dc';
$opts{'set'}		= $setSpec	if $setSpec;
$opts{'from'}		= $from 	if $from;
$opts{'until'}		= $until 	if $until;

# Init harvester
my $harvester = Net::OAI::Harvester->new( baseURL => $baseURL, dumpDir => $dir );

print "Harvesting ... ($opts{'metadataPrefix'})\n";
my $records;
$records = $harvester->listRecords( %opts );
my $finished = 0;

# Automatic flow control
if ( !$noauto ) {
    while ( ! $finished ) {
        my $rToken = $records->resumptionToken();
        if ( $rToken ) { 
	    print "Resuming token($rToken->{'resumptionTokenText'}) ...\n";
            $records = $harvester->listRecords( 
                resumptionToken => $rToken->token()
            );
        } else { 
            $finished = 1;
        }
    }
}

# Error in response
if ( $records->errorCode() ) {
	print "Harvesting failed\n=====================\nCode: " . 
		$records->errorCode() . "\nDescription: " . 
		$records->errorString() . "\n";
}

# The usage statement
sub _show_usage {
	print <<USAGE;

Usage: harvest.pl [options]

Options:
     -baseurl=[URL] 	BaseURL of the OAI-PMH Data Provider
     -dir=[PATH]	Output directory (must exist) (default: CWD)
     -schema=[schema]	Metadata schema (default 'oai_dc')
     -set=[setSpec]	SetSpec (for selective harvesting)
     -from=[Date]	Date-based selective harvesting (YYYY-MM-DD)
     -until=[Date]	Date-based selective harvesting (YYYY-MM-DD)
     -noauto		Disable automatic flow control (resubmission of ResumptionTokens)
     -h			Print this help

USAGE
}
