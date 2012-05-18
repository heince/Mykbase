package General;
use Mouse;
use v5.14;

has "file" => ( is => 'rw', isa => 'Str');
has "dir" => ( is => 'rw', isa => 'Str');
has "dbschema" => ( is => 'rw');

#check if file already exist
sub is_file_exist(){
    my $self = shift;
    
    -f "$self->file" ? return 1 : return 0;
}

#check if dir already exist
sub is_dir_exist(){
    my $self = shift;
    
    -d "$self->dir" ? return 1 : return 0;
}

#create dir
sub create_dir(){
    my $self = shift;
    
    my $dir = $self->dir;
    
    unless (-d $dir){
        mkdir "$dir";
    }
}

sub get_dbschema(){
    my $self = shift;
    
    return $self->dbschema;
}

1;