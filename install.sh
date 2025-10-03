#!/bin/bash

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="${REPO_URL:-https://github.com/daviguides/semantic-docstrings.git}"
TMP_DIR="/tmp/semantic-docstrings-$$"
CLAUDE_DIR="$HOME/.claude"
TARGET_DIR="$CLAUDE_DIR/semantic-docstrings"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

# Sample config to append to ~/.claude/CLAUDE.md
read -r -d '' SAMPLE_CONFIG << 'EOF'
# Project Documentation Standards

## Standards Inheritance
- **INHERITS FROM**: @./semantic-docstrings/docs/semantic_docstrings.md
- **PRECEDENCE**: Project-specific rules override repository defaults
- **FALLBACK**: When no override exists, semantic-docstrings applies
EOF

cleanup() {
    if [ -d "$TMP_DIR" ]; then
        echo -e "${BLUE}Cleaning up temporary files...${NC}"
        rm -rf "$TMP_DIR"
    fi
}
trap cleanup EXIT

echo -e "${BLUE}Semantic Docstrings Installer${NC}"
echo -e "${BLUE}=============================${NC}\n"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    echo "Please install git first: https://git-scm.com/downloads"
    exit 1
fi

# Clone repository
echo -e "${BLUE}Cloning Semantic Docstrings repository...${NC}"
if ! git clone --quiet "$REPO_URL" "$TMP_DIR" 2>/dev/null; then
    echo -e "${RED}Error: Failed to clone repository${NC}"
    echo "Repository: $REPO_URL"
    exit 1
fi
echo -e "${GREEN}✓ Repository cloned successfully${NC}\n"

# Ensure ~/.claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${YELLOW}Creating ~/.claude directory...${NC}"
    mkdir -p "$CLAUDE_DIR"
fi

# Install into ~/.claude/semantic-docstrings
echo -e "${BLUE}Installing semantic-docstrings to $TARGET_DIR...${NC}"
if [ -d "$TARGET_DIR" ]; then
    read -p "Directory $TARGET_DIR already exists. Overwrite? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$TARGET_DIR"
    else
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 0
    fi
fi

cp -r "$TMP_DIR" "$TARGET_DIR"
echo -e "${GREEN}✓ semantic-docstrings installed successfully!${NC}\n"

# Handle CLAUDE.md configuration
if [ ! -f "$CLAUDE_MD" ]; then
    echo -e "${BLUE}No CLAUDE.md found in ~/.claude/${NC}"
    read -p "Create ~/.claude/CLAUDE.md with Semantic Docstrings configuration? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$SAMPLE_CONFIG" > "$CLAUDE_MD"
        echo -e "${GREEN}✓ CLAUDE.md created successfully!${NC}\n"
    else
        echo -e "${YELLOW}Skipped CLAUDE.md creation.${NC}"
        echo -e "${YELLOW}To use Semantic Docstrings, add this to your ~/.claude/CLAUDE.md:${NC}\n"
        echo "$SAMPLE_CONFIG"
        echo
    fi
else
    echo -e "${YELLOW}~/.claude/CLAUDE.md already exists.${NC}"
    read -p "Append Semantic Docstrings configuration to existing CLAUDE.md? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if grep -q "semantic-docstrings" "$CLAUDE_MD"; then
            echo -e "${YELLOW}Semantic Docstrings already referenced in CLAUDE.md${NC}"
        else
            printf "\n\n%s\n" "$SAMPLE_CONFIG" >> "$CLAUDE_MD"
            echo -e "${GREEN}✓ Semantic Docstrings configuration added to CLAUDE.md${NC}\n"
        fi
    else
        echo -e "${YELLOW}Skipped CLAUDE.md modification.${NC}"
        echo -e "${YELLOW}To use Semantic Docstrings, add this to your ~/.claude/CLAUDE.md:${NC}\n"
        echo "$SAMPLE_CONFIG"
        echo
    fi
fi

echo -e "${GREEN}Installation complete!${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Check ~/.claude/CLAUDE.md to ensure configuration is correct"
echo "2. Use Semantic Docstrings in any project by referencing it in project CLAUDE.md"
echo "3. See the docs at: https://github.com/daviguides/semantic-docstrings"
echo -e "\n${BLUE}Documentation:${NC} https://github.com/daviguides/semantic-docstrings"