.PHONY: help lint lint-kotlin lint-markdown format check-format test \
        build build-desktop build-android build-ios clean \
        docs-setup docs-serve docs-build docs-deploy \
        ci setup

.DEFAULT_GOAL := help

GRADLE        := ./gradlew
MARKDOWNLINT  := npx markdownlint-cli2
GRADLE_FLAGS  := --no-daemon
MKDOCS        := $(shell command -v mkdocs 2>/dev/null || echo "uv run mkdocs")

# Help

help: ## Show this help
	@echo "Chores App — Makefile targets"
	@echo ""
	@echo "  CODE QUALITY"
	@echo "    lint              Run all linters (Kotlin + Markdown)"
	@echo "    lint-kotlin       Run ktlint + detekt"
	@echo "    lint-markdown     Run markdownlint-cli2"
	@echo "    format            Auto-format Kotlin via ktlintFormat"
	@echo "    check-format      Check Kotlin formatting (fail if unformatted)"
	@echo ""
	@echo "  TEST"
	@echo "    test              Run all JVM tests"
	@echo ""
	@echo "  BUILD"
	@echo "    build             Build desktop + android"
	@echo "    build-desktop     Build desktop Debian package"
	@echo "    build-android     Build Android debug APK"
	@echo "    build-ios         Build iOS frameworks (macOS only)"
	@echo ""
	@echo "  CLEAN"
	@echo "    clean             Remove all build artifacts"
	@echo ""
	@echo "  DOCS"
	@echo "    docs-setup        Install mkdocs + material theme"
	@echo "    docs-serve        Serve docs locally (hot-reload)"
	@echo "    docs-build        Build docs static site"
	@echo "    docs-deploy       Deploy docs to GitHub Pages"
	@echo ""
	@echo "  CI"
	@echo "    ci                Run same checks as CI pipeline"

# Setup

setup: ## Install all tooling dependencies (npm + python)
	@echo "→ Installing markdownlint-cli2..."
	npm install --save-dev markdownlint-cli2
	@echo "→ Installing mkdocs + material theme..."
	uv pip install mkdocs mkdocs-material || pip3 install mkdocs mkdocs-material

# Lint

lint: lint-kotlin lint-markdown ## Run all linters

lint-kotlin: ## Run ktlint + detekt
	@echo "→ Running ktlint..."
	$(GRADLE) ktlintCheck $(GRADLE_FLAGS)
	@echo "→ Running detekt..."
	$(GRADLE) detekt $(GRADLE_FLAGS)

lint-markdown: ## Run markdownlint-cli2
	@echo "→ Running markdownlint-cli2..."
	$(MARKDOWNLINT)

# Format

format: ## Auto-format Kotlin code
	@echo "→ Formatting Kotlin with ktlintFormat..."
	$(GRADLE) ktlintFormat $(GRADLE_FLAGS)

check-format: ## Check formatting (CI use)
	@echo "→ Checking Kotlin formatting..."
	$(GRADLE) ktlintCheck $(GRADLE_FLAGS)

# Test

test: ## Run all JVM tests
	@echo "→ Running all JVM tests..."
	$(GRADLE) allTests $(GRADLE_FLAGS)

# Build

build: build-desktop build-android ## Build desktop + android

build-desktop: ## Build desktop Debian package
	@echo "→ Building Desktop Debian package..."
	$(GRADLE) packageDeb $(GRADLE_FLAGS)

build-android: ## Build Android debug APK
	@echo "→ Building Android debug APK..."
	$(GRADLE) assembleDebug $(GRADLE_FLAGS)

build-ios: ## Build iOS frameworks (macOS only)
	@echo "→ Building iOS frameworks..."
	$(GRADLE) linkDebugFrameworkIosArm64 linkDebugFrameworkIosSimulatorArm64 $(GRADLE_FLAGS)

# Clean

clean: ## Remove all build artifacts
	@echo "→ Cleaning build artifacts..."
	$(GRADLE) clean $(GRADLE_FLAGS)
	rm -rf site/ node_modules/

# Docs

docs-setup: ## Install mkdocs + material theme
	@echo "→ Installing mkdocs + material theme..."
	uv pip install --system mkdocs mkdocs-material || uv pip install mkdocs mkdocs-material || pip3 install mkdocs mkdocs-material

docs-serve: ## Serve docs locally (hot-reload)
	@echo "→ Starting mkdocs server at http://127.0.0.1:8000 ..."
	$(MKDOCS) serve

docs-build: ## Build static documentation site
	@echo "→ Building documentation site..."
	$(MKDOCS) build

docs-deploy: ## Deploy docs to GitHub Pages
	@echo "→ Deploying documentation to GitHub Pages..."
	$(MKDOCS) gh-deploy

# CI

ci: lint test build-desktop ## Run same checks as CI pipeline (no iOS — macOS only)
	@echo ""
	@echo "✔  CI checks passed (lint + test + desktop build)"
