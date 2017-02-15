#!/usr/bin/env perl

use File::Basename;

for $locus (glob "rs*") {
	print "checking $locus\n";
	for $file (glob "$locus/*[123]_normalized.bedgraph") {
		print "checking $file\n";
		$sample = basename $file =~ /(.*[0-9])_normalized.bedgraph/; 
		!system("sort -k1,1 -k2,2n $file > process/${locus}_${sample}_sorted.bed") or die "cannot sort:$!";
		
		!system("bedtools map -c 4 -null 0 -a /home/mingyangcai/project/captureC/lib/hg19_genome_dpnII_coordinates.bed -b process/${locus}_${sample}_sorted.bed > process/${locus}_${sample}_mapped_to_genome.bed") or die "cannot run bedtools map: $!";
	}
		
	print("paste process/${locus}_cancer1_mapped_to_genome.bed <(cut -f4 process/${locus}_cancer2_mapped_to_genome.bed) <(cut -f4 process/${locus}_cancer3_mapped_to_genome.bed) <(cut -f4 process/${locus}_normal1_mapped_to_genome.bed) <(cut -f4 process/${locus}_normal2_mapped_to_genome.bed) <(cut -f4 process/${locus}_normal3_mapped_to_genome.bed) > ${locus}_cancer_vs_normal.txt") or die "cannot paste:$!";
			
}

=BEGIN
	$prefix = basename $i =~ /(CHKPEI85216060[\d]+)_normalized.bedgraph/;
	print "$prefix\n";
	!system("sort -k1,1 -k2,2n $i > process/${prefix}_sorted.bed") or die "cannot sort:$!";
	!system("bedtools map -c 4 -null 0 -a /home/mingyangcai/project/captureC/lib/mm9_genome_dpnII_coordinates.bed -b process/${prefix}_sorted.bed > process/${prefix}_mapped_to_genome.bed") or die "cannot run bedtools map: $!";
}
	!system("paste process/CHKPEI8521606003_mapped_to_genome.bed <(cut -f4 process/CHKPEI8521606008_mapped_to_genome.bed) <(cut -f4 process/CHKPEI8521606004_mapped_to_genome.bed) <(cut -f4 process/CHKPEI8521606009_mapped_to_genome.bed) > 3849.txt") or die "cannot paste:$!";
	!system("sed -i '1i\chr\tstart\tend\t03\t08\t04\t09' 3849.txt") or die "cannot sed:$!";
