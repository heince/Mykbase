package Mykbase::Command::Open;

use base qw( CLI::Framework::Command );
use v5.14;
use lib ("$ENV{'KBASE_ROOT'}/Mykbase/lib");
use Mykbase::lib::Search;

sub usage_text{
	my $usage = <<EOF;
Usage:  $0 open [kbase id]
EOF
}

sub validate{
    my ($self, $cmd_opts, @args) = @_;

    die $self->usage_text()  . "\n" unless @args;
}

sub option_spec {

}

sub run{
    my ($self, $opts, @args) = @_;
    
    my $general = $self->cache->get('general');
	
    #get DBIx schema
    my $dbh = $general->get_dbschema();
    
    #attribute for object
	 my $obj;
    
    #get rs
	 my $title = $opts->{'title'};
	 $obj = Search->new();
	 $obj->dbh(\$dbh);
    $obj->id($args[0]);
    if(my $path = $obj->get_path_byid()){
        system(qq/vi "$path"/);   
    }
    
    return;
}


1;