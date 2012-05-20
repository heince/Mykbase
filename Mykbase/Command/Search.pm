package Mykbase::Command::Search;

use base qw( CLI::Framework::Command );
use v5.14;
use lib ("$ENV{'KBASE_ROOT'}/Mykbase");
use Mykbase::lib::Search;

sub usage_text{
	my $usage = <<EOF;
Usage:  $0 search --title="using linux"
        $0 search --cat="linux"
        $0 search --tag="linux,oss"
        $0 search --desc="description here"
        $0 search --title="using linux" --cat="linux"
EOF
}

sub validate{
    my ($self, $cmd_opts, @args) = @_;

    die $self->usage_text()  . "\n" unless %$cmd_opts;
	 }else{
}

sub option_spec {
    # The option_spec() hook in the Command Class provides the option
    # specification for a particular command.
    [ 'tag=s'   => 'tag name'  ],
    [ 'title=s'   => 'title name'  ],
    [ 'cat=s'   => 'category name'  ],
	 [ 'description=s'	=> 'Description of kbase' ],
    [ 'exact' => 'exact match' ],
	 [ 'sort' => 'sort descending'],
}

#check title options
sub check_title{
	my ($title, $exact, $dbh, $obj) = @_;
	
	#set the attributes
	$obj->title($title);
	$obj->exact($exact);
	$obj->dbh($dbh);
	
	$obj->check_title();   
}

#check all supported options
sub check_opts{
    my ($opts, $dbh) = @_;
	 
	 #attribute for object
	 my $obj;
    
	 #store exact opts
	 my $exact = $opts->{'exact'};
	 
    #check title
	 my $title = $opts->{'title'};
	 $obj = Search->new();
	 check_title($title, $exact, $dbh, $obj);    
        
}

sub run{
    my ($self, $opts, @args) = @_;
    
    my $general = $self->cache->get('general');
	
    #get DBIx schema
    my $dbh = $general->get_dbschema();
    
    check_opts($opts,\$dbh);
    
    return;
}


1;