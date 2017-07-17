#!/usr/bin/env bash

assert() {
    CONTAINER="$1"
    ASSERTION="$2"

    echo "----- $ASSERTION -----"
    OUTPUT=$(docker run --rm "$CONTAINER" $ASSERTION)
    if test "$?" -eq 0; then
        echo "PASS"
    else
        echo "$OUTPUT"
        echo "FAIL"
    fi
}

main() {
    SPECFILE="$1"
    CONTAINER="$2"

    echo "===== testing $CONTAINER with assertion file $SPECFILE ====="

    while read -r ASSERTION; do
        assert "$CONTAINER" "$ASSERTION"
    done < "$SPECFILE"
}

main $@
