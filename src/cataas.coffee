# Description:
#   A script to interact with CATAAS and send cats everywhere
#
# Configuration
#   HUBOT_CATAAS_BASE_URL: Optional. Allows you to specify the base URL for the CATAAS API.
#
# Commands:
#   hubot cat me - Shows a random cat image
#   hubot cat bomb [me] - Shows five random cats
#   hubot cat bomb [me] <number> - Shows <number> random cats
#   hubot <filter> cat me - Shows a random <filter> cat
#   hubot <filter> cat bomb [me] - Shows five random <filter> cats
#   hubot <filter> cat bomb <number> - Shows <number> random <filter> cats
#   hubot cat animate me - Shows a random animated cat
#   hubot cat animate bomb [me] - Shows five random animated cats
#   hubot cat animate bomb <number> - Shows <number> random animated cats
#   hubot cat says me <text> - Shows a random cat saying <text>
#   hubot <filter> cat says me <text> - Shows a random <filter> cat saying <text>

module.exports = (robot) ->
  @hash = ->
    Math.random().toString(36).substring(2, 12)

  @url = (url = '', args...) =>
    base = process.env.HUBOT_CATAAS_BASE_URL or "http://cataas.com"
    args = args.map (arg) -> encodeURI(arg)

    "#{base.replace(/\/$/, '')}/cat#{@replace(url, args...)}##{@hash()}"

  @repeat = (times, code) ->
    times = parseInt(times, 10) || 5

    while times > 0
      code()
      times--

  @replace = (string, args...) ->
    string.replace /{(\d+)}/g, (match, number) ->
      return args[number - 1] if number > 0 && number - 1 < args.length

      match

  commands = [
    [/cat me/i, (msg) => msg.send @url()],
    [
      /cat bomb(?: me| (\d+))?/i,
      (msg) => @repeat msg.match[1], => msg.send @url()
    ],
    [/(.+) cat me/i, (msg) => msg.send @url "/{1}", msg.match[1]],
    [
      /(.+) cat bomb(?: me| (\d*))?/i,
      (msg) => @repeat msg.match[2], => msg.send @url "/{1}", msg.match[1]
    ],
    [/cat animate me/i, (msg) => msg.send @url "/gif"],
    [
      /cat animate bomb(?: me| (\d*))?/i,
      (msg) => @repeat msg.match[1], => msg.send @url "/gif"
    ],
    [/cat says? me (.+)/i, (msg) => msg.send @url "/says/{1}", msg.match[1]],
    [
      /(.+) cat says? me (.+)/i,
      (msg) => msg.send @url "/{1}/says/{2}", msg.match[1], msg.match[2]
    ]
  ]

  robot.respond command, handler for _, [command, handler] of commands

  @
