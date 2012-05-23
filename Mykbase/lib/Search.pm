package Search;
use Mouse;
use v5.14;

use lib ("$ENV{'KBASE_ROOT'}/Mykbase/lib");
use Options;

extends 'Options';
has 'exact' => (is => 'rw');    #is exact word
has 'dbh'   => (is => 'rw');    #DB schema
has 'rs'    => (is => 'rw');    #result set

#get result set by id
sub get_path_byid(){
    my $self = shift;
    
    my $rs = ${$self->dbh}->resultset('Kbase')->search({ id => $self->id });
    $self->rs($rs);
    
    #check result set , return file path
    if($self->rs != 0){
        while(my $kbase = $self->rs->first){
            return $kbase->path;
        }
    }else{
        say "no record found on id " . $self->id;
        return 0;
    }
}

#print the result (id, title, description, creation date)
sub print(){
    my $self = shift;
    
    #get opt and print header
    my $header = shift;
    say "== Search by $header ==\n";
    
    #check result set , print id + title 
    if($self->rs != 0){
        while(my $kbase = $self->rs->next){
            my $dt = $self->convert_sqlite_date($kbase->created);
            say $kbase->id . " || " . $kbase->title . " || " . $kbase->description. " || " . $kbase->category . " || " . $dt;
        }
        say "";
    }else{
        say "no record found\n";
    }
}

#get last record
sub get_last_record{
    my $self = shift;
    
    my $limit = shift;
    
    my $rs = ${$self->dbh}->resultset('Kbase')->search( {}, { rows => $limit , order_by => 'id desc' } );
    $self->rs($rs);
    $self->print("Last $limit records");
}

#global check function
sub check(){
    my $self = shift;
    
    my $opt = shift;
    
    if($self->$opt){
        my $rs;
        if($self->exact){
            $rs = ${$self->dbh}->resultset('Kbase')->search({ $opt => $self->$opt });
        }else{
            $rs = ${$self->dbh}->resultset('Kbase')->search({ $opt => { -like => "%" . $self->$opt . "%" } });
        }
        $self->rs($rs);
		  $self->print($opt);
	}
}

#pass tag to check function
sub check_tag(){
    my $self = shift;
    
    $self->check('tag');
}

#pass description to check function
sub check_description(){
    my $self = shift;
    
    $self->check('description');
}

#pass title to check function
sub check_title(){
    my $self = shift;
    
    $self->check('title');
}

#pass category to check function
sub check_category(){
    my $self = shift;
    
    $self->check('category');
}
1;