use utf8;
package DBSchema::Result::Kbase;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBSchema::Result::Kbase

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<kbase>

=cut

__PACKAGE__->table("kbase");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 created

  data_type: 'date'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'text'
  is_nullable: 1

=head2 tag

  data_type: 'text'
  is_nullable: 1

=head2 path

  data_type: 'text'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "created",
  { data_type => "date", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "text", is_nullable => 1 },
  "tag",
  { data_type => "text", is_nullable => 1 },
  "path",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2012-05-16 23:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E7Yn+COSXiYLSUeumNySzw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
