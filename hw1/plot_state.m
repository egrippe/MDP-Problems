function plot_state(state)
Plot the state of the maze
for i = 1:size(state,1)
    if state(i)==901 
        continue 
    end
    num_plots = size(state,1);
    subplot(ceil(sqrt(num_plots)),ceil(sqrt(num_plots)),i)
    [px,py,mx,my] = decode(state(i)-1);
    axis([0 6 0 5])
    set(gca,'xtick',0:6)
    set(gca,'ytick',0:5)
    set(gca,'Ydir','reverse')
    set(gca,'XtickLabel',[],'YtickLabel',[]);
    hold on
    grid on

    rectangle('Position', [px py 1 1], 'facecolor', 'g');
    rectangle('Position', [mx my 1 1], 'facecolor', 'r');

    plot the walls of the maze
    x = [2 1 4 4 4;
         2 5 4 6 4];
    y = [0 4 1 2 4;
         3 4 3 2 5];
    plot(x,y,'black','LineWidth',4)
    title(['T=',num2str(i)])
end
end

