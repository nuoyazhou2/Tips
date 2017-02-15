#!usr/bin/env perl

use File::Basename;
use Statistics::TTest;
use strict;
use warnings;

#=begin GHOSTCODE
#=end GHOSTCODE
#=cut

my $ttest = new Statistics::TTest;
$ttest->set_significance(95);

for my $file (glob "rs*_cancer_vs_normal.txt") {
	print "checking $file\n";
	open IN, "<", "$file" or die "cannot open input file:$!";
	open OUT, ">", "ttest/ttest_$file" or die "cannot open output file:$!";
	open OUT1, ">", "ttest/ttest_signif_$file" or die "cannot open output file:$!";
	open OUTC, ">", "ttest/ttest_signif_cancer_$file" or die "cannot open output file:$!";
	open OUTN, ">", "ttest/ttest_signif_normal_$file" or die "cannot open output file:$!";
	#my $header = <IN>;

	while(<IN>) {
		my @array = split;
		if ($array[3]+$array[4]+$array[5]+$array[6]+$array[7]+$array[8] == 0) {
			next;
		}
		my @data1 = ($array[3], $array[4], $array[5]);
		my @data2 = ($array[6], $array[7], $array[8]);
		#print "@data1\t@data2\n";
		$ttest->load_data(\@data1,\@data2);
		my $prob = $ttest->{t_prob};
		#my $test = $ttest->null_hypothesis();
		print OUT join("\t", @array), "\t$prob\n";
		if ($prob <= 0.05) {
			print OUT1 join("\t", @array), "\t$prob\n";
			if (($array[3]+$array[4]+$array[5]) > ($array[6]+$array[7]+$array[8])) {
				print OUTC join("\t", @array), "\t$prob\n";
			}
			elsif (($array[3]+$array[4]+$array[5]) < ($array[6]+$array[7]+$array[8])) {
				print OUTN join("\t", @array), "\t$prob\n";
			}
			else {
				print "Error";
			}
		}
	}
}
