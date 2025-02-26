
package LedgerSMB::Auth::DB;

=head1 NAME

LedgerSMB::Auth::DB - Standard Authentication DB module.

=head1 DESCRIPTION

This is the standard DB-based module for authentication.  Uses HTTP basic
authentication.

=head1 METHODS

=over

=cut

use strict;
use warnings;
use Carp;

use MIME::Base64;
use Log::Any;
use LedgerSMB::Sysconfig;
use Moose;
use namespace::autoclean;

my $logger = Log::Any->get_logger(category => 'LedgerSMB::Auth');


has 'env' => (is => 'ro', required => 1, isa => 'HashRef');

has 'domain' => (is => 'ro', required => 0, isa => 'Maybe[Str]');

has 'credentials' => (is => 'ro', required => 0, lazy => 1,
                      builder => '_build_credentials', isa => 'HashRef');

sub _build_credentials {
    my ($self) = @_;
    my $auth = $self->env->{HTTP_AUTHORIZATION};

    return {} unless defined $auth;

    # use a builder, because the response will be the same, no matter how
    # often we call upon the creds

    die "Authorization header for basic auth expected, but not found ($auth)"
        unless $auth =~ s/^Basic\s+//i;

    $auth = MIME::Base64::decode($auth);
    my %rv;
    @rv{('login', 'password')} = split(/:/, $auth, 2);

    my $username_case = LedgerSMB::Sysconfig::force_username_case;
    if ($username_case) {
        if (lc($username_case) eq 'lower') {
            $rv{login} = lc($rv{login});
        }
        elsif (lc($username_case) eq 'upper') {
            $rv{login} = uc($rv{login});
        }
        else {
            die "Unknown username casing algorithm $username_case; expected 'lower' or 'upper'"
        }
    }

    return \%rv;
}

=item get_credentials([company])

Gets credentials from the 'HTTP_AUTHORIZATION' environment variable which must
be passed in as per the standards of HTTP basic authentication.

Returns a hashref with the keys of login and password.

Note that the object needs to cache the domain and company values supplied
on the first invocation. Further invocations to this method may return a
cached response from the first invocation.

=cut

sub get_credentials {
    my ($self, $company) = @_;
    # We ignore domain and company, but other auth providers may use it

    return $self->credentials;
}

=back

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2006-2017 The LedgerSMB Core Team

This file is licensed under the GNU General Public License version 2, or at your
option any later version.  A copy of the license should have been included with
your software.

=cut

__PACKAGE__->meta->make_immutable;

1;
