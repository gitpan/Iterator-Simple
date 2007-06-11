use Test::More qw(no_plan);

use strict;
use warnings;

use Iterator::Simple qw(:all);

my $itr;

{
	$_ = 'DUMMY';

	$itr = iter [1 .. 20];
	$itr = imap { $_ + 2 } igrep { $_ % 5 } $itr;
	$itr = ifilter $itr, sub {
		if($_ % 5 == 0) {
			return iter([1 .. $_]); #inflate
		}
		elsif($_ % 3 == 0) {
			return; #skip
		}
		else {
			return $_;
		}
	};

	$itr = ichain $itr, ['foo', 'bar', 'baz'];
	$itr = ienumerate($itr);

	$itr = islice($itr, 3, 20, 2);

	my(@res, $rv);
	while(defined($rv = $itr->())){
		push @res, $rv;
	}

	is($_, 'DUMMY', 'preserve $_ value');
}

