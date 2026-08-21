# Working in this repo

Single Fundraise Up demo site, plain static HTML. Live at **https://the-giving-harvest-food-bank.pages.dev**
Cloudflare project `the-giving-harvest-food-bank` in Cesar's (`e1a83898…`). Repo owned by Cesar (CidRobles).

Pages: `index.html`, `giftcart.html`. No build step, no framework — what is in this repo is what gets served.

## Before editing

Run `git pull` yourself; do not ask the user to run terminal commands. This team works in
GitHub Desktop and the Claude app, not a terminal.

## After editing

1. Look at the rendered page before saying it works. Opening the local file in a browser
   shows the real thing — images, styling, and the Fundraise Up donate button all render
   correctly from disk. Point the user at `index.html` to double-click.
2. Commit with a summary of what changed and why.
3. Push only when the user asks. A push publishes to the public internet immediately —
   there is no staging step and no approval gate. Most people here publish from GitHub
   Desktop; if a push fails on authentication, say so and tell them to click Commit to main
   then Push origin in GitHub Desktop rather than troubleshooting credentials.
4. After pushing, confirm the deploy landed — Cloudflare posts a check run on the commit,
   and the live URL should show the change.

## Rules

- **Never take this site out of Fundraise Up test mode.** Do not remove
  `fundraiseupLivemode=no`, do not set livemode true, do not suggest going live.
- **This repo is not owned by the person you are working with.** It belongs to Cesar (CidRobles).
  Make the change asked for; do not restructure, rename, reorganise, or "tidy up" files.
- **Do not add GitHub Actions workflows.** This project deploys through Cloudflare's
  built-in Git integration, which watches the repo directly. Adding Actions would create a
  second, conflicting deploy path.
- **Never commit credentials.** No tokens or keys belong in this repo.

## How deploys work

Cloudflare's built-in Git integration: push to `main`, Cloudflare pulls and publishes.
No workflow files, no API tokens, no secrets. A failed build publishes nothing, so the live
site is never left half-updated. To undo something live, revert the commit and push.
