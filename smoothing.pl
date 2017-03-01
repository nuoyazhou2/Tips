#!/usr/bin/perl
use strict;
use warnings;

my ($input_file, $window_size, $window_incr, $output_file)  = @ARGV;
my %chrs;
my %positions;
my %bins;

my %length_chr = (
    chr1=>197195432,
    chr2=>181748087,
    chr3=>159599783,
    chr4=>155630120,
    chr5=>152537259,
    chr6=>149517037,
    chr7=>152524553,
    chr8=>131738871,
    chr9=>124076172,
    chr10=>129993255,
    chr11=>121843856,
    chr12=>121257530,
    chr13=>120284312,
    chr14=>125194864,
    chr15=>103494974,
    chr16=>98319150,
    chr17=>95272651,
    chr18=>90772031,
    chr19=>61342430,
    chrX=>166650296,
    chrY=>15902555,
);

open(IN, "<", $input_file) or die "can't open input file $input_file:$!";
open(OUT, ">", $output_file) or die "can't write to output file $output_file:$!";

while (<IN>) {
    my ($chr, $start, $end, $count) = split;
    unless (defined $chrs{$chr}) {
	$chrs{$chr} = 1;
    }
    $positions{$chr}{$start}{"end"} = $end;
    $positions{$chr}{$start}{"count"} = $count;
    
}

foreach my $storedChr (sort keys %chrs) {
    foreach my $storedPosition (sort {$a <=>$b} keys %{$positions{$storedChr}}) {
	my $startsamm = $storedPosition + ($positions{$storedChr}{$storedPosition}{"end"} - $storedPosition)/2;
	my $int = int($startsamm/$window_size);
	my $start_bin = ($int*$window_size);
	my $diff = $startsamm - $start_bin;
	my $incr = int( ( $window_size - $diff ) / $window_incr ) * $window_incr;
	$start_bin = $start_bin - $incr + $window_size/2;
	
	for (my $bin = $start_bin; $bin < ($start_bin+$window_size); $bin+= $window_incr){
	    unless (($storedChr =~ /M|m/) || ($bin <=0) || (($bin+$window_incr)  >= $length_chr{$storedChr})) {
		$bins{$storedChr}{$bin} += $positions{$storedChr}{$storedPosition}{"count"};
	    }
	}
    }
}
    

foreach my $storedChr (sort keys %bins) {
    foreach my $storedposition ( sort {$a <=> $b} keys %{ $bins{$storedChr} } ) {
	print OUT "$storedChr\t$storedposition\t". ($storedposition+$window_incr-1) . "\t$bins{$storedChr}{$storedposition}\n";  
    }
}


