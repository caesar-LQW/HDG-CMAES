% ------------
% Description:
% ------------
% This file is modified based on the RDG.
function [bestval]  = cmaescc(problem,fname, func_num, dim, Lbound, Ubound, FEMax, fid,S)
    FECount = 0;
    oneintermax = 1;
    FEDecomposition = 3e6-FEMax;
    
    %mload decomposition results
    [allgroups] = Hierarchy4(problem,func_num,S);
    
    numgroups = size(allgroups, 2);
 
    % Parameter Initialization for CMA-ES
    xmean = Lbound+(Ubound-Lbound)/2;    
    sigma = 0.3*(Ubound-Lbound);    
    
    xbest=xmean;
    bestval=feval(fname,xmean,func_num);
    
    fprintf(fid, '%d, %e\n', FEDecomposition, bestval);
  
    %Replicate the parameters of CMA-ES for each group
    options=cell(numgroups,1);
    for i = 1:numgroups                                      
        % Initialize dynamic (internal) strategy parameters and constants
        options{i}.subpc = zeros(length(allgroups{i}),1);
        options{i}.subps = zeros(length(allgroups{i}),1);
        options{i}.subB = eye(length(allgroups{i}),length(allgroups{i}));
        options{i}.subD = ones(length(allgroups{i}),1);
        options{i}.subC = options{i}.subB * diag(options{i}.subD.^2) * options{i}.subB';
        options{i}.subinvsqrtC = options{i}.subB * diag(options{i}.subD.^-1) * options{i}.subB';
        options{i}.subeigeneval = 0;
        options{i}.subcounteval = 0;
    end
  
    %Optimization stage  
    Cycle = 0;
    while (FECount < FEMax)
        Cycle = Cycle + 1; 
        for i=1:numgroups
            dim_index=allgroups{i};       
            [bestmemnew,bestvalnew,xmean,sigma,FE,options{i}]=cmaes(fname,func_num,dim,dim_index,xbest,xmean,sigma,Lbound,Ubound,oneintermax,options{i});
            if bestvalnew<bestval
                xbest=bestmemnew;
                bestval=bestvalnew;
            end
            fprintf('FES: %d  Best fitness: %e\n',FECount,bestval);
            FECount=FECount+FE;
            if(FECount>FEMax)
                break;
            end
        end
    
        if(mod(Cycle,1)==0)
           fprintf(1, 'Cycle = %d, bestval = %e, Group = %d *\n',  Cycle, bestval,i);
           fprintf(fid, '%d, %e\n', FECount+FEDecomposition, bestval);
        end
    end
    fprintf(fid, '%d, %e\n', 3e6, bestval);
end
                
