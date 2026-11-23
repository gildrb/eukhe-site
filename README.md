# eukhe-site

eukhe.com: [Eukhe](https://github.com/gildrb/eukhe)'s README and the files it links, set as Neovim renders Markdown, in Paper Mono and gildrb.com's colors. Preact, StyleX, strict TypeScript, Vite+ (`vp`), a Cloudflare Worker. Its own laws (`LAWS.bend`, `laws/`, `proof/`, `LAWS.lock`) and check; nothing deploys on a push.

## Commands

```sh
vp install --frozen-lockfile  # dependencies
vp run eukhe                  # Eukhe's checkout in .eukhe/ (EUKHE_REF, default main)
vp dev                        # dev server, http://127.0.0.1:5175 (needs .eukhe/)
vp check                      # format, lint, type check
vp run laws                   # .eukhe/, the site's proofs (checker and --verdict), then LAWS.lock
vp run build                  # .eukhe/, vim/vim.bend -> src/vim.mjs, then prerender into dist/
vp exec wrangler dev          # dist/ behind the Worker, http://127.0.0.1:8787
vp run deploy                 # build, then `wrangler deploy` (by hand only)
```

## Eukhe's files

The site holds no copy of Eukhe. `scripts/eukhe.sh` (`vp run eukhe`, run by `build`, `laws` and `deploy`) fetches gildrb/eukhe at `EUKHE_REF` (a branch, tag or commit; default `main`) as a shallow checkout into `.eukhe/` (ignored), fetching again on each run, and prints the commit it got. So every build, and every deploy, shows Eukhe's `main` as it is then: a README change reaches eukhe.com on the next deploy, with no change here. `EUKHE_REF=<sha> vp run build` builds the site of an older or unmerged Eukhe.

From the checkout the build reads:

- `README.md`: the home page.
- Every file the README's relative links reach (`scripts/files.ts`), from its tracked files.
- The images the README shows (`.github/media/*.webp`).
- The Bend release Eukhe pins (`.github/scripts/toolchain.env`, found by `.github/scripts/pinned_bend.py`), which builds `vim/vim.bend`, and the bend skill commit it pins (`.github/scripts/pinned_skill.py`), which locks the laws.

## Content

- Home page: Eukhe's `README.md`; its first `# ` heading names the page. `src/source.ts` puts a `Source:` line under its title and at its end.
- The editor shows Markdown rendered as Neovim does with render-markdown.nvim and snacks.nvim (`src/rendered.ts`): markers hidden, prose wrapped at 80 cells or the screen, the README's HTML rendered, each `<img>` in rows of its own under its line, linking the source. Each image the README shows is served at its path (`.github/media/*.webp`), named by its content. Every code block gets a `[copy]` of its commands.
- Visual mode (`v`, `V`, a mouse drag) selects, motions extend it, `-- VISUAL --` names it; `y`, `yy`, `Y`, Cmd-C, Ctrl-C copy; a yank flashes for 150 ms (vim/visual.bend; laws R7, R9, R10).
- `scripts/files.ts`: every file the README's relative links reach. A linked folder, or a linked `README.md` (its folder's index), brings the whole folder; links of each Markdown file reached are followed in turn. A link that leaves the repository or reaches no file fails the build.
- The editor holds those files (`<Space><Space>` finds them); a click on a relative link opens its file or folder (gf). The site serves each at its path (`/LICENSE`, `/spec/rlm/family.bend`, text), and each folder as a page (`/spec/rlm/`).
- `src/epigraphs.ts`: Attic Greek epigraphs, at most one under a README heading, each with translation and citation; keyed by heading line. An epigraph whose heading the README no longer holds is left out (the build names it).
- `src/content/{about,contact,privacy}.md`: the other pages, rendered the same way.
- `src/tokens.stylex.ts` `palette`: every color, OKLCH, per theme.
- `public/install.sh`: the installer, served at `/install`.
- Font notices: `THIRD_PARTY_NOTICES.md`.

## Worker

`worker/index.ts`, files from `dist/`. Routes: `eukhe.com/*`, `www.eukhe.com/*`. `gildrb.com/eukhe` and `eukhe.gildrb.com` redirect here from gildrb.com.

| Request                          | Response                     |
| -------------------------------- | ---------------------------- |
| `GET /install`                   | `public/install.sh`, as text |
| `GET /`, `Accept: */*` (curl)    | `public/install.sh`, as text |
| `GET /`, `Accept: text/markdown` | `index.md`                   |
| `GET /`, `Accept: text/html`     | `index.html`                 |
| `www.eukhe.com/*`                | 301 to `eukhe.com`           |

## License

Code: MIT ([LICENSE](LICENSE)). Font: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
