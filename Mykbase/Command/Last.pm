package Mykbase::Command::Last;

use base qw( CLI::Framework::Command );
use v5.14;
use lib ("$ENV{'KBASE_ROOT'}/Mykbase/lib");

#return usage output
sub usage_text{
	my $usage = <<EOF;
Usage: $0 last 10   #will print 10 last record
EOF
}

#print usage if no options specified
sub validate{
    my ($self, $cmd_opts, @args) = @_;

    unless($args[0] > 0){
        die $self->usage_text() . "\n";
    }
}

sub run{
    my ($self, $opts, @args) = @_;
    
    my $general = $self->cache->get('general');
	
	#get DBIx schema
	my $dbh = $general->get_dbschema();
    
    use Search;
    my $search = Search->new();
    $search->dbh(\$dbh);
    $search->get_last_record($args[0]);
    
    return;
}

1;