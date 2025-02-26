
package LedgerSMB::Report::co::Caja_Diaria;

=head1 NAME

LedgerSMB::Report::co::Caja_Diaria - Caja Diaria Reports (Colombia)

=head1 SYNPOSIS

  my $cdreport = LedgerSMB::Report::co::Caja_Diaria->new(%$request);
  $cdreport->run;
  $cdreport->render($request, $format);

=head1 DESCRIPTION

This module provides Caja Diaria eports for LedgerSMB to Colombian standards.
These reports provide an overview of cash activity to a set of accounts for a
specific period.

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
    return [
    {col_id => 'accno',
       name => $self->Text('Account'),
       type => 'href',
     pwidth => 3,
  href_base => '', },

    {col_id => 'description',
       name => $self->Text('Description'),
       type => 'text',
     pwidth => '12', },

    {col_id => 'document_type',
       name => $self->Text('Document'),
       type => 'text',
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
    ];
}


=item filter_template

Returns the template name for the filter.

=cut

sub filter_template {
    return 'Reports/co/cj_filter';
}

=item name

Returns the localized template name

=cut

sub name {
    return 'Caja Diaria';
}

=item header_lines

Returns the inputs to display on header.

=cut

sub header_lines {
    my ($self) = @_;
    return [{name => 'date_from',
             text => $self->Text('Start Date')},
            {name => 'date_to',
             text => $self->Text('End Date')},
            {name => 'accno',
             text => $self->Text('Account Number Start')},
            {name => 'reference',
             text => $self->Text('Account Number End')},]
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


=item from_accno

=cut

has 'from_accno' => (is => 'rw', isa => 'Maybe[Str]');

=item to_accno


=cut

has 'to_accno' => (is => 'rw', isa => 'Maybe[Str]');

=back

=head1 METHODS

=over

=item run_report()

Runs the report, and assigns rows to $self->rows.

=cut

sub run_report{
    my ($self,$request) = @_;
    my @rows = $self->call_dbmethod(funcname => 'report__cash_summary');
    for my $ref(@rows){
        $ref->{document_type} = $doctypes->{$ref->{document_type}}
                if $doctypes->{$ref->{document_type}};
    }
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
