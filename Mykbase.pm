package Mykbase;

use base qw( CLI::Framework );

use v5.14;
use DBI;
use lib ("$ENV{'KBASE_ROOT'}/Mykbase/lib");
use General;
use DBSchema;

my $db = "$ENV{'KBASE_ROOT'}/DB/kbase.db";

sub connectdb{
    die "cannot access db on $db" unless -f $db;
    
    my $dbh = DBSchema->connect("dbi:SQLite:$db","","");
   
    return $dbh;
}

sub usage_text {
    # The usage_text() hook in the Application Class is meant to return a
    # usage string describing the whole application.
    my $usage = <<EOF;
$0 [OPTIONS] [ARGUMENTS]

OPTIONS:
--help|-h:	display help

ARGUMENTS (subcommands):
    console     -   run interactively
    cmd-list    -   list available commands
    add	        -   add kbase
    search      -   search kbase
    open        -   open kbase
    last        -   view last added record
    
EOF
}

sub option_spec {
    # The option_spec() hook in the Application class provides the option
    # specification for the whole application.
    [ 'help|h'         => 'display help' ],
}

sub validate_options {
    # The validate_options() hook can be used to ensure that the application
    # options are valid.
    my ($self, $opts) = @_;
    die $self->usage_text unless defined $opts or $opts->{'help'};
    
    # ...nothing to check for this application
}

sub command_map {
    
    # In this *list*, the command names given as keys will be bound to the
    # command classes given as values.  This will be used by CLIF as a hash
    # initializer and the command_map_hashref() method will be provided to
    # return a hash created from this list for convenience.
    
    console     => 'CLI::Framework::Command::Console',
    alias       => 'CLI::Framework::Command::Alias',
    'cmd-list'  => 'CLI::Framework::Command::List',
    add		=> 'Mykbase::Command::Add',
    search	=> 'Mykbase::Command::Search',
    open	=> 'Mykbase::Command::Open',
    last => 'Mykbase::Command::Last'
}

sub command_alias {
    # In this list, the keys are aliases to the command names given as values
    # (the values should be found as "keys" in command_map()).
    sh  => 'console',
    a  => 'add',
    s  => 'search',
    o  => 'open',
    last => 'last',
}

sub init {
    # This initialization is performed once for the application (default
    # behavior).
    my ($self, $opts) = @_;

    my $general = General->new();
    
    #check environment and configuration file
    $general->conf_check();
    
    #set dbschema
    $general->dbschema(connectdb());
    
    #cache the object
    $self->cache->set('general' => $general);
}
1;
