db=$KBASE_ROOT/Mykbase/DB/kbase.db
createdb="create table kbase(ID INTEGER PRIMARY KEY, CREATED DATE, TITLE TEXT, CATEGORY TEXT, TAG TEXT, PATH TEXT, DESCRIPTION TEXT);"

if [ -f $db ]; then
	echo "db exists"
	exit 1
fi

sqlite3 $db "$createdb"
