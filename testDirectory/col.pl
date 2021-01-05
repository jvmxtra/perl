#!/usr/bin/perl

use warnings;
use strict;

# Extracts columns of text from a file
# Usage: col [-s<n>] col-range1, col-range2, files ...
# where col-rnage is specified as col1-col2 (column 1 through column 2)
# or col1+n, where n is the number of columns.

my $size = 0;
my @files = ();
my $open_new_file = 1;
my $debugging = 0;
my $col = '';
my $code = '';
my $delimiter;
my $offset;
generate_part1();
generate_part2();
generate_part3();
col();
exit 0;

sub generate_part1 {
    $code = 'sub col {my $tmp; ';
    $code .= 'while (1) { my $s = get_next_line(); $col = "";';
    $delimiter = '|';
    #print "start generating-----------------------------------------------\n";
    #print "generate_part1 is $code\n";
    #print "done generating-----------------------------------------------\n";
}
sub generate_part2 {
    my ($col1, $col2);
    for my $arg (@ARGV) {
        if ( ($col1, $col2) = ($arg =~ /^(\d+)-(\d+)/)) {
            $col1--;
            $offset = $col2 - $col1;
            add_range($col1, $offset);
        } elsif ( ($col1, $offset) = ($arg =~ /^(\d+)\+(\d+)/)) {
            $col1--;
            add_range($col1, $offset);
        } elsif ($size = ($arg =~ /-s(\d+)/)) {
            #noop
        } elsif ($arg =~ /^-d/) {
            $debugging = 1;
        } else {
            # must be a file name
            push (@files, $arg);
        }
    }
}
sub generate_part3 {
    $code .= 'print $col, "\n";}}';
    print $code if $debugging; 
    #print "------------------------------- eval -----------------------------\n";
    eval $code;
    #print "------------------------------- done eval -----------------------------\n";
    if ($@) {
        die "Error .......\n $@\n $code \n";
    }
}

sub add_range {
    my ($col1, $numChars) = @_;
    $code .= "\$s .= ' ' x ($col1 + $numChars - length(\$s))";
    $code .= "    if (length(\$s) < ($col1+$numChars));";
    $code .= "\$tmp = substr(\$s, $col1, $numChars);";
    $code .= '$tmp .= " " x (' . $numChars . ' - length($tmp));';
    $code .= "\$col .= '$delimiter' . \$tmp; ";
}

sub get_next_line {
    my $buf;

    NEXTFILE:
        if ($open_new_file) {
            my $file = shift @files || exit 0;
            open F, $file or die "$@\n";
            $open_new_file = 0;
        }

        if ($size) {
            read F, $buf, $size;
        } else {
            $buf = <F>;
        }

        if (! $buf) {
            close F;
            $open_new_file = 1;
            goto NEXTFILE;
        }

        chomp($buf);

        $buf =~ s/^(\t+)/' ' x (8 * lenght($1))/e;

        1 while ($buf =~ s/\t/' ' x (8 - length($`) %8)/e);

        $buf;
}
