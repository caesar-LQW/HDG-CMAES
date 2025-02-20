% Author: Qingwei Liang
% Email:  liangqw@sdust.edu.cn 
% ------------
% Description:
% ------------
% This file is the entry point for the HDG-CMAES on the CEC'2010 benchmark functions.



clear;
clc;
fclose('all');
% set random seed
rand('state', sum(100*clock)); 
randn('state', sum(100*clock));
%warning('off' ,'Octave:divide-by-zero');

% problem dimension
D = 1000;

% population size
NP = 1;

% number of independent runs
runs = 20;

% number of fitness evaluations
Max_FES = 3e6;

% for the benchmark functions initialization
global initial_flag;
problem=2010;
myfunc = 18:19;
addpath('benchmark2010');
addpath('benchmark2010/datafiles');
S=100;
for func_num=myfunc

    % load the FEs used by HDG in the decomposition process
    decResults = sprintf('./HierarchicalDifferentialGrouping/results2010_noH4_test/F%02d',func_num);
    load (decResults);
    FES = Max_FES - FES;
    
    % set the dimensionality and upper and lower bounds of the search space
    if(ismember(func_num, [1, 4, 7:9, 12:14, 17:20]))
        XRmin = -100*ones(NP,D); 
        XRmax = 100*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end
    if(ismember(func_num, [2, 5, 10, 15]))
        XRmin = -5*ones(NP,D); 
        XRmax = 5*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end
    if(ismember(func_num, [3, 6, 11, 16]))
        XRmin = -32*ones(NP,D); 
        XRmax = 32*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end
    
    Max_Gen = FES/NP;

    VTRs = [];
    bestval = zeros(1,runs);
    for runindex = 1:runs
        % trace the fitness
        fprintf(1, 'Function %02d, Run %02d\n', func_num, runindex);
        filename = sprintf('optimize_result_2010/f%02d_%02d.txt',func_num, runindex);
        [fid, message] = fopen(filename, 'w');
        
        initial_flag = 0;
        % call the cmaescc algorithm
        [val]  = cmaescc(problem,'benchmark_func', func_num, D, Lbound, Ubound, FES,fid,S);
        bestval(runindex) = val;
        fclose(fid);
    end
  
    
end
