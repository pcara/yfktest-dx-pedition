sub rate {
		$window = $_[0];
		@qsos = @{$_[1]};

		$maxqsos = $#qsos;
		$n = 0;
		return if ($maxqsos <= 9);

		if ($maxqsos > 10) {
			$m = $maxqsos - 10;
		}
		else {
			$m = 0;
		}

		$n = &timediff($qsos[$m]{utc}, &gettime());
		if (!$n) { $n = 1; }
		if ($bands ne 'RESTRICTED') { #ON4ACP
		    addstr($$window, 1,0, " Last 10: ".sprintf("%3.1f   ", 600/$n));}
		else {
		    addstr($$window, 0,10, " Last 10: ".sprintf("%3.1f   ", 600/$n));}

		if ($maxqsos >= 59){
			if ($maxqsos > 60) {
				$m = $maxqsos - 60;
			}
			else {
				$m = 0;
			}

			$n = &timediff($qsos[$m]{utc}, &gettime());
			if (!$n) { $n = 1; }
		if ($bands ne 'RESTRICTED') { #ON4ACP
		    addstr($$window, 2,0, " Last 60: ".sprintf("%3.1f   ", 3600/$n));}
		else {
		    addstr($$window, 1,10, " Last 60: ".sprintf("%3.1f   ", 3600/$n));}
		}
		refresh($$window);
}


sub timediff  {
	($t1, $t2) = @_;
	$t1 = substr($t1, 0, 2) * 60 + substr($t1, 2, 2);
	$t2 = substr($t2, 0, 2) * 60 + substr($t2, 2, 2);

	if ($t1 > $t2) {	# it's next day already
		$t2 += 1440;
	}

	return ($t2 - $t1);

}




return 1;

# Local Variables:
# tab-width:4
# End: **
