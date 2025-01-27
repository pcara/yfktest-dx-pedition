sub showqsonr {
	my $window = $_[0];
	my %qso = %{$_[1]};

	attron($$window, COLOR_PAIR(5));

	if ($main::bands eq 'RESTRICTED') { # no room for big QSO number in other modes
	    my $fnumber = sprintf("%03d", $qso{'nr'});
	    if ($main::hastoilet){
		my $toilets=`toilet -f future $fnumber`;
		addstr($$window, 0,0, "$toilets");
	    }
	    else {
		addstr($$window, 0,0, "You have no toilet");
		addstr($$window, 3,2, "QSO number:");
		addstr($$window, 4,2, "$fnumber");
	    }
	    refresh($$window);
        }
}
return 1;

# Local Variables:
# tab-width:4
# End: **
