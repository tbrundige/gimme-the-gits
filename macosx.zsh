#!/usr/bin/env zsh

# Set script directory as working directory
cd "$(dirname "$0")"

# Download brew.packages file
curl -o brew.packages "https://raw.githubusercontent.com/tbrundige/gimme-the-gits/refs/heads/main/brew.packages"

# Install Homebrew if not installed
# Installing Homebrew will give ya teh gits
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Ensure brew.packages file exists before reading
if [[ ! -f "brew.packages" ]]; then
    echo "Error: brew.packages file not found. Exiting."
    exit 1
fi

# Read package list and install via Homebrew
echo "Installing packages..."
while IFS= read -r package || [[ -n "$package" ]]; do
    if [[ -n "$package" ]]; then
        brew install "$package"
    fi
done < brew.packages

# Refresh environment
export PATH="$(brew --prefix)/bin:$PATH"

# Authenticate with GitHub CLI
username=$(gh auth status 2>&1 | grep -oE "Logged in to github.com account (\S+)" | awk '{print $NF}')

if [[ -z "$username" ]]; then
    gh auth login -w -p 'https'
    username=$(gh auth status 2>&1 | grep -oE "Logged in to github.com account (\S+)" | awk '{print $NF}')
fi

# Exit if authentication failed
if [[ -z "$username" ]]; then
    exit 1
fi

# Clone dotfiles repository
echo "Dipping the dots..."
gh repo clone "$username/dots"

# Run macosx.zsh script
zsh "./dots/launch/macosx.zsh"
