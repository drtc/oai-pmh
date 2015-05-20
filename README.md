# OAI-PMH
Scripts for OAI-PMH (http://www.openarchives.org/)

## Requirements:

- Perl 5.x
- Net::OAI::Harvester (http://search.cpan.org/perldoc?Net::OAI::Harvester)

## Usage: 

     harvest.pl [options]

## Options:
     -baseurl=[URL] 	BaseURL of the OAI-PMH Data Provider
     -dir=[PATH]	Output directory (must exist) (default: CWD)
     -schema=[schema]	Metadata schema (default 'oai_dc')
     -set=[setSpec]	SetSpec (for selective harvesting)
     -from=[Date]	Date-based selective harvesting (YYYY-MM-DD)
     -until=[Date]	Date-based selective harvesting (YYYY-MM-DD)
     -noauto		Disable automatic flow control (resubmission of ResumptionTokens)
     -h			Print this help
     
