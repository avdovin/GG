package GG::Plugins::Pdf;

use Mojo::Base 'Mojolicious::Plugin';


our $VERSION = '0.01';


sub register {
  my ($self, $app, $args) = @_;

  $args ||= {};

  $app->helper(
    generate_pdf => sub {
      my $self = shift;
      my %params = (content => '', file => '', title => '',);

      my $PDF = PDF->new();
      $PDF->generate_pdf(
        content => $params{content},
        title   => $params{title} || 'PDF',
        %params
      );

    }
  );

}

1;

package PDF;

use HTML::HTMLDoc;
use Encode qw(from_to);
################################################################################

sub new {
  my $class = shift;
  my $self  = {};

  while (my $key = shift) {
    my $value = shift;
    $self->{'config'}->{$key} = $value;
  }

  $self->{'erros'} = [];

  my $htmldoc = new HTML::HTMLDoc();
  $$self{'htmldoc'} = $htmldoc;

  bless($self, $class);

  $self->_init();

  return $self;
}

sub _init {
  my $self = shift;

  # Отключение режима CGI
  $ENV{HTMLDOC_NOCGI} = "yes";

  $$self{'htmldoc'}->set_charset('cp-1251');
  $$self{'htmldoc'}->set_bodycolor('white');
  $self->cpath($ENV{'DOCUMENT_ROOT'}) if ($ENV{'DOCUMENT_ROOT'});

# Установка директории для временных файлов
  $$self{'htmldoc'}->{'config'}->{'tmpdir'} = '/temp';
}

# finaly produces the pdf-output
sub generate_pdf {
  my $self = shift;

  my %params = @_;
  my $text   = $params{'content'};


  Encode::_utf8_on($text);
  $text =~ s/&\#(\d+);/chr($1)/ge;    ## fix html characters after 127
  Encode::_utf8_off($text);
  from_to($text, 'utf8', 'cp-1251');

  $$self{'htmldoc'}->set_html_content($text);

  $$self{'htmldoc'}->title($params{'title'}) if $params{'title'};

  my $pdf = $$self{'htmldoc'}->generate_pdf();
  $pdf->to_file($params{'file'}) if $params{'file'};
  return $pdf->to_string;
}

sub error {
  my $self  = shift;
  my $error = shift;

  if (defined $error) {
    push(@{$self->{'errors'}}, $error);
  }
  else {
    if (wantarray()) {
      return @{$$self{'htmldoc'}->{'errors'}};
    }
    else {
      return $$self{'htmldoc'}->{'errors'}->[0];
    }
  }
}

# sets the charset
sub bodycolor {
  my $self = shift;
  if (@_) {
    $$self{'htmldoc'}->set_bodycolor(shift);
  }
  else {
    return $$self{'htmldoc'}->{'doc_config'}->{'charset'};
  }
}

# set the witdh in px for the background image
sub browserwidth {
  my $self = shift;
  if (@_) {
    $$self{'htmldoc'}->set_browserwidth(shift);
  }
  else {
    return $$self{'htmldoc'}->{'doc_config'}->{'browserwidth'};
  }
}

# sets the default font for the body
# Allowed qw(Arial Courier Helvetica Monospace Sans-Serif Serif Symbol Times)
sub bodyfont {
  my $self = shift;
  if (@_) {
    $$self{'htmldoc'}->set_bodyfont(shift);
  }
  else {
    return $$self{'htmldoc'}->{'doc_config'}->{'bodyfont'};
  }
}

# sets the search path for files in a document
sub cpath {
  my $self = shift;
  if (@_) {
    $$self{'htmldoc'}->path(shift);
  }
  else {
    return $$self{'htmldoc'}->{'doc_config'}->{'path'};
  }
}
1;

1;
