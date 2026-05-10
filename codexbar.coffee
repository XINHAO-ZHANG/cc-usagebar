command: "bash '#{process.env.HOME}/Library/Application Support/Übersicht/widgets/usage.sh'"

refreshFrequency: 60000

PROVIDER_LABEL:
  codex: 'Codex'
  claude: 'Claude'
  copilot: 'Copilot'

prettyPlan: (loginMethod) ->
  return null unless loginMethod
  loginMethod.charAt(0).toUpperCase() + loginMethod.slice(1)

formatRemaining: (isoString) ->
  return null unless isoString
  diffSec = (new Date(isoString) - new Date()) / 1000
  return 'now' if diffSec < 60
  d = Math.floor(diffSec / 86400)
  h = Math.floor((diffSec % 86400) / 3600)
  m = Math.floor((diffSec % 3600) / 60)
  if d > 0 then "#{d}d #{h}h"
  else if h > 0 then "#{h}h #{m}m"
  else "#{m}m"

barColor: (remainPct) ->
  return '#888' unless remainPct?
  if remainPct > 50 then '#22c55e'
  else if remainPct > 20 then '#f59e0b'
  else '#ef4444'

parseSources: (output) ->
  [codexbarRaw, ccusageRaw] = output.split('---CCUSAGE---')
  codexbarData = []
  ccusageBlock = null
  try
    codexbarData = JSON.parse(codexbarRaw ? '[]')
    codexbarData = [] unless Array.isArray(codexbarData)
  catch
    codexbarData = []
  try
    cc = JSON.parse(ccusageRaw ? '{}')
    blocks = cc?.blocks ? []
    ccusageBlock = (b for b in blocks when b.isActive)[0] ? null
  catch
    ccusageBlock = null
  { codexbarData, ccusageBlock }

parseProviders: (output) ->
  { codexbarData, ccusageBlock } = @parseSources(output)
  for p in codexbarData
    id = p.provider
    u = p.usage ? {}
    primary = u.primary ? {}
    secondary = u.secondary ? {}
    sessionRemain = if primary.usedPercent? then 100 - primary.usedPercent else null
    weeklyRemain  = if secondary.usedPercent? then 100 - secondary.usedPercent else null

    sessionReset = primary.resetsAt
    if id is 'claude' and not sessionReset and ccusageBlock
      sessionReset = ccusageBlock.endTime

    {
      id: id
      name: @PROVIDER_LABEL[id] ? id
      plan: @prettyPlan(u.loginMethod)
      sessionRemain: sessionRemain
      weeklyRemain: weeklyRemain
      sessionReset: sessionReset
      weeklyReset: secondary.resetsAt
    }

renderRow: (label, remainPct, resetISO) ->
  pctTxt = if remainPct? then "#{remainPct}%" else '—'
  resetTxt = @formatRemaining(resetISO) ? '—'
  color = @barColor(remainPct)
  width = remainPct ? 0
  """
    <div class='row'>
      <div class='lbl'>#{label}</div>
      <div class='bar'><div class='fill' style='width:#{width}%;background:#{color}'></div></div>
      <div class='pct'>#{pctTxt}</div>
    </div>
    <div class='reset-row'>
      <div class='lbl'></div>
      <div class='reset'>resets in #{resetTxt}</div>
    </div>
  """

render: (output) ->
  providers = @parseProviders(output)
  if providers.length is 0
    return "<div class='header'>AI USAGE</div><div class='empty'>No data</div>"

  rows = ''
  for p in providers
    iconSlug = p.id
    planTxt = if p.plan then " · #{p.plan}" else ''
    rows += """
      <div class='p'>
        <div class='name'><img class='icon' src='icons/#{iconSlug}.svg'/>#{p.name}#{planTxt}</div>
        #{@renderRow('session', p.sessionRemain, p.sessionReset)}
        #{@renderRow('weekly', p.weeklyRemain, p.weeklyReset)}
      </div>
    """
  "<div class='header'>AI USAGE</div>#{rows}"

style: """
  top: 50px
  right: 30px
  width: 290px
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif
  color: rgba(255, 255, 255, 0.95)
  background: rgba(20, 20, 22, 0.65)
  -webkit-backdrop-filter: blur(40px) saturate(180%)
  backdrop-filter: blur(40px) saturate(180%)
  border: 1px solid rgba(255, 255, 255, 0.08)
  border-radius: 14px
  padding: 16px 18px
  font-size: 12px
  z-index: 0
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3)

  .header
    font-size: 10px
    font-weight: 700
    letter-spacing: 1.5px
    opacity: 0.5
    margin-bottom: 12px

  .empty
    opacity: 0.5
    font-size: 11px

  .p
    margin-bottom: 14px

    &:last-child
      margin-bottom: 0

  .name
    font-size: 13px
    font-weight: 600
    margin-bottom: 8px
    display: flex
    align-items: center
    gap: 7px

  .icon
    width: 16px
    height: 16px
    flex-shrink: 0
    opacity: 0.95

  .row
    display: flex
    align-items: center
    gap: 8px
    margin-bottom: 2px

  .reset-row
    display: flex
    align-items: center
    gap: 8px
    margin-bottom: 6px

  .lbl
    width: 50px
    font-size: 9px
    opacity: 0.5
    text-transform: uppercase
    letter-spacing: 0.6px
    flex-shrink: 0

  .bar
    flex: 1
    height: 5px
    background: rgba(255, 255, 255, 0.1)
    border-radius: 3px
    overflow: hidden

  .fill
    height: 100%
    border-radius: 3px
    transition: width 0.4s ease

  .pct
    width: 38px
    text-align: right
    font-size: 11px
    font-weight: 500
    font-variant-numeric: tabular-nums

  .reset
    font-size: 10px
    opacity: 0.5
    font-variant-numeric: tabular-nums
"""
