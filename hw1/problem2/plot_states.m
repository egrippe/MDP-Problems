function plot_states(state_vec)
% Plot the state of the maze
for i = 1:size(state_vec,1)
    num_plots = size(state_vec,1);
    subplot(ceil(sqrt(num_plots)),ceil(sqrt(num_plots)),i)
    [~,~,px,py,mx,my] = decode(state_vec(i));
    axis([0 6 0 3])
    set(gca,'xtick',0:6)
    set(gca,'ytick',0:3)
    set(gca,'Ydir','reverse')
    set(gca,'XtickLabel',[],'YtickLabel',[]);
    hold on
    grid on

    rectangle('Position', [px-1 py-1 1 1], 'facecolor', 'g');
    rectangle('Position', [mx-1 my-1 1 1], 'facecolor', 'r');

    % plot the walls of the maze
    title(['T=',num2str(i)])
end
end