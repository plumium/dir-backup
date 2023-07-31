#!/bin/bash

readonly EXECUTED_DIR=$PWD
readonly BACKUP_DIR=".bk"

create_directories() {
    target="$BACKUP_DIR/$1"
    if [ ! -d $target ]; then
        mkdir -p $target
    fi
}

copy_file() {
    dir_name=$(dirname $1)
    create_directories $dir_name
    cp $1 "$BACKUP_DIR/$dir_name"
}

copy_directory() {
    create_directories $1
    # overwrite directory
    cp -r $1 "$BACKUP_DIR/$(dirname $1)"
}

cd $(dirname $0)
if [ ! -f ".backupfiles" ]; then
    echo ".backupfiles not found"
    return 1
fi

if [ ! -d $BACKUP_DIR ]; then
    mkdir $BACKUP_DIR
fi

shopt -s globstar
for p in $(cat .backupfiles | grep -o '^[^#].*$'); do
    echo "process $p"
    if [ -e $p ]; then
        if [ -f $p ]; then
            copy_file $p
        fi
        if [ -d $p ]; then
            copy_directory $p
        fi
    else
        echo "$p does not exist"
    fi
done

echo "done"
cd $EXECUTED_DIR