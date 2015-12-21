#!/bin/bash
# Example of a status line requiring non-trivial read() use.
while true
do
	echo -n "foo "
	sleep 0.05s
	echo -n "bar "
	sleep 0.05s
	echo "qux"
	sleep 5
done
