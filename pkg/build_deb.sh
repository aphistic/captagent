#!/bin/bash

PKG_DIR=$(cd $(dirname $0) && pwd)
BUILD_DIR=$PKG_DIR/build

NO_SIGN=${NO_SIGN:false}


if [[ -d $BUILD_DIR ]]; then
    echo "Build directory exists, removing"
    rm -rf $BUILD_DIR
fi
mkdir -p $BUILD_DIR/debian
for file in $(cd $PKG_DIR/.. && find . -type f | egrep -v '^./pkg/|^./.git/' | sed 's/^.\///'); do
    PARENT_DIR=$(dirname $BUILD_DIR/$file)
    if [[ ! -d $PARENT_DIR ]]; then
        mkdir -p $PARENT_DIR
    fi
    cp $PKG_DIR/../$file $BUILD_DIR/$file
done
cp -R $PKG_DIR/debian/* $BUILD_DIR/debian/

BUILD_ARGS=""
if [[ $NO_SIGN ]]; then
    BUILD_ARGS="$BUILD_ARGS -uc -us"
fi
cd $BUILD_DIR
debuild $BUILD_ARGS
