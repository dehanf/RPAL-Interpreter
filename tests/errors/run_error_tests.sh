#!/bin/bash
# run_error_tests.sh
# Run all error test programs and show their error output.
# Usage: bash tests/errors/run_error_tests.sh   (from project root)

BINARY="./rpal20.exe"
ERRORS_DIR="tests/errors"
PASS=0
FAIL=0

if [ ! -f "$BINARY" ]; then
    echo "ERROR: binary '$BINARY' not found. Run 'make' first."
    exit 1
fi

run_test() {
    local file="$1"
    local label
    label=$(basename "$file")
    echo "────────────────────────────────────────"
    echo "TEST: $label"
    echo "PROGRAM:"
    grep -v '^//' "$file" | head -6   # show non-comment lines
    echo ""
    echo "OUTPUT:"
    "$BINARY" "$file" 2>&1
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "[✓ exited with code $exit_code — error was reported]"
        PASS=$((PASS + 1))
    else
        echo "[✗ exited with code 0 — error was NOT reported!]"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

for f in "$ERRORS_DIR"/err*.rpal; do
    run_test "$f"
done

echo "════════════════════════════════════════"
echo "Results: $PASS passed (error caught), $FAIL failed (error missed)"
