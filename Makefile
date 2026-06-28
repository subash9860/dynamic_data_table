.PHONY: version-patch version-minor version-major publish push help

# Get current version from pubspec.yaml
CURRENT_VERSION := $(shell grep '^version:' pubspec.yaml | sed 's/version: //')

help:
	@echo "Version management commands:"
	@echo "  make version-patch    - Bump patch version (1.0.0 -> 1.0.1)"
	@echo "  make version-minor    - Bump minor version (1.0.0 -> 1.1.0)"
	@echo "  make version-major    - Bump major version (1.0.0 -> 2.0.0)"
	@echo "  make publish          - Publish current version to pub.dev"

version-patch:
	@bash -c 'set -e; \
		current=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); \
		major=$$(echo $$current | cut -d. -f1); \
		minor=$$(echo $$current | cut -d. -f2); \
		patch=$$(echo $$current | cut -d. -f3); \
		patch=$$(($$patch + 1)); \
		new_version="$$major.$$minor.$$patch"; \
		sed -i "" "s/^version:.*/version: $$new_version/" pubspec.yaml; \
		git add pubspec.yaml; \
		git commit -m "Bump version to $$new_version"; \
		git tag v$$new_version; \
		echo "✓ Version bumped to $$new_version"; \
		echo "Run: git push origin main && git push origin v$$new_version"'

version-minor:
	@bash -c 'set -e; \
		current=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); \
		major=$$(echo $$current | cut -d. -f1); \
		minor=$$(echo $$current | cut -d. -f2); \
		minor=$$(($$minor + 1)); \
		new_version="$$major.$$minor.0"; \
		sed -i "" "s/^version:.*/version: $$new_version/" pubspec.yaml; \
		git add pubspec.yaml; \
		git commit -m "Bump version to $$new_version"; \
		git tag v$$new_version; \
		echo "✓ Version bumped to $$new_version"; \
		echo "Run: git push origin main && git push origin v$$new_version"'

version-major:
	@bash -c 'set -e; \
		current=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); \
		major=$$(echo $$current | cut -d. -f1); \
		major=$$(($$major + 1)); \
		new_version="$$major.0.0"; \
		sed -i "" "s/^version:.*/version: $$new_version/" pubspec.yaml; \
		git add pubspec.yaml; \
		git commit -m "Bump version to $$new_version"; \
		git tag v$$new_version; \
		echo "✓ Version bumped to $$new_version"; \
		echo "Run: git push origin main && git push origin v$$new_version"'

publish:
	@bash -c 'set -e; \
		version=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); \
		git push origin main; \
		git push origin v$$version; \
		echo "✓ Pushed version $$version to GitHub"; \
		echo "  GitHub Actions will auto-publish to pub.dev"'

push:
	@bash -c 'set -e; \
		current=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); \
		major=$$(echo $$current | cut -d. -f1); \
		minor=$$(echo $$current | cut -d. -f2); \
		patch=$$(echo $$current | cut -d. -f3); \
		patch=$$(($$patch + 1)); \
		new_version="$$major.$$minor.$$patch"; \
		sed -i "" "s/^version:.*/version: $$new_version/" pubspec.yaml; \
		last_tag=$$(git describe --tags --abbrev=0 2>/dev/null); \
		if [ -n "$$last_tag" ]; then \
			changes=$$(git log $$last_tag..HEAD --no-merges --pretty=format:"- %s"); \
		else \
			changes=$$(git log --no-merges --pretty=format:"- %s"); \
		fi; \
		[ -z "$$changes" ] && changes="- Updates and improvements."; \
		{ printf "## %s\n\n%s\n\n" "$$new_version" "$$changes"; cat CHANGELOG.md; } > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG.md; \
		git add pubspec.yaml CHANGELOG.md; \
		git commit -m "Bump version to $$new_version"; \
		git tag v$$new_version; \
		echo "✓ Bumped to $$new_version"; \
		git push origin main; \
		git push origin v$$new_version; \
		echo "✓ Pushed to GitHub"; \
		echo "  GitHub Actions publishing to pub.dev..."'
