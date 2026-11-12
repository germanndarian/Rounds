@AGENTS.md

# Claude workflow

## Vault and docs
- Before starting, read the project note `~/Documents/Projects/personal-os/projects/Rounds/Rounds.md` (state, what's next, rules).
  Roadmap and Supabase guide are in the same folder. The roadmap is ticked off automatically from commits.
- New docs go in the vault, not the repo: the repo keeps only README.md, CLAUDE.md, AGENTS.md and `.claude/skills/`.
- Leave the sections marked `<!-- auto -->` alone, because the sync agent rewrites them.
- Skills: `build-and-test` (troubleshooting, reading results), `supabase-migration` (schema changes), `nocturne-ui` (design system and prototype source).

## Git & attribution
- Commits are authored **only** as `dariangermann <dariangermann@gmail.com>` (GitHub: `germanndarian`).
  Commit with `git -c user.name="dariangermann" -c user.email="dariangermann@gmail.com" commit …`.
- **No** `Co-Authored-By: Claude …` trailers and **no** "Generated with Claude Code" lines in commits or PR descriptions.
- Never use or reference the `ia24germannd` GitHub account.
- `main` is protected: work on a branch (`feature/…`, `chore/…`, `fix/…`), open a PR, and the **Build & test** CI check must pass.
  No direct pushes, no force pushes. Merge with squash.
- PR descriptions are short: up to three bullets, one **Checked:** line, and **For you:** or **Open:** only when needed.

## Secrets
- Supabase URL and anon/publishable key live in `Config/Secrets.xcconfig` (gitignored). Never commit keys.
- Never put the `service_role` / secret key in the app.
