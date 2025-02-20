% Author: Qingwei Liang 
% Email:  liangqw@sdust.edu.cn 
% This file is used for hierarchical differential grouping 
% to decompose the CEC'2013 benchmark functions.

% Note that Hierarchy 4 is not included here. This is because 
% Hierarchy 4 further decomposes subcomponents with dimensions over 100. 
% It does not match the standard result of decomposition, but it is 
% beneficial for optimization.

clear all;

func = 1:15;
for func_num = 1:15
    t1 = [13 14];
    t2 = [1 4 7 8 11 12 15];
    t3 = [2 5 9];
    disp(func_num);
    if (ismember(func_num, t1))
        D=905;
        lb=-100*ones(1,D);
        ub=100*ones(1,D);
    elseif (ismember(func_num, t2))
        D=1000;
        lb=-100*ones(1,D);
        ub=100*ones(1,D);
    elseif (ismember(func_num, t3))
        D=1000;
        lb=-5*ones(1,D);
        ub=5*ones(1,D);
    else
        D=1000;
        lb=-32*ones(1,D);
        ub=32*ones(1,D);
    end
        
    addpath('cec2013');
    addpath('cec2013/datafiles');
    global initial_flag;
    initial_flag = 0;

    [seps, group, FES] = HDG('benchmark_func',lb,ub,func_num);
    filename = sprintf('./results2013_noH4_test/F%02d', func_num);
    save (filename, 'seps', 'group', 'FES', '-v7');
end

