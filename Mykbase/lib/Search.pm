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
    
    #check result set , print id + title 
    if($self->rs != 0){
        while(my $kbase = $self->rs->next){
            my $dt = $self->convert_sqlite_date($kbase->created);
            say $kbase->id . " || " . $kbase->title . " || " . $kbase->description. " || " . $kbase->category . " || " . $dt;
        }
    }else{
        say "no record found";
    }
}

#check param , search by title and print the result
sub check_title(){
    my $self = shift;
    
    if($self->title){
        my $rs;
        if($self->exact){
            $rs = ${$self->dbh}->resultset('Kbase')->search({ title => $self->title });
        }else{
            $rs = ${$self->dbh}->resultset('Kbase')->search({ title => { -like => "%" . $self->title . "%" } });
        }
        $self->rs($rs);
		  $self->print();
	}
}

#check param , search by title and print the result
sub check_category(){
    my $self = shift;
    
    if($self->cat){
        my $rs;
        if($self->exact){
            $rs = ${$self->dbh}->resultset('Kbase')->search({ title => $self->title });
        }else{
            $rs = ${$self->dbh}->resultset('Kbase')->search({ title => { -like => "%" . $self->title . "%" } });
        }
        $self->rs($rs);
		  $self->print();
	}
}
1;