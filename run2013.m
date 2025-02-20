% Author: Qingwei Liang
% Email:  liangqw@sdust.edu.cn 
% ------------
% Description:
% ------------
% This file is the entry point for the HDG-CMAES on the CEC'2013 benchmark functions.

clear;
% set random seed
rand('state', sum(100*clock)); 
randn('state', sum(100*clock));
%warning('off' ,'Octave:divide-by-zero');

% number of independent runs
runs = 20;

NP=1;

% number of fitness evaluations
Max_FES = 3e6;

% for the benchmark functions initialization
global initial_flag;
myfunc = 1:15;
addpath('benchmark2013');
addpath('benchmark2013/datafiles');
problem=2013;
S=100;
for func_num = myfunc 
    % load the FEs used by MDG in the decomposition process
    decResults = sprintf('./HierarchicalDifferentialGrouping/results2013_noH4_test/F%02d',func_num);
    load (decResults);
    FES = Max_FES - FES;
    
    % set the dimensionality and upper and lower bounds of the search space
    if (ismember(func_num, [13,14]))
        D = 905;
        Lbound = -100.*ones(NP,D);
        Ubound = 100.*ones(NP,D);
    elseif (ismember(func_num, [1,4,7,8,11,12,15]))
        D = 1000;
        Lbound = -100.*ones(NP,D);
        Ubound = 100.*ones(NP,D);
    elseif (ismember(func_num, [2,5,9]))
        D=1000;
        Lbound = -5.*ones(NP,D);
        Ubound = 5.*ones(NP,D);
    else 
        D=1000;
        Lbound = -32.*ones(NP,D);
        Ubound = 32.*ones(NP,D);
    end
    
    Max_Gen = FES/NP;

    VTRs = [];
    bestval = zeros(1,runs);
    for runindex = 1:runs
        % trace the fitness
        fprintf(1, 'Function %02d, Run %02d\n', func_num, runindex);
        filename = sprintf('optimize_result_2013/f%02d_%02d.txt',func_num, runindex);
        [fid, message] = fopen(filename, 'w');
        
        initial_flag = 0;
        % call the cmaescc algorithm
        [val]  = cmaescc(problem,'benchmark_func', func_num, D, Lbound, Ubound, FES,fid,S);
        bestval(runindex) = val;
        fclose(fid);
    end
    
end

