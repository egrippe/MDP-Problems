function [px,py,mx,my] = decode(code)
% Decode into player and minotaur
px = mod(floor(code / 30), 6);
py = floor(floor(code / 30) / 6);

mx = mod(mod(code, 30), 6);
my = floor(mod(code, 30) / 6);
end
