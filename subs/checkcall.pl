# Check call

sub checkcall {
	my $window = $_[0];
	my @qsos = @{$_[1]};
	my $call = $_[2];

	my $ypos=1;

	if (length($call) < 2) { return 1; };

	curs_set(0);
	attron($$window, COLOR_PAIR(4));
	addstr($$window, 0, 0, ' 'x999);
	attron($$window, A_BOLD);
	addstr($$window, 0, 14, 'Check Call');
	attroff($$window, A_BOLD);
	refresh($$window);


	foreach my $i (0 .. $#qsos) {
		
		if ($qsos[$i]{'call'} =~ /^DEL/) { next; }

		if ($qsos[$i]{'call'} =~ /^$call/) {

			my $band = $qsos[$i]{'band'};

			if ($main::contest ne 'DXPED') {
				if ($band == 160) { $ypos = 1; }
				elsif ($band == 80) { $ypos = 2; }
				elsif ($band == 40) { $ypos = 3; }
				elsif ($band == 20) { $ypos = 4; }
				elsif ($band == 15) { $ypos = 5; }
				elsif ($band == 10) { $ypos = 6; }
			}
			else {	# DXPED
				if ($band == 160) { $ypos = 1; }
				elsif ($band == 80) { $ypos = 2; }
				elsif ($band == 40) { $ypos = 3; }
				elsif ($band == 60) { $ypos = 4; }
				elsif ($band == 30) { $ypos = 5; }
				elsif ($band == 20) { $ypos = 6; }
				elsif ($band == 17) { $ypos = 7; }
				elsif ($band == 15) { $ypos = 8; }
				elsif ($band == 12) { $ypos = 9; }
				elsif ($band == 10) { $ypos = 10; }
				elsif ($band == 6) { $ypos = 11; }
				elsif ($band == 2) { $ypos = 12; }  # .. 
			}
			addstr($$window, $ypos, 0, ' ' x 30 );
			if ($truerst) {# ON4ACP
			    addstr($$window, $ypos, 0, sprintf("%-4s %3s %s %-10s %2s %4s",
						($i+1), $qsos[$i]{'band'}, $qsos[$i]{'utc'},
							   $qsos[$i]{'call'}, $qsos[$i]{'exc3'}, $qsos[$i]{'exc1'}));}
			else	{addstr($$window, $ypos, 0, sprintf("%-4s %3s %s %-10s %-5s %s",
						($i+1), $qsos[$i]{'band'}, $qsos[$i]{'utc'},
						$qsos[$i]{'call'}, $qsos[$i]{'exc1'}, $qsos[$i]{'exc2'}));
		}
			}

	}
	refresh($$window);
}


return 1;

# Local Variables:
# tab-width:4
# End: **
