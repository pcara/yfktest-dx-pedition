sub getlongtime {	# ON4ACP 190904 time with seconds for sending to 
			# N1MM+, which 
			# does not get a serial number for QSO
    my @date = gmtime();        # $date[2] has hour, 1 has minutes, 0 has seconds
    if ($date[0] < 10) { $date[0] = "0".$date[0]; }   # Add 0 if neccessary
    if ($date[1] < 10) { $date[1] = "0".$date[1]; }
    if ($date[2] < 10) { $date[2] = "0".$date[2]; }
    return $date[2].$date[1].$date[0];
}

return 1;

# Local Variables:
# tab-width:4
# End: **
