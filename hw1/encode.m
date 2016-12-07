function code = encode(px, py, mx, my)
% Encode a state of the maze.
code = (py*6 + px) * 30 ...
     + (my*6 + mx);
end

