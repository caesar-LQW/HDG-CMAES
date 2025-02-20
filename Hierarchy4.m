function group_all = Hierarchy4(problem,fun,S)
    if problem==2010
        filename = sprintf('./HierarchicalDifferentialGrouping/results2010_noH4_test/F%02d', fun);
        load(filename);
    end
    if problem==2013
        filename = sprintf('./HierarchicalDifferentialGrouping/results2013_noH4_test/F%02d', fun);
        load(filename);
    end
    sep{1,1}=seps;
    nonsep={};
    max_size=S;
    sep_index=1;
    left1=1;right1=max_size;
    if size(seps,2)==0
        sep={};
    else
        if size(seps,2)>max_size
            while left1<size(seps,2)
                sep{1,sep_index}=seps(left1:right1);
                left1=left1+max_size;
                right1=min(size(seps,2),right1+max_size);  
                sep_index=sep_index+1;
            end
        else
            sep{1,1}=seps;
        end
    end
    g=1;
    if size(group,2)==0
        nonsep={};
    end
    for k=1:size(group,2)
        if size(group{1,k},2)>max_size
            left2=1;right2=max_size;
             nons=group{1,k};
             while left2<size(nons,2)
                nonsep{1,g}=nons(left2:right2);
                left2=left2+max_size;
                right2=min(size(nons,2),right2+max_size);  
                g=g+1;
             end
        else
            nonsep{1,g}=group{1,k};
            g=g+1;
        end
    end
    group_all = [sep nonsep];
    group_all(cellfun(@isempty,group_all))=[];
end
