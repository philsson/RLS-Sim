global pid_data;
pid_data = struct(... %alt |   p_x | p_y | v_x |  v_y |  a_roll | a_pitch | compass | g_roll | g_pitch | g_yaw
    'Kp',             {0.3,    2.5,  2.5,  1.0,   1.0,   2.2,     2.2,      5,        0.002,  0.0025,   0.05},...
    'Ki',             {0.1,    0,    0,    0,     0,     0,       0,        0,        0.0001,  0.0001,   0.004},...
    'Kd',             {0.3,    4,    4,    2,     2,     0,       0,        0,        0.00004,  0.0001,   0.00051},...
    'integral',       {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'i_max',          {100,    100,  100,  100,   100,   100,     100,      100,      100,     100,      100},...
    'e',              {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'prev_e',         {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'saturation',     {3,      2,    2,    25,    25,    50,      50,       90,       1.5,       1.5,        1.5},...
    'filter',         {ASF,     ASF,    ASF,    ASF,    ASF,    ASF,     ASF,      ASF,      ASF,     ASF,      ASF});

% P 0.0013
% I 0.0001
% D 0.000021

% TD 0.0769

pid_data_V2 = struct(...
    'Kp_evo',           {0, 0, 0},...
    'K',                {0.002, 0.0025, 0.05},...
    'Ti',               {13, 25, 12.5},...
    'Td',               {0.0384, 0.04, 0.0102},...
    'integral',         {0, 0, 0},...
    'i_max',            {10,10,10},...
    'e',                {0, 0, 0},...
    'prev_e',           {0, 0, 0},...
    'saturation',       {1.5, 1.5, 1.5},...
    'prev_Ud',          {0, 0, 0},...
    'P',                {0, 0, 0},...
    'I',                {0, 0, 0},...
    'D',                {0, 0, 0});
