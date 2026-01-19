require_relative '../app/tic_tac_toe'

game = TicTacToe.new
tree = DecisionTree.new
ai = Minimax.new(tree)

puts "Welcome to Tic-Tac-Toe! \n\n You are O and the AI is X"
game.print_board

until game.game_over?
  if game.current_player == :X
    move = ai.best_move(game.board)
    game.make_move(move)
    puts "\nAI played at position #{move}:"
  else
    print "\nChoose a position (0–8): "
    input = gets.chomp
    unless input =~ /^\d$/ && game.make_move(input.to_i)
      puts "Invalid move. Try again."
      next
    end
  end

  game.print_board
end

puts "\nGame over!"

case game.winner
when :X then puts "\nAI wins!"
when :O then puts "\nYou win!"
else        puts "\nIt's a draw!"
end