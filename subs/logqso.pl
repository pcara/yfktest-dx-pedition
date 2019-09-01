load_subs("gettime.pl");
load_subs("getdate.pl");

sub logqso {
	my %qso = %{$_[0]};
#	my @validentry = @{$_[2]};		# regexes
	my $filename = $_[3];

	my @validentry = @main::validentry;

	if ($qso{'call'} eq 'WRITELOG') {
		return 1;
	}

	# check validity of this QSO
	if (
#			($qso{'call'} =~ /[A-Z0-9][A-Z0-9][A-Z]/) &&			# Not so good
			($qso{'call'} =~ /[A-Z0-9][0-9][A-Z]/) &&			# Better (not "best")
			($qso{'exc1'} =~ /^$validentry[0]$/) &&
			($qso{'exc2'} =~ /^$validentry[1]$/) &&
			($qso{'exc3'} =~ /^$validentry[2]$/) &&
			($qso{'exc4'} =~ /^$validentry[3]$/)
	) {

		# for QSOs NOT coming over the network
		unless (defined($qso{stn})) {
			$qso{stn} = $main::netname;
		}

		${$_[0]}{'nr'}++;

		$qso{'utc'} = &gettime();
		$qso{'date'} = &getdate();
		$qso{'ops'} = $main::ops;

		push @{$_[1]}, { %qso };

		open LOG, ">>$filename";

		my $logline = sprintf(
				"%-4s;%-3s;%-9s;%3s;%-4s;%-8s;%-12s;%-6s;%-6s;%-6s;%-6s;%-6s;%-15s\n",
				$qso{'nr'}, $qso{'band'}, $qso{'freq'}, $qso{'mode'}, $qso{'utc'},
				$qso{'date'}, $qso{'call'}, $qso{'exc1'}, $qso{'exc2'},
				$qso{'exc3'}, $qso{'exc4'}, $qso{stn}, $qso{'ops'});

		print LOG $logline;
		close LOG;

		# Send the QSO over the net...

#		print STDERR "$qso{call} == $main::netname ?\n";
		
		# ON4ACP 190831 format string in next line was one too short 
		# resulting in log messages without operator. Added %-3s; in 
		# second position, like in the sprintf line above.
		$logline = sprintf("%-4s;%-3s;%-9s;%3s;%-4s;%-8s;%-12s;%-6s;%-6s;%-6s;%-6s;%-6s;%-15s\n",
				0, $qso{'band'}, $qso{'freq'}, $qso{'mode'}, $qso{'utc'},
				$qso{'date'}, $qso{'call'}, $qso{'exc1'}, $qso{'exc2'},
				$qso{'exc3'}, $qso{'exc4'}, $qso{stn}, $qso{'ops'});


		if ($qso{stn} eq $main::netname) {
			print $main::netsocket "YFK:".$logline;
		}

#		$invalid = 0;
		return 1;
	}
	elsif ($qso{'call'} eq '') {
		$invalid = 0;
		return 0;
	}	
	else {
		$invalid = 1;
		return 0;
	}

}

# Logging an edited QSO.

sub logeditqso {
		my $success = 0;
		my %qso = %main::qso;		# less typing
		my @validentry = @main::validentry;

		if ($qso{'call'} =~ /^DEL/) {
			$qso{'exc1'} = '';
			$qso{'exc2'} = '';
			$qso{'exc3'} = '';
			$qso{'exc4'} = '';
		}
		else {
			unless (
#					($qso{'call'} =~ /[A-Z0-9][A-Z0-9][A-Z]/) &&		# Not so good
					($qso{'call'} =~ /[A-Z0-9][0-9][A-Z]/) &&		# Better (not "best")
					($qso{'exc1'} =~ /^$validentry[0]$/) &&
					($qso{'exc2'} =~ /^$validentry[1]$/) &&
					($qso{'exc3'} =~ /^$validentry[2]$/) &&
					($qso{'exc4'} =~ /^$validentry[3]$/)
			) {
				attron($main::wmain, COLOR_PAIR(6));
				addstr($main::wmain,23,35, " Invalid! ");
				attroff($main::wmain, COLOR_PAIR(6));
				return 0;
			}
		}


		open LOG, $main::filename;
		my @log = <LOG>;
		close LOG;

		# search for the QSO with the same number as $editnr:

		# The number in the array might be different from the actual number, so
		# we search the actual number. Also the QSO has to be from the same
		# station. XXX

#		my $realeditnr = $main::qsos[$editnr]{'nr'};

		for (my $i=0 ; $i <= $#log; $i++) {
			next while ($i < 17);						# HEADER
			if ($log[$i] =~ /^$qso{'nr'}.+$main::netname\s*$/) {		# for old logs w/o ops
				$log[$i] =  sprintf(
				"%-4s;%-3s;%-9s;%3s;%-4s;%-8s;%-12s;%-6s;%-6s;%-6s;%-6s;%-6s\n",
				$qso{'nr'}, $qso{'band'}, $qso{'freq'}, $qso{'mode'}, $qso{'utc'},
				$qso{'date'}, $qso{'call'}, $qso{'exc1'}, $qso{'exc2'},
				$qso{'exc3'}, $qso{'exc4'}, $qso{stn});
				$success = 1;
				last;
			}
			elsif ($log[$i] =~ /^$qso{'nr'}.+$main::netname\s*;\s*$/) {	# allows blank ops field
				$log[$i] =  sprintf(
				"%-4s;%-3s;%-9s;%3s;%-4s;%-8s;%-12s;%-6s;%-6s;%-6s;%-6s;%-6s;%-15s\n",
				$qso{'nr'}, $qso{'band'}, $qso{'freq'}, $qso{'mode'}, $qso{'utc'},
				$qso{'date'}, $qso{'call'}, $qso{'exc1'}, $qso{'exc2'},
				$qso{'exc3'}, $qso{'exc4'}, $qso{stn}, '');
				$success = 1;
				last;
			}
			elsif ($log[$i] =~ /^$qso{'nr'}.+$main::netname/) {# allows ops to follow and ????/other/further stuff
				$log[$i] =  sprintf(
				"%-4s;%-3s;%-9s;%3s;%-4s;%-8s;%-12s;%-6s;%-6s;%-6s;%-6s;%-6s;%-15s\n",
				$qso{'nr'}, $qso{'band'}, $qso{'freq'}, $qso{'mode'}, $qso{'utc'},
				$qso{'date'}, $qso{'call'}, $qso{'exc1'}, $qso{'exc2'},
				$qso{'exc3'}, $qso{'exc4'}, $qso{stn}, $qso{'ops'});
				$success = 1;
				last;
			}

		}

		if ($success) {
			open LOG, ">$main::filename";
			print LOG @log;
			close LOG;
		}

		return $success;
}







return 1;

# Local Variables:
# tab-width:4
# End: **
