#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

REPO_URL="https://github.com/daviguides/semantic-docstrings.git"
TMP_DIR="/tmp/semantic-docstrings-$$"
CLAUDE_DIR="$HOME/.claude"
TARGET_DIR="$CLAUDE_DIR/semantic-docstrings"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

SAMPLE_CONFIG="$(cat << 'EOF'
# Project Documentation Standards

## Standards Inheritance
- **INHERITS FROM**: @./semantic-docstrings/semantic_docstrings.md
- **PRECEDENCE**: Project-specific rules override repository defaults
- **FALLBACK**: When no override exists, semantic-docstrings applies
EOF
)"

cleanup() { [ -d "$TMP_DIR" ] && { printf "%b\n" "${BLUE}Cleaning up temporary files...${NC}"; rm -rf "$TMP_DIR"; }; }
trap cleanup EXIT

printf "%b\n" "${BLUE}Semantic Docstrings Installer${NC}"
printf "%b\n\n" "${BLUE}===========================${NC}"

command -v git >/dev/null 2>&1 || { printf "%b\n" "${RED}Error: git is not installed${NC}"; printf "%s\n" "Install: https://git-scm.com/downloads"; exit 1; }

printf "%b\n" "${BLUE}Cloning Semantic Docstrings repository...${NC}"
git clone --quiet "$REPO_URL" "$TMP_DIR" 2>/dev/null || { printf "%b\n" "${RED}Error: Failed to clone repository${NC}"; printf "Repository: %s\n" "$REPO_URL"; exit 1; }
printf "%b\n\n" "${GREEN}✓ Repository cloned successfully${NC}"

[ -d "$CLAUDE_DIR" ] || { printf "%b\n" "${YELLOW}Creating ~/.claude directory...${NC}"; mkdir -p "$CLAUDE_DIR"; }

# --- COPIAR APENAS A SUBPASTA "$TMP_DIR/semantic-docstrings" ---
SRC_SUBDIR="$TMP_DIR/semantic-docstrings"
if [ ! -d "$SRC_SUBDIR" ]; then
  printf "%b\n" "${RED}Error: expected subfolder not found:${NC} $SRC_SUBDIR"
  printf "%s\n" "Repo layout mudou? Verifique se a pasta 'semantic-docstrings/' existe na raiz do repositório."
  exit 1
fi

printf "%b\n" "${BLUE}Installing semantic-docstrings to $TARGET_DIR...${NC}"
if [ -d "$TARGET_DIR" ]; then
  read -p "Directory $TARGET_DIR already exists. Overwrite? (y/n) " -n 1 -r; printf "\n"
  if [[ $REPLY =~ ^[Yy]$ ]]; then rm -rf "$TARGET_DIR"; else printf "%b\n" "${YELLOW}Installation cancelled.${NC}"; exit 0; fi
fi
mkdir -p "$TARGET_DIR"

if command -v rsync >/dev/null 2>&1; then
  # copia apenas o conteúdo da subpasta para o TARGET_DIR
  rsync -a "$SRC_SUBDIR"/ "$TARGET_DIR"/
else
  # fallback POSIX: copia conteúdo da subpasta (inclui dotfiles)
  ( set -f; cp -R "$SRC_SUBDIR"/. "$TARGET_DIR"/ )
fi
printf "%b\n\n" "${GREEN}✓ semantic-docstrings installed successfully!${NC}"

if [ ! -f "$CLAUDE_MD" ]; then
  printf "%b\n" "${BLUE}No CLAUDE.md found in ~/.claude/${NC}"
  read -p "Create ~/.claude/CLAUDE.md with Semantic Docstrings configuration? (y/n) " -n 1 -r; printf "\n"
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "%s\n" "$SAMPLE_CONFIG" > "$CLAUDE_MD"
    printf "%b\n\n" "${GREEN}✓ CLAUDE.md created successfully!${NC}"
  else
    printf "%b\n" "${YELLOW}Skipped CLAUDE.md creation.${NC}"
    printf "%b\n\n" "${YELLOW}To use Semantic Docstrings, add this to your ~/.claude/CLAUDE.md:${NC}"
    printf "%s\n\n" "$SAMPLE_CONFIG"
  fi
else
  printf "%b\n" "${YELLOW}~/.claude/CLAUDE.md already exists.${NC}"
  read -p "Append Semantic Docstrings configuration to existing CLAUDE.md? (y/n) " -n 1 -r; printf "\n"
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if grep -q "semantic-docstrings" "$CLAUDE_MD"; then
      printf "%b\n" "${YELLOW}Semantic Docstrings already referenced in CLAUDE.md${NC}"
    else
      printf "\n\n%s\n" "$SAMPLE_CONFIG" >> "$CLAUDE_MD"
      printf "%b\n\n" "${GREEN}✓ Semantic Docstrings configuration added to CLAUDE.md${NC}"
    fi
  else
    printf "%b\n" "${YELLOW}Skipped CLAUDE.md modification.${NC}"
    printf "%b\n\n" "${YELLOW}To use Semantic Docstrings, add this to your ~/.claude/CLAUDE.md:${NC}"
    printf "%s\n\n" "$SAMPLE_CONFIG"
  fi
fi

printf "%b\n" "${GREEN}Installation complete!${NC}"
printf "%b\n\n" "${BLUE}Next steps:${NC}"
printf "%s\n" "1. Check ~/.claude/CLAUDE.md to ensure configuration is correct"
printf "%s\n" "2. Use Semantic Docstrings in any project by referencing it in project CLAUDE.md"
printf "%s\n" "3. Docs: https://github.com/daviguides/semantic-docstrings"