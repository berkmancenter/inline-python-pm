use strict;
use warnings;

use Inline Config => DIRECTORY => './blib_test';
use Test::More tests => 16;

use Inline Python => <<END;

def is_boolean(value):
    return isinstance(value, bool) and 1 or 0

def is_true(value):
    return value == True

def get_true():
    return True

def get_false():
    return False

def get_hash_with_bools():
    return {'true': True, 'false': False}

def values_are_boolean(hash):
    return isinstance(hash['true'], bool) and isinstance(hash['false'], bool) and 1 or 0

END

ok($Inline::Python::Boolean::true);
ok(! $Inline::Python::Boolean::false);
is($Inline::Python::Boolean::true, 1);
is(! $Inline::Python::Boolean::true, 0);
is($Inline::Python::Boolean::false, 0);
is(! $Inline::Python::Boolean::false, 1);

is(is_boolean($Inline::Python::Boolean::true), 1);
is(is_true($Inline::Python::Boolean::true), 1);

is(is_boolean($Inline::Python::Boolean::false), 1);
is(is_true($Inline::Python::Boolean::false), 0);

ok(get_true()->isa('Inline::Python::Boolean'), 'Got a Boolean object for True');
ok(is_boolean(get_true()),  'True got passed as Boolean through perl space');
ok(is_boolean(get_false()), 'False got passed as Boolean through perl space');

ok(values_are_boolean(get_hash_with_bools()), 'True and False work as dict values');

SKIP: {
    skip 'JSON module required for JSON interop tests', 2
        unless eval { require JSON; };
    is JSON::to_json([get_true()],  {convert_blessed => 1}), '[true]';
    is JSON::to_json([get_false()], {convert_blessed => 1}), '[false]';
}
