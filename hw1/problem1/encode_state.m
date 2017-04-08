function s = encode_state(player_row, player_col, minotaur_row, minotaur_col)

player_row = player_row - 1;
player_col = player_col - 1;
minotaur_row = minotaur_row - 1;
minotaur_col = minotaur_col - 1;

s = (player_row*6 + player_col)*30 + minotaur_row*6 + minotaur_col + 1;

end

