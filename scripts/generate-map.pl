#!/usr/bin/env perl
use strict;
use warnings;

use Cwd qw(realpath);
use File::Spec::Functions qw(catfile splitpath updir);

my %MA;

# TODO: fetch the data file on-demand and don't store it.
# http://www.unicode.org/Public/security/latest/confusables.txt

parse_file();
write_file();

exit;


sub parse_file {
    my $file = catfile(
        (splitpath(realpath __FILE__))[0, 1], updir,
        qw(data confusables.txt)
    );
    open my $fh, '<', $file or die "$file: $!";
    while (<$fh>) {
        my ($source, $target) = /^([0-9A-F]+) ;\t((?:[0-9A-F]+ )+);\tMA\t/;
        next unless defined $source and defined $target;
        $target =~ s{([0-9A-F]+) }{ '\x{' . $1 . '}' }eg;
        $MA{ '\x{' . $source . '}' } = $target;
    }
    close $fh;

    die "$file: no confusables found" unless %MA;
}


sub write_file {
    my $file = catfile(
        (splitpath(realpath __FILE__))[0, 1], updir,
        qw(lib Unicode Security Confusables.pm)
    );

    open my $fh, '>', $file or die "$file: $!";
    print $fh "use strict;\nuse warnings;\n%Unicode::Security::MA = (\n";
    for my $source (sort keys %MA) {
        printf $fh qq(    "%s" => "%s",\n), $source, $MA{$source};
    }
    print $fh ");\n\n1;";
    close $fh;
}
