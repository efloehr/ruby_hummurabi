require_relative 'model'
require_relative 'view'

class GameController

  def initialize(game, player, gameView, playerView)
    @game = game
    @player = player
    @gameView = gameView
    @playerView = playerView
    @playerControl = CountryController.new(@player, @playerView)
  end

  def playGame
    @gameView.startMessage
    loop do
      @playerControl.runTurn
      break unless @game.runTurn
      if @player.impeached then
	@playerView.impeachedMessage(true)
        @playerControl.gameOver = true
      end
      break unless not @playerControl.gameOver
    end
    @playerView.reignEndMessage unless @playerControl.gameOver
  end

end

class CountryController

  attr_accessor :gameOver

  def initialize(model, view)
    @model = model
    @view = view
    @gameOver = false
  end

  def runTurn
    @view.yearBeginMessage
    @view.landPriceMessage
    buyAmount = askBuyLandQuestion unless @gameOver
    if buyAmount == 0 then
      askSellLandQuestion unless @gameOver
    end
    askFeedQuestion unless @gameOver
    askPlantQuestion unless @gameOver
  end

  def askBuyLandQuestion
    begin
      amount = @view.buyLandQuestion
      if amount < 0 then
        @gameOver = true
        @view.resignMessage
      else
        @model.buyLand(amount)
      end

    rescue NotEnoughGrainException
      @view.notEnoughGrainMessage
      retry
    end

    return amount
  end

  def askSellLandQuestion
    begin
      amount = @view.sellLandQuestion
      if amount < 0 then
        @gameOver = true
        @view.resignMessage
      else
        @model.sellLand(amount)
      end

    rescue NotEnoughLandException
      @view.notEnoughLandMessage
      retry
    end

    return amount
  end

  def askFeedQuestion
    begin
      amount = @view.feedQuestion
      if amount < 0 then
        @gameOver = true
        @view.resignMessage
      else
        @model.setGrainToFeed(amount)
      end

    rescue NotEnoughGrainException
      @view.notEnoughGrainMessage
      retry
    end
  end

  def askPlantQuestion
    begin
      amount = @view.plantQuestion
      if amount < 0 then
        @gameOver = true
        @view.resignMessage
      else
        @model.setAcresToPlant(amount)
      end

    rescue NotEnoughLandException
      @view.notEnoughLandMessage
      retry
    rescue NotEnoughPeopleException
      @view.notEnoughPeopleMessage
      retry
    rescue NotEnoughGrainException
      @view.notEnoughGrainMessage
      retry
    end
  end

end
