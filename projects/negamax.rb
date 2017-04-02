# tic tac toe

# user messages config

require 'yaml'

messages =
  "welcome: Welcome to Tic Tac Toe!
explain_board: |
  In the game board, your pieces will be
     represented with 'O's, and Computer's pieces
     will be represented with 'X's.
explain_moves: |
  Here's how to reference the squares:
     %{m1} (top left)    | %{m2} (top middle)    | %{m3} (top right)
     %{m4} (middle left) | %{m5} (middle middle) | %{m6} (middle right)
     %{m7} (bottom left) | %{m8} (bottom middle) | %{m9} (bottom right)
explain_win: The first player to win %{rounds} rounds wins the game.
please_press_enter: Please press enter to continue.
want_to_have_first_turn?: Would you like to be the first to move? (Y/N)
bye: Good-Bye!
request_move: Please make your choice – %{moves}.
invalid_choice: This is not an available choice.
computer_begins: The computer begins.
user_begins: You begin.
user_chose: You chose %{move}.
computer_chose: Computer chose %{move}.
computer_wins: The computer won.
user_wins: You won.
its_a_tie: This round is a tie.
scores_are: You have won %{user} rounds, computer has won %{computer}.
the_overall_winner_is: We have an overall winner. It's %{winner}.
another_game?: Would you like to play again? (Y/N)"

MESSAGES = YAML.load(messages)

# game config

# move variables
M1 = '1'; M2 = '2'; M3 = '3'
M4 = '4'; M5 = '5'; M6 = '6'
M7 = '7'; M8 = '8'; M9 = '9'

# who makes the first move in the first round? (:user, :computer, :choose)
FIRST_TO_MOVE = :user

# number of round wins to achieve overall win
WINS_TO_WIN_THE_GAME = 5

# game difficulty level
# 1: 'easy',
# 2: 'medium'
# 3: 'impossible to win'
SKILL_LEVEL = 3
# ^ at level 3, program is very *slow* during the first moves

# game mechanics

MOVES = [M1, M2, M3, M4, M5, M6, M7, M8, M9]
CENTER_MOVE = M5

def initialize_board
  board = {}
  MOVES.each { |move| board[move] = false }
  board
end

def available_moves(board)
  MOVES.select { |move| !board[move] }
end

def moves_so_far_of(player, board)
  MOVES.select { |move| board[move] == player }
end

def full?(board)
  available_moves(board) == []
end

def empty?(board)
  available_moves(board) == MOVES
end

def get_move(player, board)
  case player
  when :user then request_user_move(board)
  when :computer then get_computer_move(board)
  end
end

def update(board, move, player)
  case player
  when :computer then board[move] = :computer
  when :user then board[move] = :user
  end
end

def undo(move, board)
  board[move] = false
end

def opponent_of(player)
  case player
  when :computer then :user
  when :user then :computer
  end
end

def winner?(board, player)
  win_strings = %r{
    #{M1}#{M2}#{M3}.*|.*#{M4}#{M5}#{M6}.*|.*#{M7}#{M8}#{M9}|
    #{M1}.*#{M4}.*#{M7}.*|.*#{M2}.*#{M5}.*#{M8}.*|.*#{M3}.*#{M6}.*#{M9}|
    #{M1}.*#{M5}.*#{M9}|.*#{M3}.*#{M5}.*#{M7}.*
  }x
  !!moves_so_far_of(player, board).join.match(win_strings)
end

def done?(board)
  winner?(board, :computer) || winner?(board, :user) || full?(board)
end

# computer moves

def get_computer_move(board)
  sleep 0.5 # computer is thinking

  case SKILL_LEVEL
  when 1
    get_random_move(board)
  when 2
    get_decent_move(board)
  when 3
    get_unbeatable_move(board)
  end
end

def get_random_move(board)
  available_moves(board).sample
end

def get_decent_move(board)
  if threats_for(:user, board) != []
    threats_for(:user, board).sample
  elsif threats_for(:computer, board) != []
    threats_for(:computer, board).sample
  elsif available_moves(board).include?(CENTER_MOVE)
    CENTER_MOVE
  else
    available_moves(board).sample
  end
end

def threats_for(player, board)
  MOVES.select { |move| threat_for?(player, move, board) }
end

def threat_for?(player, move, board)
  if available_moves(board).include?(move)
    update(board, move, opponent_of(player))
    result = winner?(board, opponent_of(player))
    undo(move, board)
    result
  end
end

def get_unbeatable_move(board)
  negamax(board, :computer)[:best_moves].sample
end

def negamax(board, player)
  evaluation = { value_of_board: nil, best_moves: [] }

  if done?(board)
    evaluation[:value_of_board] = result_for(player, board)
  else
    evaluate(board, player, evaluation)
  end

  evaluation
