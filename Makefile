.PHONY: help lint lint-kotlin lint-rust lint-markdown \
        format format-kotlin format-rust check-format check-kotlin-format check-rust-format \
        test test-frontend test-frontend-jvm test-frontend-android test-frontend-js test-frontend-wasm test-backend \
        build build-desktop build-android build-ios clean \
        docs-setup docs-serve docs-build docs-deploy \
        ci setup

.DEFAULT_GOAL := help

GRADLE        := ./frontend/gradlew -p frontend
MARKDOWNLINT  := npx markdownlint-cli2
GRADLE_FLAGS  := --no-daemon
MKDOCS        := $(shell command -v mkdocs 2>/dev/null || echo "uv run --with mkdocs-material mkdocs")

# Help

help: ## Show this help
	@echo "Chores App — Makefile targets"
	@echo ""
	@echo "  CODE QUALITY"
	@echo "    lint              Run all linters (Kotlin + Rust + Markdown)"
	@echo "    lint-kotlin       Run ktlint + detekt"
	@echo "    lint-rust         Run Clippy with warnings denied"
	@echo "    lint-markdown     Run markdownlint-cli2"
	@echo "    format            Auto-format Kotlin and Rust"
	@echo "    check-format      Check Kotlin and Rust formatting"
	@echo ""
	@echo "  TEST"
	@echo "    test              Run frontend and backend tests"
	@echo "    test-frontend     Run Kotlin Multiplatform tests"
	@echo "    test-frontend-jvm Run Kotlin/JVM tests"
	@echo "    test-frontend-android Run Android unit tests"
	@echo "    test-frontend-js  Run JavaScript tests"
	@echo "    test-frontend-wasm Run WebAssembly tests"
	@echo "    test-backend      Run Rust tests"
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

lint: lint-kotlin lint-rust lint-markdown ## Run all linters

lint-kotlin: ## Run ktlint + detekt
	@echo "→ Running ktlint..."
	$(GRADLE) ktlintCheck $(GRADLE_FLAGS)
	@echo "→ Running detekt..."
	$(GRADLE) detekt $(GRADLE_FLAGS)

lint-rust: ## Run Clippy with warnings denied
	@echo "→ Running Clippy with warnings denied..."
	cargo clippy --manifest-path backend/Cargo.toml --all-targets --all-features --locked -- -D warnings

lint-markdown: ## Run markdownlint-cli2
	@echo "→ Running markdownlint-cli2..."
	$(MARKDOWNLINT)

# Format

format: format-kotlin format-rust ## Auto-format Kotlin and Rust code

format-kotlin: ## Auto-format Kotlin code
	@echo "→ Formatting Kotlin with ktlintFormat..."
	$(GRADLE) ktlintFormat $(GRADLE_FLAGS)

format-rust: ## Auto-format Rust code
	@echo "→ Formatting Rust with rustfmt..."
	cargo fmt --manifest-path backend/Cargo.toml --all

check-format: check-kotlin-format check-rust-format ## Check Kotlin and Rust formatting

check-kotlin-format: ## Check Kotlin formatting
	@echo "→ Checking Kotlin formatting..."
	$(GRADLE) ktlintCheck $(GRADLE_FLAGS)

check-rust-format: ## Check Rust formatting
	@echo "→ Checking Rust formatting..."
	cargo fmt --manifest-path backend/Cargo.toml --all -- --check

# Test

test: test-frontend test-backend ## Run frontend and backend tests

test-frontend: ## Run Kotlin Multiplatform tests
	@echo "→ Running Kotlin Multiplatform tests..."
	$(GRADLE) jvmTest testDebugUnitTest jsTest wasmJsTest $(GRADLE_FLAGS)

test-frontend-jvm: ## Run Kotlin/JVM tests
	@echo "→ Running Kotlin/JVM tests..."
	$(GRADLE) jvmTest $(GRADLE_FLAGS)

test-frontend-android: ## Run Android unit tests
	@echo "→ Running Android unit tests..."
	$(GRADLE) testDebugUnitTest $(GRADLE_FLAGS)

test-frontend-js: ## Run JavaScript tests
	@echo "→ Running JavaScript tests..."
	$(GRADLE) jsTest $(GRADLE_FLAGS)

test-frontend-wasm: ## Run WebAssembly tests
	@echo "→ Running WebAssembly tests..."
	$(GRADLE) wasmJsTest $(GRADLE_FLAGS)

test-backend: ## Run Rust tests
	@echo "→ Running Rust tests..."
	cargo test --manifest-path backend/Cargo.toml --locked

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
	cargo clean --manifest-path backend/Cargo.toml
	rm -rf site/ node_modules/

# Docs

docs-setup: ## Install mkdocs + material theme
	@echo "→ Installing mkdocs + material theme..."
	uvx mkdocs --version >/dev/null 2>&1 || uv tool install mkdocs
	uv pip install mkdocs-material || uv run --with mkdocs-material mkdocs --version

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

ci: lint-markdown check-rust-format lint-rust test ## Run the same checks as CI
	@echo ""
	@echo "✔  CI checks passed"
