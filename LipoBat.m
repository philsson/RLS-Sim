

capacity = [8.4     7.25    7.1     7.0    6.9 6.85 6.8 6.75    6.65  6.6 6.5 6.4 6.3 5.8 5.5]/8.4;
    time = [0       0.5     1       1.5     2   2.5 3    3.5    5.5   7   11  14 15   16 17]/17;


bat_polynome = polyfit(time,capacity,5);

x1 = linspace(0,1);
y1 = polyval(bat_polynome,x1);
%%figure
%%plot(time,capacity,'o')
%%hold on
%%plot(time,capacity)
%%plot(x1,y1)
%%hold off