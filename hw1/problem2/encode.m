function [s] = encode(t_x, t_y, p_x, p_y)
assert(t_x >= 1 && t_x <= 6)
assert(t_y >= 1 && t_y <= 3)
assert(p_x >= 1 && p_x <= 6)
assert(p_y >= 1 && p_y <= 3)
t_s = (t_y-1)*6 + (t_x-1);
p_s = (p_y-1)*6 + (p_x-1);
s = t_s*18 + p_s + 1;
end

