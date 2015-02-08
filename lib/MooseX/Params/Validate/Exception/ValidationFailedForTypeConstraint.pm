package MooseX::Params::Validate::Exception::ValidationFailedForTypeConstraint;

use strict;
use warnings;

our $VERSION = '0.21';

use Moose;
use Moose::Util::TypeConstraints qw( duck_type );

extends 'Moose::Exception';

has parameter => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has value => (
    is       => 'ro',
    isa      => 'Any',
    required => 1,
);

has type => (
    is       => 'ro',
    isa      => duck_type( [qw( get_message name )] ),
    required => 1
);

sub _build_message {
    my $self = shift;

    return
          $self->parameter
        . ' does not pass the type constraint because: '
        . $self->type()->get_message( $self->value() );
}

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Exception thrown when a type constraint check fails

__END__

=head1 SYNOPSIS

    use MooseX::Params::Validate qw( validated_list );
    use Scalar::Util qw( blessed );
    use Try::Tiny;

    try {
        my @p = validated_list( @_, foo => { isa => 'Str' } );
    }
    catch {
        if (
            blessed $_
            && $_->isa(
                'MooseX::Params::Validate::Exception::ValidationFailedForTypeConstraint'
            )
            ) {
            ...;
        }
    };

=head1 DESCRIPTION

This class provides information about type constraint failures.

=head1 METHODS

This class provides the following methods:

=head2 $e->parameter()

This returns a string describing the parameter, something like C<The 'foo'
parameter> or C<Parameter #1>.

=head2 $e->value()

This is the value that failed the type constraint check.

=head2 $e->type()

This is the type constraint object that did not accept the value.

=head1 STRINGIFICATION

This object stringifies to a reasonable error message.

