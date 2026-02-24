#!/usr/bin/env bash

# Creates a symbolic link for git hooks
cd "$(dirname "$0")/.."

echo "Setting up Git Hooks..."
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
echo "Done!"
