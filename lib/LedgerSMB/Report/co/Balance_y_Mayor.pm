
package LedgerSMB::Report::co::Balance_y_Mayor;

=head1 NAME

LedgerSMB::Report::co::Balance_y_Mayor - Colombian Balance/Ledger Rpt

=head1 SYNPOSIS

  my $bmreport = LedgerSMB::Report::co::Balance_y_Mayor->new(%$request);
  $bmreport->run;
  $bmreport->render($request, $format);

=head1 DESCRIPTION

This module provides Balance y Mayor reports for LedgerSMB to Colombian
standards. This report shows total activity over a time period.

=head1 INHERITS

=over

=item LedgerSMB::Report;

=back

=cut

use Moose;
use namespace::autoclean;
use LedgerSMB::MooseTypes;
extends 'LedgerSMB::Report';

my $doctypes = {};

=head1 PROPERTIES

=over

=item columns

Read-only accessor, returns a list of columns.

=over

=item accno

Account Number

=item description

Account name

=item document_type

=item debits

=item credits

=back

=cut

sub columns {
    my ($self) = @_;

    my @COLS = (
    {col_id => 'accno',
       name => $self->Text('Account'),
       type => 'href',
     pwidth => 3,
  href_base => '', },

    {col_id => 'description',
       name => $self->Text('Description'),
       type => 'text',
     pwidth => '12', },

    {col_id => 'starting_balance',
       name => $self->Text('Starting Balance'),
       type => 'text',
      money => 1,
     pwidth => '3', },

    {col_id => 'debits',
       name => $self->Text('Debit'),
       type => 'text',
      money => 1,
     pwidth => '4', },

    {col_id => 'credits',
       name => $self->Text('Credit'),
       type => 'text',
      money => 1,
     pwidth => '4', },
    {col_id => 'ending_balance',
       name => $self->Text('Balance'),
       type => 'text',
      money => 1,
     pwidth => '3', },

    );
    return @COLS;
}


=item filter_template

Returns the template name for the filter.

=cut

sub filter_template {
    return 'Reports/co/bm_filter';
}

=item name

Returns the localized template name

=cut

sub name {
    # Do not translate; it's the colombian name of a localized report
    return 'Balance y Mayor';
}

=item header_lines

Returns the inputs to display on header.

=cut

sub header_lines {
    my ($self) = @_;
    return [{name => 'date_from',
             text => $self->Text('Start Date')},
            {name => 'date_to',
             text =>  $self->Text('End Date')},]
}

=back

=head2 Criteria Properties

Note that in all cases, undef matches everything.

=over

=item date_from (text)

start date for the report

=cut

has 'date_from' => (is => 'rw', coerce => 1, isa => 'LedgerSMB::Moose::Date');

=item date_to

End date for the report

=cut

has 'date_to'  => (is => 'rw', coerce => 1, isa => 'LedgerSMB::Moose::Date');

=back

=head1 METHODS

=over

=item run_report()

Runs the report, and assigns rows to $self->rows.

=cut

sub run_report{
    my ($self,$request) = @_;
    my @rows = $self->call_dbmethod(funcname => 'report__general_balance');
    return $self->rows(\@rows);
}

=back

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2012 The LedgerSMB Core Team

This file is licensed under the GNU General Public License version 2, or at your
option any later version.  A copy of the license should have been included with
your software.

=cut

__PACKAGE__->meta->make_immutable;

1;
