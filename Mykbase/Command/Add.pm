package Mykbase::Command::Add;

use base qw( CLI::Framework::Command );
use v5.14;
use lib ("$ENV{'KBASE_ROOT'}/Mykbase/lib");
use Options;

#return usage output
sub usage_text{
	qq{Usage: $0 add --title="using linux" --cat="linux" --tag="linux,oss" --desc="description here"};
}

#print usage if no options specified
sub validate{
    my ($self, $cmd_opts, @args) = @_;

    die $self->usage_text()  . "\n" unless %$cmd_opts;
}

sub option_spec {
    # The option_spec() hook in the Command Class provides the option
    # specification for a particular command.
    [ 'tag=s'   => 'tag name'  ],
    [ 'title=s'   => 'title name'  ],
    [ 'cat=s'   => 'category name'  ],
    [ 'path=s'   => 'file path of kbase'  ],
	 [ 'description=s'	=> 'Description of kbase'],
}

#exit if title or category not specified or empty string
sub check_opts{
	my $opts = shift;
	
	if($opts->{'title'} =~ /^\s+/ or not defined $opts->{'title'}){
		say usage_text();
		die "title is required!\n";
	}
	elsif($opts->{'cat'} =~ /^\s+/ or not defined $opts->{'cat'}){
		say usage_text();
		die "category is required!\n";
	}
}

#create file and edit it using vi
sub add_file{
	my $file = shift;
	
	system qq|touch "$file" && vi "$file"|;
}

sub run{
	my ($self, $opts, @args) = @_;
	check_opts($opts);
	
	my $general = $self->cache->get('general');
	
	#get DBIx schema
	my $dbh = $general->get_dbschema();

	my $options = Options->new(title => "$opts->{'title'}", category => "$opts->{'cat'}");
	my $datetime = $options->get_sqlite_datetime();
	my $path = $options->get_path();
	my $dir = $options->get_category_path();
	
	#check for duplicate title, insert new record if there is no same title
	if($options->is_path_exist){
		die "Duplicate title, change or edit previous title\n";
	}else{
		$general->dir("$dir");
		$general->create_dir();
		add_file($path);
		
		my $record = $dbh->resultset('Kbase')->create(
			{
				created => "$datetime",
				title => "$opts->{'title'}",
				category => "$opts->{'cat'}",
				tag => "$opts->{'tag'}",
				path => "$path",
				description => "$opts->{'description'}"
			}
		);
		
	}

	return;
}

1;

