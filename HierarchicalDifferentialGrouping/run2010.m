% Author: Qingwei Liang 
% Email:  liangqw@sdust.edu.cn 
% This file is used for hierarchical differential grouping 
% to decompose the CEC'2010 benchmark functions.

% Note that Hierarchy 4 is not included here. This is because 
% Hierarchy 4 further decomposes subcomponents with dimensions over 100. 
% It does not match the standard result of decomposition, but it is 
% beneficial for optimization.


clear all;
func=1:20;

for func_num=1:20
    t1 = [1 4 7 8 9 12 13 14 17 18 19 20];
    t2 = [2 5 10 15];
    t3 = [3 6 11 16];
    D=1000;
    if (ismember(func_num, t1))
        lb=-100*ones(1,D);
        ub=100*ones(1,D);
    elseif (ismember(func_num, t2))
        lb=-5*ones(1,D);
        ub=5*ones(1,D);
    elseif (ismember(func_num, t3))
        lb=-32*ones(1,D);
        ub=32*ones(1,D);
    end

    addpath('cec2010');
    addpath('cec2010/datafiles');
    global initial_flag;
    initial_flag = 0;
    
    [seps, group, FES] = HDG('benchmark_func',lb,ub,func_num);
    filename = sprintf('./results2010_noH4_test/F%02d', func_num);
    save (filename, 'seps', 'group', 'FES', '-v7'); 
       
end    