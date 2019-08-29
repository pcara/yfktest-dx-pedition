sub showubalist {
	my $window = $_[0];
	my %qso = %{$_[1]};
	
	my @printlist = map(sprintf("%8s", $_), @{$ubalist{$qso{'band'}}});

	addstr($$window,0,0, " "x378);
	addstr($$window,0,0, "@printlist");
	refresh($$window);
}
return 1;

# Local Variables:
# tab-width:4
# End: **
