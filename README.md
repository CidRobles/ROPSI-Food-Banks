# the-giving-harvest-food-bank

Source for the Fundraise Up demo site at **https://the-giving-harvest-food-bank.pages.dev**

| | |
|---|---|
| Live site | https://the-giving-harvest-food-bank.pages.dev |
| Pages | `index.html`, `giftcart.html` |
| Cloudflare account | Cesar's (`e1a83898…`) |
| Repo owner | Cesar (CidRobles) |

**Deploys are automatic.** Push to `main` and Cloudflare rebuilds and publishes the site
on its own, usually within a minute. Nobody uploads anything by hand, and you do not need a
Cloudflare login to publish a change.

This is a plain static site — HTML, CSS, images. No build step, no framework, no package
manager. What is in this repo is exactly what gets served.

---

## One-time setup — about five minutes, all clicking, no terminal

1. **Install GitHub Desktop** from [desktop.github.com](https://desktop.github.com) and
   **sign in with your GitHub account.** This is what gives *your computer* permission to
   publish. Being signed in to github.com in a browser is not the same thing.

2. **Clone this repo:** GitHub Desktop → **File → Clone Repository → CidRobles/ROPSI-Food-Banks → Clone.**
   Note the folder it saves into.

3. **Install the Claude desktop app** if you do not have it.

If you cannot see this repo in the clone list, you have not been added as a collaborator
yet — ask Cesar (CidRobles). Only the repo owner can add people.

---

## Changing the site

1. **Open GitHub Desktop and click "Fetch origin"** to pull in anything teammates changed.
   Skipping this is the most common way to create a mess.

2. **Open Claude** and point it at the folder you cloned.

3. **Say what you want, in plain language:**

   > Change the hero headline to "Every Animal Deserves a Home" and make the donate button
   > say "Give Today".

4. **Look at it before you publish.** In GitHub Desktop click
   **Repository → Show in Finder** and double-click `index.html`. It opens in your browser
   showing your edited version — text, images, styling, and the Fundraise Up donate button
   all render correctly from disk. Refresh after each change.

   You can also just ask Claude *"show me what that looks like"*.

5. **Publish in GitHub Desktop.** Your changes are listed down the left. Type a short
   summary at the bottom left, click **Commit to main**, then **Push origin**.

   **Push origin is the button that publishes.** Committing alone changes nothing live.

6. **Confirm it worked.** On GitHub, look at the commit list — Cloudflare adds a green
   check mark to the commit once the site is published. Then refresh the live site with
   `Cmd+Shift+R` so you are not seeing a cached copy.

---

## Changing it without Claude

**In your editor:** GitHub Desktop → **Repository → Show in Finder** → open the file in any
text editor → save → commit and push in GitHub Desktop.

**In the browser, no download:** open the file on GitHub, click the **pencil icon**, edit,
then **Commit changes** directly to `main`. Good for a one-line copy fix from any machine.

---

## How deploys work

This project uses **Cloudflare's built-in Git integration**. Cloudflare watches this repo
directly: push to `main`, and it pulls the files and publishes them. There is no GitHub
Actions workflow here and no API tokens to manage.

That is different from the sites in `corey-mustard/fru-demo-sites`, which deploy through
GitHub Actions. Same outcome, different plumbing — do not copy deployment instructions
between the two.

**If a deploy fails**, nothing is published; the live site stays as it was. Read the build
log in the Cloudflare dashboard.

**To undo a change that did go live**, revert the commit and push — that triggers a fresh
deploy carrying the old content. In GitHub Desktop: **History** tab, right-click the bad
commit, **Revert Changes**, then **Push origin**. Or ask Claude to revert it for you.

---

## Rules

- **This site stays in Fundraise Up test mode.** It is a demo. Never switch it to live mode.
- **Push to `main` publishes immediately.** There is no staging step and no approval.
  Treat a push as "this is now public."
- **Only Cesar (CidRobles) can add collaborators.** Everyone else with access has write permission
  but cannot invite others — this repo is owned by a personal GitHub account, which has no
  admin role to grant.
- **`README.md` and `CLAUDE.md` are served publicly** at `https://the-giving-harvest-food-bank.pages.dev/README.md` along with the
  rest of the repo. Nothing sensitive belongs in them.
