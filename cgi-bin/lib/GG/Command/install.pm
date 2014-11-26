package GG::Command::install;

use Mojo::Base 'Mojolicious::Command';
use Mojo::Util 'class_to_path';

use File::Spec;
use Getopt::Long qw(GetOptions :config no_ignore_case no_auto_abbrev);   # Match Mojo's commands

our $VERSION = '0.01';
our $PROD = 0; # mode of script - set 1 when production
has description => "GG CMS installer\n";
has usage => <<USAGE;
usage $0 install OPTIONS LIST

WARNINGS
- You have to import gg9.sql BEFORE run this installer
- Your config file should not have unused modules in plugins array

OPTIONS
-i|--install      List of modules to install
-r|--remove       List of modeles to remove (in next versons)

LIST - it's an array of site modules
Example
$0 install -i catalog,faq,images
This command means that you site would have catalog, faq, and gallery. And would not have other modules like news, subscribe etc

MODULES
Images      - Tables: images_gallery, keys_images
            - Controller: Images.pm
            - Templates: '/Images'
            - Plugins: ---  
            - Other files and folders: '/images'
Catalog     - Tables: data_catalog_categorys, data_catalog_brands, data_catalog_categorys, data_catalog_items, data_catalog_orders, dtbl_catalog_items_images, lst_catalog_list, keys_catalog
            - Controller: Catalog.pm
            - Templates: 'Catalog'   
            - Plugins: 'Catalog.pm'  
            - Other files and folders: '/js/controllers/catalog.js','/js/controllers/catalog/*'
FAQ         - Tables: data_faq, keys_faq
            - Controller: Faq.pm
            - Templates: 'Faq'   
            - Plugins: ---
            - Other files and folders: ---
Subscribe   - Tables: data_subscribe, data_subscribe_groups, data_subscribe_stat, data_subscribe_users, keys_subscribe
            - Controller: Subscribe.pm
            - Templates: 'Subscribe'   
            - Plugins: ---
            - Other files and folders: ---
Banners     - Tables: data_banner, data_banner_advert_block, data_banner_advert_users,keys_banners
            - Controller: ---
            - Templates: 'Banners'   
            - Plugins: 'Banners.pm'
            - Other files and folders: '/image/bb'
USAGE

sub run
{
    my ($self, @argv) = @_;

    my $str_install;
    GetOptions(
            'i|install=s' => \$str_install,
        );
    return unless $str_install;
    # if ok
    $self->app->dbi_connect;
    my @to_install;
    
    foreach (split(',',$str_install)){
        push @to_install,lc($_);
    };
    install($self,@to_install);

    print "Script execution finished\n";
}

sub install{
    my $self = shift;
    my @to_install = shift;
    my @delete_list = ();
    my $conf = _config();
    foreach (keys %$conf){
        delete_module($self,$_) unless $_ ~~ @to_install;
    }
}
sub delete_module{
    my $self = shift;
    my $module_name = shift;
    my $promt = _promptUser("Module ".uc($module_name)." is ready to delete (y/n)",'y');
    if ($promt eq 'y' || !$promt){
        _log("Deleting $module_name",1);
        my $module_config = _config($module_name);
        # dropping tables
        _log("Dropping tables",2);
        foreach (@{$module_config->{table}}){
            _delete_table($self,$_);
        }
    }

}
sub _delete_table{
    my $self = shift;
    my $tbl_name = shift;

    if ($self->app->dbi->query("show tables like '$tbl_name'")->list){
        _log("Dropping table $tbl_name",3);
        $self->app->dbi->query("DROP TABLE `$tbl_name`") if $PROD;
    }else{
        _log("No table with name $tbl_name",3);
    }
}
sub _delete_file{

}
sub _config{
    my $module_name = shift || '';
    my %CONFIG = (
        images => {
            'table'                 => ['images_gallery', 'keys_images'],
            'controller'            => 'images.pm',
            'templates_folder'      => '/Images',
            'other_static_folders'  => '/images',
        },
        catalog => {
            'table'                 => ['data_catalog_categorys', 'data_catalog_brands', 'data_catalog_categorys', 'data_catalog_items', 'data_catalog_orders', 'dtbl_catalog_items_images', 'lst_catalog_list', 'keys_catalog'],
            'controller'            => 'Catalog.pm',
            'templates_folder'      => '/Catalog',
            'plugin'                => 'Catalog.pm',
            'other_static_files'    => '/js/controllers/catalog.js',
            'other_static_folders'  => '/js/controllers/catalog',
        },
        faq => {
            'table'                 => ['data_faq', 'keys_faq'],
            'controller'            => 'Faq.pm',
            'templates_folder'      => '/Faq',
        },
        subscribe => {
            'table'                 => ['data_subscribe', 'data_subscribe_groups', 'data_subscribe_stat', 'data_subscribe_users', 'keys_subscribe'],
            'controller'            => 'Subscribe.pm',
            'templates_folder'      => '/Subscribe',
        },
        banners => {
            'table'                 => ['data_banner', 'data_banner_advert_block', 'data_banner_advert_users', 'keys_banners'],
            'templates_folder'      => '/Banners',
            'plugin'                => 'Banners.pm',
            'other_static_folders'  => '/image/bb',
        },
    );
    return $CONFIG{$module_name} if $module_name;
    return \%CONFIG;
}
sub _promptUser {


   my ($promptString,$defaultValue) = @_;


   if ($defaultValue) {
      print $promptString, "[", $defaultValue, "]: ";
   } else {
      print $promptString, ": ";
   }

   $| = 1;               # force a flush after our print
   $_ = <STDIN>;         # get the input from STDIN (presumably the keyboard)

   chomp;
   if ("$defaultValue") {
      return $_ ? $_ : $defaultValue;    # return $_ if it has a value
   } else {
      return $_;
   }
}
sub _log{
    my $str = shift;
    my $tabs = shift;
    say "\t"x$tabs.$str;
}

1;
