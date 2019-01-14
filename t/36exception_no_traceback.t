use strict;
use warnings;
use Test::More tests => 2;

use Inline Config => DIRECTORY => './blib_test';

use Inline Python => <<END;

import sys
import traceback

def __raise(exception):
    """Helper to raise exceptions from lambda functions."""
    raise exception

# Override traceback.format_exception() so that Inline::Python can't load it
# properly to print out the trace
tb = sys.modules['traceback']
tb.format_exception = lambda etype, value, tb: __raise(Exception('Sorry, not today.'))

def error():
    raise Exception('Error!')

END

eval {
    error();
};
ok(1, 'Survived Python exception');
like($@, qr/Exception:/, 'Exception found');
