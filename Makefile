.PHONY: dev prod status help validate install test-install serve-docs build-docs

BUNDLE_NAME := semantic-docstrings

# Help target
help:
	@echo "semantic-docstrings Development Utilities"
	@echo ""
	@echo "Development Targets:"
	@echo "  make dev           - Convert to relative refs for local development"
	@echo "  make prod          - Convert to absolute refs for production/commit"
	@echo "  make status        - Show current reference state"
	@echo ""
	@echo "Plugin Targets:"
	@echo "  make validate      - Validate Claude Code plugin structure"
	@echo "  make install       - Run installation script"
	@echo "  make test-install  - Test installation script syntax"
	@echo ""
	@echo "Documentation Targets:"
	@echo "  make serve-docs    - Serve Jekyll docs locally"
	@echo "  make build-docs    - Build Jekyll docs"

# Development mode: convert to relative references
dev:
	@echo "Converting to development mode (relative references)..."
	@find . -name "*.md" -type f -exec sed -i.bak 's|@~/\.claude/$(BUNDLE_NAME)/|@./$(BUNDLE_NAME)/|g' {} \;
	@find . -name "*.md.bak" -type f -delete
	@echo "✓ Converted to @./$(BUNDLE_NAME)/ (local development)"

# Production mode: convert to absolute references
prod:
	@echo "Converting to production mode (absolute references)..."
	@find . -name "*.md" -type f -exec sed -i.bak 's|@\./$(BUNDLE_NAME)/|@~/.claude/$(BUNDLE_NAME)/|g' {} \;
	@find . -name "*.md.bak" -type f -delete
	@echo "✓ Converted to @~/.claude/$(BUNDLE_NAME)/ (production)"

# Status: show current reference state
status:
	@echo "Reference Status:"
	@echo ""
	@echo "Relative references (@./$(BUNDLE_NAME)/):"
	@grep -r "@\./$(BUNDLE_NAME)/" . --include="*.md" 2>/dev/null | wc -l | xargs echo "  Count:"
	@echo ""
	@echo "Absolute references (@~/.claude/$(BUNDLE_NAME)/):"
	@grep -r "@~/\.claude/$(BUNDLE_NAME)/" . --include="*.md" 2>/dev/null | wc -l | xargs echo "  Count:"
	@echo ""
	@if grep -r "@\./$(BUNDLE_NAME)/" . --include="*.md" 2>/dev/null | grep -q .; then \
		echo "Status: DEVELOPMENT mode"; \
	else \
		echo "Status: PRODUCTION mode (ready to commit)"; \
	fi

# Validate Claude Code plugin
validate:
	@echo "Validating Claude Code plugin structure..."
	claude plugin validate .

# Run installation script
install:
	@echo "Running installation script..."
	bash install.sh

# Test installation without actually installing
test-install:
	@echo "Testing installation script (dry-run)..."
	@echo "Note: This will show what would be installed"
	bash -n install.sh
	@echo "✓ Installation script syntax is valid"

# Serve Jekyll documentation locally
serve-docs:
	@echo "Starting Jekyll server..."
	@echo "Documentation will be available at http://localhost:4000"
	cd docs && bundle exec jekyll serve

# Build Jekyll documentation
build-docs:
	@echo "Building Jekyll documentation..."
	cd docs && bundle exec jekyll build
	@echo "✓ Documentation built in docs/_site/"
