#!/usr/bin/env perl
use strict;
use warnings;

use File::Basename;

my $sample;
my $locus;
#$folder = "normalization";
#unless ( -d $folder ) {mkdir $folder};
my %factors = (rs1041449 => {
		cancer1 => 10353,
		cancer2 => 8333,
		cancer3 => 7469,
		normal1 => 3924,
		normal2 => 4044,
		normal3 => 2807,
		},
	       rs10486567 => {
		cancer1 => 12733, 
		cancer2 => 10038,
		cancer3 => 9130,
		normal1 => 3333,
		normal2 => 3293,
		normal3 => 2167,
		},
	       rs11598549 => {
		cancer1 => 18791,
		cancer2 => 15017,
		cancer3 => 13860,
		normal1 => 7428,
		normal2 => 7772,
		normal3 => 5545,
		},
	       rs12769019 => {
		cancer1 => 11148,
		cancer2 => 8767,
		cancer3 => 7878,
		normal1 => 4776,
		normal2 => 4730,
		normal3 => 3270,
		},
	       rs12773833 => {
		cancer1 => 4184,
		cancer2 => 3579,
		cancer3 => 3149,
		normal1 => 4045,
		normal2 => 4048,
		normal3 => 2853,
		},
	       rs1574259 => {
		cancer1 => 2216,
		cancer2 => 1917,
		cancer3 => 1685,
		normal1 => 2143,
		normal2 => 2162,
		normal3 => 1433,
		},
	       rs1741708 => {
		cancer1 => 13763,
		cancer2 => 10626,
		cancer3 => 9839,
		normal1 => 4700,
		normal2 => 5040,
		normal3 => 3990,
		},
	       rs4694176 => {
		cancer1 => 5539,
		cancer2 => 4759,
		cancer3 => 3924,
		normal1 => 2159,
		normal2 => 2106,
		normal3 => 1292,
		},
	       rs4919743 => {
		cancer1 => 11859,
		cancer2 => 9334,
		cancer3 => 8529,
		normal1 => 3568,
		normal2 => 3686,
		normal3 => 2697,
		},
	       rs55958994 => {
		cancer1 => 13862,
		cancer2 => 10787,
		cancer3 => 9613,
		normal1 => 3344,
		normal2 => 3301,
		normal3 => 2353,
		},
	       rs5919428 => {
		cancer1 => 2444,
		cancer2 => 1876,
		cancer3 => 1676,
		normal1 => 3991,
		normal2 => 5297,
		normal3 => 4505,
		},
	       rs61085429 => {
		cancer1 => 5112,
		cancer2 => 4195,
		cancer3 => 3738,
		normal1 => 2151,
		normal2 => 2128,
		normal3 => 1355,
		},
	       rs7094325 => {
		cancer1 => 11559,
		cancer2 => 9402,
		cancer3 => 8282,
		normal1 => 4505,
		normal2 => 4733,
		normal3 => 3420,
		},
	       rs7591218 => {
		cancer1 => 2000,
		cancer2 => 1671,
		cancer3 => 1423,
		normal1 => 1369,
		normal2 => 1321,
		normal3 => 844,
		},
	       rs8134657 => {
		cancer1 => 4794,
		cancer2 => 3913,
		cancer3 => 3371,
		normal1 => 2154,
		normal2 => 1985,
		normal3 => 1336,
		},
	       rs9655205 => {
		cancer1 => 4706,
		cancer2 => 4124,
		cancer3 => 3638,
		normal1 => 1790,
		normal2 => 1828,
		normal3 => 1078,
		},
);

foreach my $key (sort keys %factors) {
	unless ( -d $key ) {mkdir $key};
}

print "normalizing bedgraph files:\n";
for my $i (glob "/home/mingyangcai/project/captureC/Shi/analysis/bedgraph_files/*[123]/*rs*[0-9].bedgraph") {
	print "checking $i\n";
	

	my $basename = basename $i;
	
	if ($basename =~ /^22Rv1_1/) {
		$sample = "cancer1";
	}
	elsif ($basename =~ /^22Rv1_2/) {
		$sample = "cancer2";
	}
	elsif ($basename =~ /^22Rv1_3/) {
		$sample = "cancer3";
	}
	elsif ($basename =~ /^RWPE1-10-4/) {
		$sample = "normal1";
	}
	elsif ($basename =~ /^RWPE1-10-5/) {
		$sample = "normal2";
	}
	elsif ($basename =~ /^RWPE1-10-6/) {
		$sample = "normal3";
	}
	else {
		print "have unrecognizable file name\n";
	}
	
	($locus) = $basename =~ /.*(rs[0-9]+).bedgraph/;
	print "DEBUG: $sample.$locus\n";
	print "DEBUG: $factors{$locus}{$sample}\n";


	!system("awk -v OFS=\"\\t\" '{print \$1,\$2,\$3,\$4/$factors{$locus}{$sample}*100000}' $i > $locus/${sample}_normalized.bedgraph") or die "cannot normalize bedgraph:$!";	
}


print "normalizing bedgraph win files:\n";
for my $i (glob "/home/mingyangcai/project/captureC/Shi/analysis/bedgraph_files/*[123]/*rs*[0-9]_win.bedgraph") {
	print "checking $i\n";
	

	my $basename = basename $i;
	
	if ($basename =~ /^22Rv1_1/) {
		$sample = "cancer1";
	}
	elsif ($basename =~ /^22Rv1_2/) {
		$sample = "cancer2";
	}
	elsif ($basename =~ /^22Rv1_3/) {
		$sample = "cancer3";
	}
	elsif ($basename =~ /^RWPE1-10-4/) {
		$sample = "normal1";
	}
	elsif ($basename =~ /^RWPE1-10-5/) {
		$sample = "normal2";
	}
	elsif ($basename =~ /^RWPE1-10-6/) {
		$sample = "normal3";
	}
	else {
		print "have unrecognizable file name\n";
	}
	
	($locus) = $basename =~ /.*(rs[0-9]+)_win.bedgraph/;
	print "DEBUG: $sample.$locus\n";
	print "DEBUG: $factors{$locus}{$sample}\n";


	!system("awk -v OFS=\"\\t\" '{print \$1,\$2,\$3,\$4/$factors{$locus}{$sample}*100000}' $i > $locus/${sample}_win_normalized.bedgraph") or die "cannot normalize bedgraph:$!";	
}



