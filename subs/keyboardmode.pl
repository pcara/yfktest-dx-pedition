use strict;

sub keyboardmode {
		my $ch;

		curs_set(0);
#		addstr($main::wmain, 23, 5, "KEYBOARD MODE. ESC/ALT-K TO RETURN.");
		attron($main::wmain, COLOR_PAIR(6));
		addstr($main::wmain, 23, 0, "  CW-Keyboard mode - ESC: Quit  ");
		refresh($main::wmain);

		while (1) {
			$ch = getch();
			last if ((ord($ch) == 27) || (ord($ch) == 235)
				|| (ord($ch) == 195));
			next unless ($ch =~ /^[a-z0-9\/?=,.+ ]$/);
			print $main::cwsocket "\U$ch";
		} 
		
		attroff($main::wmain, COLOR_PAIR(6));
		addstr($main::wmain, 23, 0, "                                ");
		curs_set(1);
}

return 1;

# Local Variables:
# tab-width:4
# End: **
