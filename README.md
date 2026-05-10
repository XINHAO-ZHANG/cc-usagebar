# cc-usagebar

[中文](#中文说明) · English

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

---

# 中文说明

Übersicht widget，把 Claude Code 和 Codex 的实时用量画在 macOS 桌面上：会话进度、周限额、重置倒计时一目了然。

![截图](screenshot.png)

做这个是因为 [CodexBar](https://github.com/steipete/CodexBar) 那个菜单栏 app 在某些 Mac 上图标注册失败（macOS Sequoia 偶尔会让 LSUIElement 类 app 默默罢工），但它的 CLI 完全可用。这个 widget 复用了 CodexBar 的数据接口和图标，只是把展示从菜单栏挪到了桌面上。

## 依赖

- macOS 14+
- [Übersicht](https://tracesof.net/uebersicht/) —— `brew install --cask ubersicht`
- [CodexBar CLI](https://github.com/steipete/CodexBar)（装好后 `codexbar` 在 `$PATH` 里）
- 已登录的 Claude Code CLI（拉 Claude 用量）
- 已登录的 Codex CLI（拉 Codex 用量）

## 安装

```bash
git clone https://github.com/XINHAO-ZHANG/cc-usagebar.git
cp cc-usagebar/codexbar.coffee \
  ~/Library/Application\ Support/Übersicht/widgets/
cp -r cc-usagebar/icons \
  ~/Library/Application\ Support/Übersicht/widgets/
```

打开 Übersicht，widget 出现在桌面右上角。

> **小提示**：如果 Übersicht 菜单栏图标看不到，去 **系统设置 → 通用 → 登录项与扩展 → "开机时打开"** 把 `/应用程序/Übersicht.app` 加进去再重启 app。macOS 没把它认作后台 app 之前不会分配菜单栏槽位。

## 自定义

改 `codexbar.coffee` 这几个地方：

| 字段 | 默认值 | 含义 |
|---|---|---|
| `refreshFrequency` | `300000` | 刷新间隔（毫秒，300000 = 5 分钟） |
| `top:` / `right:` | `50px` / `30px` | 位置 |
| `width:` | `280px` | 宽度 |
| `barColor:` | 绿/黄/红 | 颜色阈值（绿 > 50%，黄 20–50%，红 < 20%） |

保存即生效，Übersicht 自动重载。

## 致谢

- [CodexBar](https://github.com/steipete/CodexBar) by [@steipete](https://github.com/steipete) —— 提供 `codexbar` CLI 和这里用到的 SVG 图标
- [Übersicht](https://github.com/felixhageloh/uebersicht) by [@felixhageloh](https://github.com/felixhageloh) —— 桌面 widget 运行时

## 协议

MIT —— 见 [LICENSE](LICENSE)