end

def evaluate(board, player, evaluation)
  scores_for_moves = []
  available_moves(board).each do |move|
    update(board, move, player)
    scores_for_moves << -negamax(board, opponent_of(player))[:value_of_board]
    undo(move, board)
  end
  evaluation[:value_of_board] = scores_for_moves.max
  available_moves(board).each_with_index do |move, index|
    if scores_for_moves[index] == evaluation[:value_of_board]
      evaluation[:best_moves] << move
    end
  end
end

def result_for(player, board)
  if winner?(board, player)
    1
  elsif winner?(board, opponent_of(player))
    -1
  elsif full?(board)
    0
  end
end

# user interface

def prompt(message, subst = {})
  message = MESSAGES[message] % subst
  puts "=> #{message}"
end

def welcome_the_user
  prompt('welcome')
  prompt('explain_board')
  prompt(
    'explain_moves',
    {
      m1: M1, m2: M2, m3: M3,
      m4: M4, m5: M5, m6: M6,
      m7: M7, m8: M8, m9: M9
    }
  )
  prompt('explain_win', { rounds: WINS_TO_WIN_THE_GAME })
end

def wait_for_user
  prompt('please_press_enter')
  print '   '
  gets
  sleep 0.1
end

def request_turn_decision
  loop do
    prompt('want_to_have_first_turn?')
    print '   '
    answer = gets.chomp
    case answer.upcase
    when 'Y' then break :user
    when 'N' then break :computer
    else
      prompt('invalid_choice')
    end
  end
end

def display_state(board, scores)
  system 'clear'
  present(scores)
  display(board)
end

def present(scores)
  prompt(
    'scores_are',
    {
      user: scores[:user],
      computer: scores[:computer]
    }
  )
end

def display(board)
  d_board = convert_for_display(board)

  puts
  puts "    #{d_board[M1]} | #{d_board[M2]} | #{d_board[M3]} "
  puts "   -----------"
  puts "    #{d_board[M4]} | #{d_board[M5]} | #{d_board[M6]} "
  puts "   -----------"
  puts "    #{d_board[M7]} | #{d_board[M8]} | #{d_board[M9]} "
  puts
end

def convert_for_display(board)
  display_board = {}
  board.each_key do |key|
    case board[key]
    when false     then display_board[key] = ' '
    when :computer then display_board[key] = 'X'
    when :user     then display_board[key] = 'O'
    end
  end
  display_board
end

def request_user_move(board)
  loop do
    prompt('request_move', { moves: joinor(available_moves(board)) })
    print '   '
    user_move = gets.chomp.upcase
    if available_moves(board).include?(user_move)
      break user_move
    else
      prompt('invalid_choice')
    end
  end
end

def joinor(array, delimiter = ', ', word = 'or')
  case array.size
  when 0 then ''
  when 1 then array.first
  when 2 then array.join(" #{word} ")
  else
    array[-1] = "#{word} #{array.last}"
    array.join(delimiter)
  end
end

def display_choice(player, move)
  case player
  when :computer then prompt('computer_chose', { move: move })
  when :user then prompt('user_chose', { move: move })
  end
end

def announce_winner(player)
  case player
  when :computer then prompt('computer_wins')
  when :user then prompt('user_wins')
  end
end

def announce_overall_winner(player)
  case player
  when :computer
    prompt('the_overall_winner_is', { winner: 'the computer' })
  when :user
    prompt('the_overall_winner_is', { winner: 'you' })
  end
end

def user_wants_to_play_again?
  loop do
    prompt('another_game?')
    print '   '
    answer = gets.chomp
    if answer.upcase == 'Y'
      break true
    elsif answer.upcase == 'N'
      break false
    else
      prompt('invalid_choice')
    end
  end
end

# game loop

loop do
  system 'clear'
  welcome_the_user
  if FIRST_TO_MOVE == :choose
    player = request_turn_decision
  else
    player = FIRST_TO_MOVE
    wait_for_user
  end

  scores = {
    computer: 0,
    user: 0
  }

  loop do
    board = initialize_board
    display_state(board, scores)

    loop do
      move = get_move(player, board)
      update(board, move, player)
      display_state(board, scores)
      display_choice(player, move)

      if winner?(board, player)
        announce_winner(player)
        scores[player] += 1
        break
      elsif full?(board)
        prompt('its_a_tie')
        break
      end

      player = opponent_of(player)
    end

    if scores[player] == WINS_TO_WIN_THE_GAME
      announce_overall_winner(player)
      break
    end
    player = opponent_of(player)

    wait_for_user
  end

  break prompt('bye') unless user_wants_to_play_again?
end
