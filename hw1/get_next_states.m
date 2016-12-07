function next_states = get_next_states(s,a)
% Get the posiible next states of the maze
% given the current state and an action.
[p_state, m_state] = decode_(s);

next_p_state = get_next_p_state(p_state,a);     % returns one value
next_m_state = get_next_m_state(m_state);       % returns a vector

num_next_states = size(next_m_state, 1);

next_states = zeros(num_next_states, 1);
for i = 1:num_next_states
    next_states(i) = encode_(next_p_state, next_m_state(i));
end
end

function next_p_state = get_next_p_state(p_state, a)
% Return the next player state given state and action.
% If the given action is not valid, the current state is returned.
[px,py] = coords(p_state);
if (valid_move(px,py,a))
    switch a
        case 1  % STAY
             % do nothing
        case 2  % UP
            py = py - 1;
        case 3  % DOWN
            py = py + 1;
        case 4  % LEFT
            px = px - 1;
        case 5  % RIGHT
            px = px + 1;
        otherwise
            % shouldn't be here
            disp('we shouldnt be here!!')
    end
end
next_p_state = py * 6 + px;
end

function next_m_state = get_next_m_state(m_state)
% Return the next minotaur states.
[mx,my] = coords(m_state);
next_m_state = [];
if (mx > 0) 
    next_m_state = [next_m_state; state(mx-1,my)]; 
end
if (mx < 5) 
    next_m_state = [next_m_state; state(mx+1,my)]; 
end
if (my > 0)  % the minotaur can move left
    next_m_state = [next_m_state; state(mx,my-1)]; 
end
if (my < 4)  % the minotaur can move right
    next_m_state = [next_m_state; state(mx,my+1)];
end
end

function [x,y] = coords(state)
    x = mod(state, 6);
    y = floor(state / 6);
end

function state = state(x,y)
    state = (y*6) + x;
end

function [p_state, m_state] = decode_(state)
% Decode given state into player state and minotaur state
p_state = floor(state / 30);
m_state = mod(state, 30);
end

function state = encode_(p_state, m_state)
state = (p_state * 30) + m_state;
end

