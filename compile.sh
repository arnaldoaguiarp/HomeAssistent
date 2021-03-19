#! /bin/bash

DIR=$(pwd)
grpc_tools_ruby_protoc -I $DIR/grpc/ --ruby_out=$DIR/grpc_lib --grpc_out=$DIR/grpc_lib $DIR/grpc/*.proto
