require_relative 'model'

class GameTextView

  def initialize(game)
    @game = game
  end

  def startMessage
    puts
    puts " "*16 + "Hammurabi"
    puts "\n"
    puts "Try your hand at governing ancient Sumeria"
    puts "for a " + @game.gameTurns.to_s + "-year term of office."
    puts "\n"
  end

end

class CountryTextView

  def initialize(game,player)
    @game = game
    @player = player
  end

  def yearBeginMessage
      summaryMessage
  end

  def impeachedMessage(stats)
    puts "You starved " + @player.popStarved.to_s + " people in one year!!!" unless not stats
    puts "Due to this extreme mismangement you have not only"
    puts "been impeached and thrown out of office but you have"
    puts "also been declared national fink!!!!"
  end

  def summaryMessage
    puts "\n\n\nHammurabi:  I beg to report to you,"
    puts "in year " + @game.year.to_s + ", " + @player.popStarved.to_s + " people starved, " + @player.popChange.to_s + " came to the city."
    puts "A horrible plague struck!  Half the people died." unless not @player.plague
    puts "Population is now " + @player.population.to_s
    puts "The city now owns " + @player.land.to_s + " acres."
    puts "You harvested " + @player.yield.to_s + " bushels per acre."
    puts "The rats ate " + @player.grainRatsAte.to_s + " bushels."
    puts "You now have " + @player.grain.to_s + " bushels in store."
    puts "\n"
  end

  def reignEndMessage
    summaryMessage
    puts "In your " + @game.gameTurns.to_s + "-year term of office, " + @player.score.round.to_s + " percent of the"
    puts "population starved per year on the average, i.e. a total of"
    puts @player.totalDeaths.to_s + " people died!!"
    puts "You started with " + @player.beginAcresPerPerson.to_s + " acres per person and ended with"
    endAcresPerPerson = (@player.land / @player.population).round
    puts endAcresPerPerson.to_s + " acres per person.\n"
    if (@player.score > 33) or (endAcresPerPerson < 7) then
      impeachedMessage(false)
    elsif (@player.score > 10) or (endAcresPerPerson < 9) then
      puts "Your heavy-handed performance smacks of Nero and Ivan IV."
      puts "The people (remaining) find you an unpleasant ruler, and,"
      puts "frankly, hate your guts!!"
    elsif (@player.score > 3) or (endAcresPerPerson < 10) then
      puts "Your performance could have been somewhat better, but"
      dislike = (@player.population * 0.8 * rand).round
      puts "really wasn't too bad at all. " + dislike.to_s + " people"
      puts "would dearly like to see you assassinated but we all have our"
      puts "trivial problems."
    else
      puts "A fantastic performance!!!  Charlemange, Disraeli, and"
      puts "Jefferson combined could not have done better!"
    end
    endMessage
  end

  def landPriceMessage
    puts "Land is trading at " + @game.landPrice.to_s + " bushels per acre."
  end

  def buyLandQuestion
    puts "How many acres do you wish to buy"
    print "? "
    gets.to_i
  end

  def sellLandQuestion
    puts "How many acres do you wish to sell"
    print "? "
    gets.to_i
  end

  def feedQuestion
    puts "How many bushels do you wish to feed your people"
    print "? "
    gets.to_i
  end

  def plantQuestion
    puts "How many acres do you wish to plant with seed"
    print "? "
    gets.to_i
  end

  def notEnoughPeopleMessage
    puts "But you have only " + @player.population.to_s + " people to tend the fields!  Now then,"
  end

  def notEnoughLandMessage
    puts "Hammurabi:  Think again.  You own only " + @player.land.to_s + " acres.  Now then,"
  end

  def notEnoughGrainMessage
    puts "Hammurabi:  Think again.  You have only"
    puts @player.grain.to_s + " bushels of grain.  Now then,"
  end

  def endMessage
    puts "So long for now."
  end

  def resignMessage
    puts "Hammurabi:  I cannot do what you wish."
    puts "Get yourself another steward!!!!!"
    endMessage
  end
end
    
