# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..4\n"; }
END {print "not ok 1\n" unless $loaded;}
use End;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my $i = 1;
{  my $foo = end {$i ++};
   $i += 2;
   last;
   $i += 2;
}
print $i == 4 ? "ok 2\n" : "not ok 2\n";

my $sum = 0;
foreach my $i (1 .. 9) {
    my $foo = end {$sum += $i};
    next;
}
print $sum == 45 ? "ok 3\n" : "not ok 3\n";

$sum = 0;
foreach my $i (1 .. 9) {
    my $foo = end {$sum += $i};
    $foo->clear;
    next;
}
print $sum == 0 ? "ok 4\n" : "not ok 4\n";
