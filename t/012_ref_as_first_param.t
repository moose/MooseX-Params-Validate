#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

{
    use MooseX::Params::Validate;

    sub foo {
        my ( $x, $y ) = validated_list(
            \@_,
            x => { isa => 'Any' },
            y => { isa => 'Any' },
        );

        return { x => $x, y => $y };
    }

    sub bar {
        my %p = validated_hash(
            \@_,
            x => { isa => 'Any' },
            y => { isa => 'Any' },
        );

        return \%p;
    }

    sub baz {
        my ( $x, $y ) = pos_validated_list(
            \@_,
            { isa => 'Any' },
            { isa => 'Any' },
        );

        return { x => $x, y => $y };
    }
}

is_deeply(
    foo( x => 42, y => 84 ),
    { x => 42, y => 84 },
    'validated_list accepts a plain hash'
);

is_deeply(
    foo( { x => 42, y => 84 } ),
    { x => 42, y => 84 },
    'validated_list accepts a hash reference'
);

is_deeply(
    bar( x => 42, y => 84 ),
    { x => 42, y => 84 },
    'validated_hash accepts a plain hash'
);

is_deeply(
    bar( { x => 42, y => 84 } ),
    { x => 42, y => 84 },
    'validated_hash accepts a hash reference'
);

is_deeply(
    baz( 42, 84 ),
    { x => 42, y => 84 },
    'pos_validated_list accepts a plain array'
);

is_deeply(
    baz( [42, 84] ),
    { x => 42, y => 84 },
    'pos_validated_list accepts a array reference'
);

done_testing();
