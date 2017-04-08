function [t_s, p_s, t_x, t_y, p_x, p_y] = decode(s)
t_s = floor((s-1) / 18) + 1;
p_s = mod((s-1), 18) + 1;
t_x = mod((t_s-1), 6) + 1;
t_y = floor((t_s-1) / 6) + 1;
p_x = mod((p_s-1), 6) + 1;
p_y = floor((p_s-1) / 6) + 1;
end

