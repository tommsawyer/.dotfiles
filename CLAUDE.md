After changing any config, run `make check` and fix what it reports before calling the change done. After changing Lua, run `make fmt` first (formats it through lua_ls, the same as saving in nvim).

# Git

- Always use Conventional Commits for commit messages (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, … with an optional scope, e.g. `fix(nvim): …`).
- Commit and push straight to `master`, no branches or pull requests. Run `git pull --ff-only` before committing.
- Never commit or push on your own: when a change is done, show the diff and wait for the human to review it and explicitly say to commit.
