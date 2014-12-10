package GG::Command::install;

use Mojo::Base 'Mojolicious::Command';
use Mojo::Util 'class_to_path';

use File::Spec;
use File::Path;
use Getopt::Long qw(GetOptions :config no_ignore_case no_auto_abbrev);   # Match Mojo's commands

our $VERSION = '0.01';
our $PROD = 0; # mode of script - set 1 when production
has description => "GG CMS installer\n";
has usage => <<USAGE;
usage $0 install OPTIONS LIST

WARNINGS
- You have to import gg9.sql BEFORE run this installer
- Your config file should not have unused plugins in plugins array

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
    unless ($str_install){
        print "No arguments\n";
        return;
    };
    # if ok
    $self->app->dbi_connect;
    my @to_install;
    
    foreach (split(',',$str_install)){
        push @to_install,lc($_);
    };

    install($self,\@to_install);
    # removing garbadge, cleaning tables etc..
    _log("Removing garbadge",1);
    preparation($self);
    print "Script execution finished\n";
}

sub install{
    my $self = shift;
    my $to_install = shift;
    my @delete_list = ();
    my $conf = _config();
    foreach (keys %$conf){
        delete_module($self,$_) unless $_ ~~ @$to_install;
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
        if (scalar (@{$module_config->{table}})){
            _log("Dropping tables",2);
            foreach (@{$module_config->{table}}){
                _delete_table($self,$_);
            }
        }
        # removing controller
        if ($module_config->{controller}){
            _log("Removing controller",2);
            _delete_controller($module_config->{controller});
        }

        # removing template folder
        if ($module_config->{controller}){
            _log("Removing templates",2);
            _delete_templates($module_config->{templates_folder});
        }
        # removing plugin
        if ($module_config->{plugin}){
            _log("Removing plugin",2);
            _delete_plugin($module_config->{plugin});
        }
        # removing static folders
        if ($module_config->{other_static_folders} && scalar @{$module_config->{other_static_folders}}){
            _log("Removing static folders",2);
            foreach (@{$module_config->{other_static_folders}}){
                _delete_static_folder($self,$_);
            }
        }
        # removing static files
        if ($module_config->{other_static_files} && scalar @{$module_config->{other_static_files}}){
            _log("Removing static files",2);
            foreach (@{$module_config->{other_static_files}}){
                $self->_delete_static_file($self,$_);
            }
        }
    }
 }

sub preparation{
    my $self = shift;
    # cleaning tables
    foreach (qw(anonymous_session data_subscribe_stat dtbl_banner_stat dtbl_subscribe_stat data_users sys_datalogs sys_filemanager_cache dtbl_search_results sys_history sys_users_session sys_mysql_error sys_lkeys_log)){
        _truncate_table($self,$_);
    }
    # removing userfiles
    $self->_delete_static_folder('/userfiles');
}

sub _truncate_table{
    my $self = shift;
    my $tbl_name = shift;
    if ($self->app->dbi->query("show tables like '$tbl_name'")->list){
        _log("Truncating table $tbl_name",3);
        $self->app->dbi->query("TRUNCATE TABLE `$tbl_name`") if $PROD;
    }else{
        _log("SKIP: No table with name $tbl_name",3);
    }
}
sub _delete_static_file{
    my $self = shift;
    my $file = shift;
    return unless $file;
    my $filepath = $self->static_path."/$file";
    if (-e $filepath){
        _log("Removing static file $filepath",3);
        _delete_file($filepath);
    }else{
        _log("SKIP: No static file $file",3);
    }
}
sub _delete_static_folder{
    my $self = shift;
    my $folder = shift;
    return unless $folder;
    my $folder_path = $self->app->static_path."/$folder";

    if (-e $folder_path){
        _log("Removing static folder $folder_path",3);
        _delete_folder($folder_path);
    }else{
        _log("SKIP: No static folder $folder_path",3);
    }
}
sub _delete_table{
    my $self = shift;
    my $tbl_name = shift;

    if ($self->app->dbi->query("show tables like '$tbl_name'")->list){
        _log("Dropping table $tbl_name",3);
        $self->app->dbi->query("DROP TABLE `$tbl_name`") if $PROD;
    }else{
        _log("SKIP: No table with name $tbl_name",3);
    }
}

sub _delete_controller{
    my $controller = shift;
    return unless $controller;
    my $controller_path = $ENV{MOJO_HOME}."/lib/GG/Content/".$controller;
    if (-e $controller_path){
        _log("Removing controller file $controller_path",3);
        _delete_file($controller_path);
    }else{
        _log("SKIP: No file $controller",3);
    }
}

sub _delete_templates{
    my $templates = shift;
    return unless $templates;
    my $template_path = $ENV{MOJO_HOME}."templates/".$templates;
    if (-e $template_path){
        _log("Removing template folder $template_path",3);
        _delete_folder($template_path);
    }else{
        _log("SKIP: No template folder $template_path",3);
    }
}

sub _delete_plugin{
    my $plugin = shift;
    return unless $plugin;
    my $plugin_path = $ENV{MOJO_HOME}."/lib/GG/Plugins/".$plugin;
    if (-e $plugin_path){
        _log("Removing plugin file $plugin_path",3);
        _delete_file($plugin_path);
    }else{
        _log("SKIP: No plugin file $plugin_path",3);
    }
}
sub _delete_folder{
    my $folder = shift;
    return unless $folder;
    system("rm -rf $folder") if $PROD;
}

sub _delete_file{
    my $file = shift;
    return unless $file;
    unlink $file if $PROD;
}

# config subroutine
sub _config{
    my $module_name = shift || '';
    my %CONFIG = (
        images => {
            'table'                 => ['images_gallery', 'keys_images'],
            'controller'            => 'images.pm',
            'templates_folder'      => '/Images',
            'other_static_folders'  => ['/images'],
        },
        catalog => {
            'table'                 => ['data_catalog_categorys', 'data_catalog_brands', 'data_catalog_categorys', 'data_catalog_items', 'data_catalog_orders', 'dtbl_catalog_items_images', 'lst_catalog_list', 'keys_catalog'],
            'controller'            => 'Catalog.pm',
            'templates_folder'      => '/Catalog',
            'plugin'                => 'Catalog.pm',
            'other_static_files'    => ['/js/controllers/catalog.js'],
            'other_static_folders'  => ['/js/controllers/catalog'],
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
            'other_static_folders'  => ['/image/bb'],
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
