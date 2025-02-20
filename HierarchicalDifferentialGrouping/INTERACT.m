function [flag,FES,archive]=INTERACT(x_a,x_b,lb,ub,fun,func_num,FES,archive)
    D=size(lb,2);
    x_ll=lb;x_ma=lb;x_mb=lb;
    rlist=(ub-lb)/2;
    x_ma(:,x_b)=lb(:,x_b)+rlist(x_b);
    x_mb(:,x_a)=lb(:,x_a)+rlist(x_a);
    x_mm=x_ma;x_mm(:,x_a)=x_mm(x_a)+rlist(x_a);
    
    [fit_x_ll,fit_x_ma,fit_x_mb,fit_x_mm,FES,archive]=MemorizedSearch(x_ll,x_ma,x_mb,x_mm,x_a,x_b,fun,func_num,FES,archive);
    
    delta1=fit_x_ma-fit_x_ll;
    delta2=fit_x_mm-fit_x_mb;
    delta=abs(delta2-delta1);
    
    fit_all=[abs(fit_x_ll),abs(fit_x_ma),abs(fit_x_mb),abs(fit_x_mm)];
    [fit_max,~]=max(fit_all);
    epsilon2=2^(-52)*D*0.003*fit_max;
    
    if delta<epsilon2
        flag=0;
    else
        flag=1;
    end
end