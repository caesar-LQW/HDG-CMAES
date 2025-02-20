function [fit_x_ll,fit_x_ma,fit_x_mb,fit_x_mm,FES,archive]=MemorizedSearch(x_ll,x_ma,x_mb,x_mm,x_a,x_b,fun,func_num,FES,archive)

    no_empty=~cellfun(@isempty, archive);
    [~,id]=find(no_empty==1);
    
    fit_x_ll=archive{1,1}{2};
    
    flag_x_ma=1;
    for j=1:size(id,2)
        s=archive{1,j}{1};
        if isequal(s,sort(x_b))
            fit_x_ma=archive{1,j}{2};
            flag_x_ma=0;
            break;
        end
    end
    if flag_x_ma==1
        fit_x_ma=feval(fun,x_ma,func_num);
        archive{1,size(id,2)+1}={sort(x_b),fit_x_ma};
        FES=FES+1;
    end

    flag_x_mb=1;
    for j=1:size(id,2)
        s=archive{1,j}{1};
        if isequal(s,sort(x_a))
            fit_x_mb=archive{1,j}{2};
            flag_x_mb=0;
            break;
        end
    end
    if flag_x_mb==1
        fit_x_mb=feval(fun,x_mb,func_num);
        archive{1,size(id,2)+1}={sort(x_a),fit_x_mb};
        FES=FES+1;
    end

    flag_x_mm=1;x_ab=[x_a,x_b];
    x_ab=sort(x_ab);
    for j=1:size(id,2)
        s=archive{1,j}{1};
        if isequal(s,x_ab)
            fit_x_mm=archive{1,j}{2};
            flag_x_mm=0;
            break;
        end
    end
    if flag_x_mm==1
        fit_x_mm=feval(fun,x_mm,func_num);
        archive{1,size(id,2)+1}={x_ab,fit_x_mm};
        FES=FES+1;
    end
end