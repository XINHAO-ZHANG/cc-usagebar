command: "PATH=/usr/local/bin:/opt/homebrew/bin:$PATH codexbar usage 2>&1"

refreshFrequency: 300000

parseProviders: (output) ->
  providers = []
  current = null
  for line in output.split('\n')
    if m = line.match(/^== (\w+)/)
      current = name: m[1], session: null, weekly: null, reset: null, plan: null
      providers.push(current)
    else if current and m = line.match(/^Session:\s+(\d+)%/)
      current.session = parseInt(m[1])
    else if current and m = line.match(/^Weekly:\s+(\d+)%/)
      current.weekly = parseInt(m[1])
    else if current and m = line.match(/^Resets in (.+)/)
      current.reset = m[1] unless current.reset
    else if current and m = line.match(/^Plan:\s+(.+)/)
      current.plan = m[1]
  providers

barColor: (pct) ->
  return '#888' unless pct?
  if pct > 50 then '#22c55e'
  else if pct > 20 then '#f59e0b'
  else '#ef4444'

render: (output) ->
  providers = @parseProviders(output)
  if providers.length is 0
    return "<div class='header'>AI USAGE</div><div class='empty'>No data</div>"

  rows = ''
  for p in providers
    sCol = @barColor(p.session)
    wCol = @barColor(p.weekly)
    sPct = if p.session? then p.session else 0
    wPct = if p.weekly? then p.weekly else 0
    sTxt = if p.session? then "#{p.session}%" else '—'
    wTxt = if p.weekly? then "#{p.weekly}%" else '—'
    planTxt = if p.plan then " · #{p.plan}" else ''
    resetHTML = if p.reset then "<div class='reset'>resets in #{p.reset}</div>" else ''
    iconSlug = p.name.toLowerCase()
    rows += """
      <div class='p'>
        <div class='name'><img class='icon' src='icons/#{iconSlug}.svg'/>#{p.name}#{planTxt}</div>
        <div class='row'>
          <div class='lbl'>session</div>
          <div class='bar'><div class='fill' style='width:#{sPct}%;background:#{sCol}'></div></div>
          <div class='pct'>#{sTxt}</div>
        </div>
        <div class='row'>
          <div class='lbl'>weekly</div>
          <div class='bar'><div class='fill' style='width:#{wPct}%;background:#{wCol}'></div></div>
          <div class='pct'>#{wTxt}</div>
        </div>
        #{resetHTML}
      </div>
    """
  "<div class='header'>AI USAGE</div>#{rows}"

style: """
  top: 50px
  right: 30px
  width: 280px
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
    margin-bottom: 6px
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
    margin-bottom: 4px

  .lbl
    width: 50px
    font-size: 9px
    opacity: 0.5
    text-transform: uppercase
    letter-spacing: 0.6px

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
    opacity: 0.55
    margin-top: 4px
    padding-left: 58px
"""
