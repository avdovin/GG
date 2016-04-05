package GG::Command::db::creator;
use Mojo::Base 'Mojolicious::Command';

has description => 'Create tables with default fields (ID, name, created_at, updated_at)';
has usage => 'Ex: db creator data_catalog_items';

sub run {
  my ($self, @args) = @_;

  my $tbl = $args[0] or die 'Define table name';

  die "dbi connect failed" unless $self->app->dbi_connect;

  $self->app->dbi->query(
    "CREATE TABLE `$tbl` (
      `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
      `name` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',
      `created_at` DATETIME NULL DEFAULT NULL,
      `updated_at` DATETIME NULL DEFAULT NULL,
      PRIMARY KEY (`ID`)
    )
    COLLATE='utf8_unicode_ci'
    ENGINE=InnoDB
    ;"
  );

  print "Successfully created table $tbl\n";
}

1;

=encoding utf8

=head1 NAME

GG::Command::db::creator - App generator command

=head1 SYNOPSIS

  Usage: APPLICATION db creator

=head1 DESCRIPTION
  Create tables by prefix with default fields (ID, name, created_at, updated_at). Types : list - lst, table - data, doptable - dtbl, keys - keys.
