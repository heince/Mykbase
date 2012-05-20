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

	 if(@args){
		$$cmd_opts{'title'} = $args[0];
		$$cmd_opts{'description'} = $args[0];
	 }else{
		die $self->usage_text()  . "\n" unless %$cmd_opts;
	 }
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

#check tag options
sub check_tag{
	my ($tag, $exact, $dbh, $obj) = @_;
	
	#set the attributes
	$obj->tag($tag);
	$obj->exact($exact);
	$obj->dbh($dbh);
	
	$obj->check_tag();   
}

#check description options
sub check_description{
	my ($description, $exact, $dbh, $obj) = @_;
	
	#set the attributes
	$obj->description($description);
	$obj->exact($exact);
	$obj->dbh($dbh);
	
	$obj->check_description();   
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

#check category option
sub check_category{
	my ($category, $exact, $dbh, $obj) = @_;
	
	#set the attributes
	$obj->category($category);
	$obj->exact($exact);
	$obj->dbh($dbh);
	
	$obj->check_category(); 
}

#check all supported options
sub check_opts{
    my ($opts, $dbh) = @_;
	 
	 #attribute for object
	 my $obj;
	 $obj = Search->new();
    
	 #store exact opts
	 my $exact = $opts->{'exact'};
	 
    #check title
	 my $title = $opts->{'title'};
	 check_title($title, $exact, $dbh, $obj) if $title;
	 
	 #check category
	 my $category = $opts->{'cat'};
	 check_category($category, $exact, $dbh, $obj) if $category;
	 
	 #check description
	 my $description = $opts->{'description'};
	 check_description($description, $exact, $dbh, $obj) if $description;
	 
	 #check tag
	 my $tag = $opts->{'tag'};
	 check_tag($tag, $exact, $dbh, $obj) if $tag;
        
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