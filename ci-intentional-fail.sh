#!/usr/bin/env bash

# Intentional syntax error for branch protection / required-check testing.
if [[ -n "${1:-}" ]]; then
    echo "This file exists only to make CI fail for testing."
