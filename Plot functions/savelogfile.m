function [ ] = savelogfile( log, name )

pathx = ['/Results/' name 'X.mat'];
pathy = ['/Results/' name 'Y.mat'];
pathz = ['/Results/' name 'Z.mat'];

plotfileX = [pwd, pathx]; 
plotfileY = [pwd, pathy];
plotfileZ = [pwd, pathz];

logX = log(1);
logY = log(2);
logZ = log(3);

save(plotfileX,'-struct','logX');
save(plotfileY,'-struct','logY');
save(plotfileZ,'-struct','logZ');

disp(['Log data saved as' name]);

end

