use strict;
use warnings;
use Test::More;
use Unicode::Security qw(confusable);

is confusable("s\x{006F}\x{0337}s", "s\x{00F8}s"), 1, 'sos';
is confusable('paypal', "p\x{0430}yp\x{0430}l"), 1, 'paypal';
is confusable('scope', "\x{0455}\x{0441}\x{043E}\x{0440}\x{0435}"), 1, 'scope';
is confusable('same', 'same'), 1, 'identical strings';
is confusable('Paypal', 'paypal'), '', 'different case';

# TODO: single-argument, multi-script confusable detection.
# is confusable("p\x{0430}yp\x{0430}l"), 1, 'paypal';
# is confusable("toys-\x{044F}-us"), '', 'toys-r-us';
# is confusable("1i\x{03BD}\x{0435}"), 1, '1ive';

done_testing;
