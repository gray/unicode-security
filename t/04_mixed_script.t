use strict;
use warnings;
use open ':std', ':encoding(utf-8)';
use Test::More;
use Unicode::Security qw(mixed_script);

my @test = (
    [ "abcdef",            '' ],
    [ "abc-def",           '' ],
    [ "\x{1F4A7}\x{203C}", '' ],
    [ "abc-\x{0BF6}ef",    1 ],
);

for my $test (@test) {
    my ($str, $ret) = @$test;

    is mixed_script($str), $ret, $str;
}

done_testing;
