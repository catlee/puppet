#!/bin/bash
echo Running pre-flight steps

status=0
for f in $(find /etc/preflight.d -type f -executable | sort); do
    echo Running $f...
    if ! $f; then
        echo failed
        status=1
        break
    else
        echo OK
    fi
done

if [ $status = 1 ]; then
    echo "reboot!"
fi
