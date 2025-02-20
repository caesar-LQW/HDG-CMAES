function [left,FES,archive]=BinarySearch(l,id,group,x_a,lb,ub,fun,func_num,FES,archive)
    left=l;right=size(id,2);
    while left<right
        mid=floor((left+right)/2);
        x_b=[];
        for l=left:mid
            x_b=[x_b,group{1,l}];
        end
        [flag,FES,archive]=INTERACT(x_a,x_b,lb,ub,fun,func_num,FES,archive);
        if flag==0
            left=mid+1;
        else
            right=mid;              
        end
    end
end