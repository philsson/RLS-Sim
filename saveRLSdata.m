

disp('Saving data to file')

if save_RLS_data(1)
    rls_data_X = rls_data(1);
    save(rlsfileX,'-struct','rls_data_X');
    clear rls_data_X;
end
if save_RLS_data(2)
    rls_data_Y = rls_data(2);
    save(rlsfileY,'-struct','rls_data_Y');
    clear rls_data_Y;
end
if save_RLS_data(3)
    rls_data_Z = rls_data(3);
    save(rlsfileZ,'-struct','rls_data_Z');
    clear rls_data_Z;
end