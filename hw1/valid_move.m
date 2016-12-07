function valid = valid_move(px,py,a)
% Check if an action is valid given the player coordinates.

assert(px >= 0 && py >= 0 && px <= 5 && py <= 4)
assert(1 <=a && a<=5)

if a == 1  % STAY
    valid = true;
elseif a == 2  % UP
    valid = (py > 0) ...
         && ~(py==4 && (px==1 || px==2 || px==3 || px==4)) ...
         && ~(py==2 && (px==4 || px==5));
elseif a == 3  % DOWN
    valid = (py < 4) ...
         && ~(py==3 && (px==1 || px==2 || px==3 || px==4)) ...
         && ~(py==1 && (px==4 || px==5));
elseif a == 4  % LEFT
    valid = (px > 0) ...
        && ~(px==2 && (py==0 || py==1 || py==2)) ...
        && ~(px==4 && (py==1 || py==2 || py==4));
elseif a == 5  % RIGHT
    valid = (px < 5) ...
        && ~(px==1 && (py==0 || py==1 || py==2)) ...
        && ~(px==3 && (py==1 || py==2 || py==4));
end
end
