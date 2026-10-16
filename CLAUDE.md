After changing any config, run `make check` and fix what it reports before calling the change done.

# Git

- Always use Conventional Commits for commit messages (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, … with an optional scope, e.g. `fix(nvim): …`).
- Never push to `master`. Always create a branch and open a pull request with `gh pr create`.
- Pull request titles and descriptions must be in Russian.
- Before creating a branch, switch to `master` and `git pull --ff-only`; delete local branches whose PRs are merged.
