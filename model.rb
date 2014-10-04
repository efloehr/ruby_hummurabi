class NotEnoughGrainException < RuntimeError
end

class NotEnoughLandException < RuntimeError
end

class NotEnoughPeopleException < RuntimeError
end

class CountryModel

  @@acresTendedPerPerson = 10
  @@acresPerGrain = 2

  attr_reader :population, :grain, :land
  attr_reader :grainToFeed, :acresToPlant
  attr_reader :yield, :bushelsHarvested, :popChange, :grainRatsAte, :plague,
              :popStarved, :impeached
  attr_reader :score, :totalDeaths, :beginAcresPerPerson

  def initialize(gameModel)
    @population = 100
    @grain = 2800
    @land = 1000
    @grainToFeed = @acresToPlant = 0
    @yield = 3
    @bushelsHarvested = 3000
    @popChange = 5
    @grainRatsAte = 200
    @plague = @impeached = false
    @popStarved = 0
    @score = @totalDeaths = 0
    @game = gameModel
    @beginAcresPerPerson = (@land / @population).round
  end

  def setGrainToFeed(amount)
    raise NotEnoughGrainException unless amount <= @grain

    @grainToFeed = amount
  end

  def setAcresToPlant(amount)
    raise NotEnoughLandException unless amount <= @land
    raise NotEnoughPeopleException unless amount <= @@acresTendedPerPerson * @population
    raise NotEnoughGrainException unless amount/@@acresPerGrain <= @grain
	
    @acresToPlant = amount
  end

  def sellLand(amount)
    raise NotEnoughLandException unless amount < @land
    @land -= amount
    @grain += amount * @game.landPrice
  end

  def buyLand(amount)
    raise NotEnoughGrainException unless amount * @game.landPrice <= @grain
    @grain -= amount * @game.landPrice
    @land += amount
  end

  def runTurn
    # Calculate yield and harvest
    @yield = rand(5) + 1
    @bushelsHarvested = @yield * @acresToPlant

    # Calculate how much rats ate
    rats = (rand(5) + 1)
    if (rats/2.0) == (rats/2)
      @grainRatsAte = (@grain / rats).round
    else
      @grainRatsAte = 0
    end

    # Put grain in the storehouse
    @grain = @grain + @bushelsHarvested - @grainRatsAte

    # Calculate population change
    @popChange = ((rand(5)+1) * (20.0*@land+@grain) / @population / 100.0 + 1).round

    # How many starved?
    fullTummies = (@grainToFeed / 20.0).round
    
    if @population >= fullTummies
      # Starve enough for impeachment?
      @popStarved = @population - fullTummies
      if @popStarved * 100 / @population > 45
	@impeached = true
      end

      # Update deaths and score
      @totalDeaths += @popStarved
      @score = (((@game.year-1)*@score+@popStarved*100.0/@population)/@game.year)
    end

    @population = @population - @popStarved + @popChange

    # See if there is a plague
    if (rand() < 0.15)
      @plague = true
      @population = @population / 2
    else
      @plague = false
    end

  end

end

class GameModel

  attr_reader :gameTurns
  attr_reader :gameTurns, :year, :landPrice, :player

  def initialize
    @year = 1
    setLandPrice
    @player = CountryModel.new(self)
    @gameTurns = 10
  end

  def runTurn
    @year += 1
    setLandPrice
    return false unless @year <= @gameTurns
    player.runTurn
    return true
  end

  def setLandPrice
    @landPrice = rand(10).floor + 17
  end
end
