sub readrules {

	my $contest = shift;

	open RULES, find_file("defs/$contest.def");
		@rules = <RULES>;
		chomp(@rules);
	close RULES;

		foreach (@rules) {				# remove comments
			$_ =~ s/[\s\t]+#.+$//g;
		}

		$main::defmult1 =		$rules[1];
		$main::defqsopts =		$rules[2];
		$main::defmult2 = 		$rules[3];
		$main::entryfields = 	$rules[4];
		$main::exc1len =	 	$rules[5];
		$main::exc2len =	 	$rules[6];
		$main::exc3len =	 	$rules[7];
		$main::exc4len =	 	$rules[8];

		@main::validchars = @rules[9, 11, 13, 15];
		@main::validentry = @rules[10, 12, 14, 16];
		
		$main::cabrilloline =	$rules[17];
		$main::cabrillovalues=	$rules[18];
		$main::cabrilloname=	$rules[19];
		
		$main::fixexchange	=	$rules[20];
		$main::fixexchangename = $rules[21];

		@main::cwmessages = @rules[22..28] unless $#main::cwmessages;

	#
	# Everything beyond here should be tagged with one of:
	#   BEGIN (SCORE|MULT1|MULT2|BONUSLIST)
	# And each section is stored as a code reference which is evaled later
	# to help calculate scores.  Right now, just remember the lines.

	if ($#rules > 28) {
		my $deftype = "";
		for (my $i = 29; $i <= $#rules; $i++) {
			if ($rules[$i] =~ /^\s*BEGIN\s+(.*)/) {
				$deftype = $1;
				open(WW,">>log");
				print WW "reading $deftype\n";
				close(WW);
			} else {
				$main::coderefs{$contest}{$deftype} .= $rules[$i];
			}
		}
	}
if ($contest eq 'UBA-FD') {# ON4ACP make list of participating stations
    	if (exists($main::coderefs{$contest}{'BONUSLIST'})) {
		# eval the code, which should:
		# define the array @ubaparticipants
#		eval $main::coderefs{$main::contest}{'BONUSLIST'} or die $@;
		our @ubaparticipantslist = split(/,/,$main::coderefs{$main::contest}{'BONUSLIST'});
		our %ubalist = (
		    "40" => [],
		    "80" => [],
		    "160" => []);
		foreach my $onstation ( @ubaparticipantslist ) {
		    foreach $b (keys %ubalist) {
			push(@{$ubalist{$b}},$onstation);
		    }
		}
	}
}
}

# ON4ACP quick index finder for arrays
sub indexArray(@)
{        
         1 while $_[0] ne pop;
          $#_;
}

return 1;

# Local Variables:
# tab-width:4
# End: **
