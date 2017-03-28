
logX = log(1);
logY = log(2);
logZ = log(3);

save(plotfileX,'-struct','logX');
save(plotfileY,'-struct','logY');
save(plotfileZ,'-struct','logZ');
disp('Log file saved')