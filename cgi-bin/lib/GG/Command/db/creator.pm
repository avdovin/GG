package GG::Command::db::creator;
use Mojo::Base 'Mojolicious::Command';

has description => 'Create tables with default fields (ID, name, created_at, updated_at)';
has usage => 'Ex: db creator data_catalog_items, you can add additional default fields, ex : db creator data_catalog_items rating,active,operator';

sub run {
  my ($self, @args) = @_;

  my $tbl = $args[0] or die 'Define table name';

  my @fields = $args[1] ? split(',', $args[1]) : ();

  die "dbi connect failed" unless $self->app->dbi_connect;

  my $sql =  "CREATE TABLE `$tbl` (
      `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
      `name` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',";

  map { $sql .= sql_str($_)."," } @fields;

  $sql .= "`created_at` DATETIME NULL DEFAULT NULL,
      `updated_at` DATETIME NULL DEFAULT NULL,
      PRIMARY KEY (`ID`)
    )
    COLLATE='utf8_unicode_ci'
    ENGINE=InnoDB
    ;";

  $self->app->dbi->query($sql);

  print "Successfully created table $tbl\n";
}

sub sql_str{
  my $field = shift;

  my $conf = {
    'rating'    => "`rating` SMALLINT(5) UNSIGNED NOT NULL DEFAULT '99'",
    'active'    => "`active` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0'",
    'operator'  => "`operator` VARCHAR(64) NOT NULL DEFAULT ''",
    'text'      => "`text` TEXT NULL",
  };

  return $conf->{$field} ? $conf->{$field} : "";

}

1;

=encoding utf8

=head1 NAME

GG::Command::db::creator - App generator command

=head1 SYNOPSIS

  Usage: APPLICATION db creator

=head1 DESCRIPTION
  Create tables by prefix with default fields (ID, name, created_at, updated_at). Types : list - lst, table - data, doptable - dtbl, keys - keys.
