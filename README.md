# cc-usagebar

English · [中文](README.zh.md)

Übersicht widget that shows your **Claude Code** and **Codex** usage live on the macOS desktop — current session %, weekly limit %, and reset countdowns.

![screenshot](screenshot.png)

Built because [CodexBar](https://github.com/steipete/CodexBar)'s menu-bar app does not register on every Mac (Sequoia's LSUIElement registration sometimes silently fails), but its CLI works perfectly. This widget reuses CodexBar's data and SVG icons, just renders them on the desktop instead of the menu bar.

## Requirements

- macOS 14+
- [Übersicht](https://tracesof.net/uebersicht/) — `brew install --cask ubersicht`
- [CodexBar CLI](https://github.com/steipete/CodexBar) — installed and on `$PATH` as `codexbar`
- Claude Code CLI logged in (for Claude data)
- Codex CLI logged in (for Codex data)

## Install

```bash
git clone https://github.com/XINHAO-ZHANG/cc-usagebar.git
cp cc-usagebar/codexbar.coffee \
  ~/Library/Application\ Support/Übersicht/widgets/
cp -r cc-usagebar/icons \
  ~/Library/Application\ Support/Übersicht/widgets/
```

Open Übersicht — the widget appears at the top-right of your desktop.

> **Heads up:** if Übersicht's menu-bar icon is missing, add `/Applications/Übersicht.app` under **System Settings → General → Login Items & Extensions → Open at Login**, then relaunch the app. macOS won't grant a status item until the app is registered as a background item.

## Customize

Edit `codexbar.coffee`:

| Field | Default | Meaning |
|---|---|---|
| `refreshFrequency` | `300000` | Refresh interval in ms (300000 = 5 min) |
| `top:` / `right:` | `50px` / `30px` | Widget position |
| `width:` | `280px` | Widget width |
| `barColor:` | green/yellow/red | Threshold colors (green > 50%, yellow 20–50%, red < 20%) |

Save the file — Übersicht auto-reloads.

## Credits

- [CodexBar](https://github.com/steipete/CodexBar) by [@steipete](https://github.com/steipete) — provides the `codexbar` CLI and the SVG icons used here
- [Übersicht](https://github.com/felixhageloh/uebersicht) by [@felixhageloh](https://github.com/felixhageloh) — the desktop widget runtime

## License

MIT — see [LICENSE](LICENSE).
