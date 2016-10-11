# Description:
#   A script to interact with CATAAS and send cats everywhere
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

  hash = () -> Math.random().toString(36).substring(7)

  url = (url) -> "#{url}##{hash()}"

  robot.hear /cat me/i, (msg) ->
    msg.send url "http://cataas.com/cat"

  robot.hear /cat bomb(?: me| (\d*))?/i, (msg) ->
    howMany = msg.match[1] or 5

    while (howMany > 0)
      msg.send url "http://cataas.com/cat"
      --howMany

  robot.respond /(.+) cat me/i, (msg) ->
    filter = msg.match[1]

    msg.send url "http://cataas.com/cat/#{encodeURI(filter)}"

  robot.respond /(.+) cat bomb(?: me| (\d*))?/i, (msg) ->
    filter = msg.match[1]
    howMany = msg.match[2] or 5

    while (howMany > 0)
      msg.send url "http://cataas.com/cat/#{encodeURI(filter)}"
      --howMany

  robot.hear /cat animate me/i, (msg) ->
    msg.send url "http://cataas.com/cat/gif"

  robot.hear /cat animate bomb(?: me| (\d*))?/i, (msg) ->
    howMany = msg.match[1] or 5

    while (howMany > 0)
      msg.send url "http://cataas.com/cat/gif"
      --howMany

  robot.hear /cat says? me (.+)/, (msg) ->
    text = msg.match[1]

    msg.send url "http://cataas.com/cat/says/#{text}"

  robot.hear /(.+) cat says? me (.+)/, (msg) ->
    filter = msg.match[1]
    text = msg.match[2]

    msg.send url "http://cataas.com/cat/#{filter}/says/#{text}"
