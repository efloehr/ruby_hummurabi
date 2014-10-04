#!/usr/bin/env ruby

require_relative 'model'
require_relative 'view'
require_relative 'controller'

game = GameModel.new
player = game.player
pview = CountryTextView.new(game,player)
gview = GameTextView.new(game)
gameControl = GameController.new(game, player, gview, pview)
gameControl.playGame

