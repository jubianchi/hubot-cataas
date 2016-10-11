chai = require "chai"
sinon = require "sinon"

chai.use require "sinon-chai"
expect = chai.expect

describe "cataas", ->
  describe "helpers", ->
    beforeEach ->
      @robot =
        respond: sinon.spy()

      @cataas = require("../src/cataas")(@robot)

    it "generates a random hash", ->
      expect(@cataas.hash())
        .to.have.lengthOf(10)
        .to.match(/^[a-z0-9]+$/)

    describe "replace", ->
      it "replaces arguments", ->
        expect(@cataas.replace("{1} {2}", "foo", "bar")).to.equal("foo bar")

      it "does not replace missing arguments", ->
        expect(@cataas.replace("{0} {1} {2} {3}", "foo", "bar"))
          .to.equal("{0} foo bar {3}")

    describe "URL", ->
      beforeEach -> @cataas.hash = -> "randomHash"

      it "generates the base URL", ->
        expect(@cataas.url()).to.equal("http://cataas.com/cat#randomHash")

      it "generates the other URLs", ->
        expect(@cataas.url("/says"))
            .to.equal("http://cataas.com/cat/says#randomHash")

      it "generates the URLs with encoded parameters", ->
        expect(@cataas.url("/says/{1}", "Hello Cats"))
            .to.equal("http://cataas.com/cat/says/Hello%20Cats#randomHash")

    describe "repeat", ->
      it "executes callback five times", ->
        callback = sinon.spy()

        @cataas.repeat(null, callback)

        expect(callback).to.have.callCount(5)

      it "executes callback five times if parameters is invalid", ->
        callback = sinon.spy()

        @cataas.repeat(NaN, callback)

        expect(callback).to.have.callCount(5)

      it "executes callback N times", ->
        callback = sinon.spy()

        @cataas.repeat(2, callback)

        expect(callback).to.have.callCount(2)

  describe "adds handler", ->
    beforeEach ->
      @robot =
        respond: sinon.spy()

      require("../src/cataas")(@robot)

    it "responds to the 'cat me' command", ->
      expect(@robot.respond).to.have.been.calledWith(/cat me/i)

    it "responds to the 'cat bomb [me] <number>' command", ->
      expect(@robot.respond).to.have.been.calledWith(/cat bomb(?: me| (\d+))?/i)

    it "responds to the '<filter> cat me' command", ->
      expect(@robot.respond).to.have.been.calledWith(/(.+) cat me/i)

    it "responds to the '<filter> cat bomb [me] <number>' command", ->
      expect(@robot.respond)
        .to.have.been.calledWith(/(.+) cat bomb(?: me| (\d*))?/i)

    it "responds to the 'cat animate me' command", ->
      expect(@robot.respond).to.have.been.calledWith(/cat animate me/i)

    it "responds to the 'cat animate bomb [me] <number>' command", ->
      expect(@robot.respond).to.have.been
        .calledWith(/cat animate bomb(?: me| (\d*))?/i)

    it "responds to the 'cat says me <text>' command", ->
      expect(@robot.respond).to.have.been.calledWith(/cat says? me (.+)/i)

    it "responds to the '<filter> cat says me <text>' command", ->
      expect(@robot.respond).to.have.been.calledWith(/(.+) cat says? me (.+)/i)

  describe "robot", ->
    beforeEach ->
      { Robot, User, TextMessage } = require "hubot"

      @robot = new Robot null, "shell", false, "hubot"
      @user = new User "cataas"
      @message = new TextMessage @user
      @env =
        message: @message
        room: @message.room
        user: @user
      cataas = require("../src/cataas")(@robot)

      @robot.adapter.send = sinon.spy()
      cataas.hash = -> "randomHash"

    it "responds to the 'cat me' command", (done) ->
      @message.text = "hubot cat me"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been.calledWith(@env, "http://cataas.com/cat#randomHash")

          done()
        catch e
          done e

    it "responds to the 'cat bomb [me]' command", (done) ->
      @message.text = "hubot cat bomb me"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.callCount(5)
            .to.have.been.calledWith(@env, "http://cataas.com/cat#randomHash")

          done()
        catch e
          done e

    it "responds to the 'cat bomb <number>' command", (done) ->
      @message.text = "hubot cat bomb 10"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.callCount(10)
            .to.have.been.calledWith(@env, "http://cataas.com/cat#randomHash")

          done()
        catch e
          done e

    it "responds to the '<filter> cat me' command", (done) ->
      @message.text = "hubot cute cat me"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .calledWith(@env, "http://cataas.com/cat/cute#randomHash")

          done()
        catch e
          done e

    it "responds to the '<filter> cat bomb [me]' command", (done) ->
      @message.text = "hubot cute cat bomb me"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .to.have.callCount(5)
              .calledWith(@env, "http://cataas.com/cat/cute#randomHash")

          done()
        catch e
          done e

    it "responds to the '<filter> cat bomb <number>' command", (done) ->
      @message.text = "hubot cute cat bomb 10"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .to.have.callCount(10)
              .calledWith(@env, "http://cataas.com/cat/cute#randomHash")

          done()
        catch e
          done e

    it "responds to the 'cat animate me' command", (done) ->
      @message.text = "hubot cat animate me"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .calledWith(@env, "http://cataas.com/cat/gif#randomHash")

          done()
        catch e
          done e

    it "responds to the 'cat animate bomb [me]' command", (done) ->
      @message.text = "hubot cat animate bomb me"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .to.have.callCount(5)
              .calledWith(@env, "http://cataas.com/cat/gif#randomHash")

          done()
        catch e
          done e

    it "responds to the 'cat animate bomb <number>' command", (done) ->
      @message.text = "hubot cat animate bomb 10"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .to.have.callCount(10)
              .calledWith(@env, "http://cataas.com/cat/gif#randomHash")

          done()
        catch e
          done e

    it "responds to the 'cat says me <text>' command", (done) ->
      @message.text = "hubot cat says me hello World"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .calledWith(
                @env,
                "http://cataas.com/cat/says/hello%20World#randomHash"
              )

          done()
        catch e
          done e

    it "responds to the '<filter> cat says me <text>' command", (done) ->
      @message.text = "hubot weird cat says me hello World"

      @robot.receive @message, =>
        try
          expect(@robot.adapter.send)
            .to.have.been
              .calledWith(
                @env,
                "http://cataas.com/cat/weird/says/hello%20World#randomHash"
              )

          done()
        catch e
          done e
