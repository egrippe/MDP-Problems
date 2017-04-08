function [player_row, player_col, minotaur_row, minotaur_col] = decode_state(s)
% decode state number into the position of player and minotaur

player_row = floor(floor((s-1) / 30) / 6) + 1;
player_col = mod(floor((s-1) / 30), 6) + 1;

minotaur_row = floor(mod((s-1), 30) / 6) + 1;
minotaur_col = mod(mod((s-1), 30), 6) + 1;
end

