package Options;
use Mouse;
use v5.14;
use DateTime::Format::SQLite;
use DateTime;


has 'title' => ( is => 'rw', isa => 'Str');
has 'category' => ( is => 'rw', isa => 'Str');
has 'tag' => ( is => 'rw', isa => 'Str' );
has 'path' => ( is => 'rw', isa => 'Str' );
has 'description' => ( is => 'rw', isa => 'Str' );
has 'id' => ( is => 'rw', isa => 'Int');

#get file path of the kbase
sub get_path(){
    my $self = shift;
    
    my $title = $self->title;
    my $category = $self->category;
    my $path = qq|$ENV{'KBASE_ROOT'}/Files/$category/$title|;
    return $path;
}

#check if path already exists
sub is_path_exist(){
    my $self = shift;
    
    -f $self->get_path() ? return 1 : return 0;
}

#get category directory path of the kbase
sub get_category_path(){
    my $self = shift;
    
    my $category = $self->category;
    my $path = qq|$ENV{'KBASE_ROOT'}/Files/$category|;
    return $path;
}

#get current time
sub get_sqlite_datetime(){
    my $self = shift;
    
    my $datetime = DateTime->now();
	 $datetime =  DateTime::Format::SQLite->format_datetime($datetime);
   
    return $datetime;
}

sub date_output{
    my $self = shift;
    
    my $date = shift;

    use Date::Manip qw(ParseDate UnixDate);

    my @array = split / +/ , $date;

    $date = "$array[2] $array[1] $array[4]";
    my $time = "$array[3]";
    my $datemanip = ParseDate("$date, $time");
    my $datestr = UnixDate($datemanip, "%a %e %b %Y %H:%M:%S");    # as scalar
    return $datestr;

}

sub convert_datetime{
    my $self = shift;
    
    use Time::Local;
    my $date = shift;

    my @array = split / +/ , $date;
    $date = $array[0];
    my $time = $array[1];

    my @splitdate = split '-' , $date;
    my @splittime = split ':', $time;

    my $day = $splitdate[2];
    my $month = $splitdate[1];
    my $year = $splitdate[0];
    
    my $seconds = $splittime[2];
    my $minutes = $splittime[1];
    my $hours = $splittime[0];

    $time = timelocal($seconds,$minutes,$hours,$day,($month-1),$year);
    $date = scalar(localtime($time));

    return $date;
}


#convert datetime from sqlite
sub convert_sqlite_date(){
    my $self = shift;
    
    my $dt = shift;
    $dt = DateTime::Format::SQLite->format_datetime($dt);
    $dt = $self->convert_datetime($dt);
    
    return $dt;
}

1;