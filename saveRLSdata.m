

disp('Saving data to file')

if ~use_philips_rls
    for i=1:3
        rls_data(i).V = ones(2,2)*1;
        rls_data(i).fi = rls_data(i).fi*0;
        rls_data(i).error = 0;
        rls_data(i).RlsOut = 0;
    end
end
    
if save_RLS_data(1)
    rls_data_X = rls_data(1);
    save(rlsfileX,'-struct','rls_data_X');
    clear rls_data_X;
    disp('Data saved for x-axis')
end
if save_RLS_data(2)
    rls_data_Y = rls_data(2);
    save(rlsfileY,'-struct','rls_data_Y');
    clear rls_data_Y;
    disp('Data saved for y-axis')
end
if save_RLS_data(3)
    rls_data_Z = rls_data(3);
    save(rlsfileZ,'-struct','rls_data_Z');
    clear rls_data_Z;
    disp('Data saved for z-axis')        
end