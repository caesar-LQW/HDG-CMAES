function [seps,group,FES]=HDG(fun,lb,ub,func_num)

    archive={};
    FES=0; 
    x_ll=lb; 
    rlist=(ub-lb)/2; %perturbation vector
    x_mm=x_ll+rlist;
    D=size(x_ll,2);
    
    fit_x_ll=feval(fun,x_ll,func_num);
    fit_x_mm=feval(fun,x_mm,func_num);
    FES=FES+2;
    
    archive{1,1}={0,fit_x_ll};
    archive{1,2}={(1:D),fit_x_mm}; %It is only necessary to save the index of the dimension being perturbed and fitness.
    
    
    for i=1:D
        x_lp(i,:)=x_ll; x_mp(i,:)=x_mm;
        x_lp(i,i)=lb(i)+rlist(i);
        x_mp(i,i)=lb(i);
    
        fit_x_lp(i)=feval(fun,x_lp(i,:),func_num);
        fit_x_mp(i)=feval(fun,x_mp(i,:),func_num);
        FES=FES+2;
    
        Pertur_index=(1:D);
        Pertur_index(i)=[];
        archive{1,i+2}={i,fit_x_lp(i)}; archive{1,i+D+2}={Pertur_index,fit_x_mp(i)};
        
        dealta1(i)=fit_x_lp(i)-fit_x_ll;
        dealta2(i)=fit_x_mm-fit_x_mp(i);
        delta(i)=abs(dealta2(i)-dealta1(i));
    end
    
    %Hierarchy1
    %%%%%%%%%%%%%%%%%%%%%%%%
    epsilon1 = 2^(-52)*D*0.003*(abs(fit_x_ll)+abs(mean(fit_x_lp))+abs(mean(fit_x_mp))+abs(fit_x_mm))/4;
    seps=[];
    nonseps=[];
    for i=1:D
        if(delta(i))>epsilon1
            nonseps=[nonseps,i];
        else
            seps=[seps,i];
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    %Hierarchy2
    %%%%%%%%%%%%%%%%%%%%%%%%
    NS=size(nonseps,2);
    group=cell(1,NS,1);
    if NS>1
        group{1,1}(end+1)=nonseps(1);
        for j=2:size(nonseps,2)
            no_empty=~cellfun(@isempty, group);
            [~,id]=find(no_empty==1);
            x_a=nonseps(j); x_b=nonseps(1:j-1);
            [flag,FES,archive]=INTERACT(x_b,x_a,lb,ub,fun,func_num,FES,archive);
            if flag==0
                group{1,size(id,2)+1}(end+1)=nonseps(j);
            else
                [index,FES,archive]=BinarySearch(1,id,group,x_a,lb,ub,fun,func_num,FES,archive);
                 group{1,index}(end+1)=x_a;
            end    
        end
        nonseps_group=group;
        %%%%%%%%%%%%%%%%%%%%%%%%
    
        %Hierarchy3
        %%%%%%%%%%%%%%%%%%%%%%%%
        group(cellfun(@isempty,group))=[];
        G=size(group,2);
        group_no=group;
        for k=1:length(group)
            group{1,k}=[];
        end
        if G>2 
            g=1;
            while 1
                while 1
                    no_empty=~cellfun(@isempty, group_no);
                    [~,id_new]=find(no_empty==1);
                    x_a=group_no{1,g};
                    x_b=[];
                    for k=g+1:size(id_new,2)
                        x_b=[x_b,group_no{1,k}];
                    end
                    [flag,FES,archive]=INTERACT(x_a,x_b,lb,ub,fun,func_num,FES,archive);
                
                    if flag==0
                        group_no{1,g}=sort(group_no{1,g});
                        break;
                    else
                        [index,FES,archive]=BinarySearch(g+1,id_new,group_no,x_a,lb,ub,fun,func_num,FES,archive);
                        group_no{1,g}=[group_no{1,g},group_no{1,index}];
                        for k=index:size(id_new,2)-1
                            group_no{1,k}=group_no{1,k+1};
                        end
                        group_no{1,size(id_new,2)}=[];
                        
                    end
                end
                no_empty=~cellfun(@isempty, group_no);
                [~,id_end]=find(no_empty==1);
                if g==size(id_end,2)
                    break;
                end
                g=g+1;
            end
            for a=1:size(id_end,2)
                empty=~cellfun(@isempty, group);
                [~,b]=find(empty==0);
                group{1,b(1)}=group_no{1,a};
            end
        else
            group=group_no;
        end
        first=0;m=20;
        for k=1:length(group)
            if size(group{1,k},2)<m
                first=k;
                break;
            end    
        end
        if first
            for k=first+1:length(group)
                if size(group{1,k},2)<m
                    group{1,first}=[group{1,first},group{1,k}];
                    group{1,k}=[];
                end   
            end     
        end
        group(cellfun(@isempty,group))=[];
        a=0;
        %%%%%%%%%%%%%%%%%%%%%%%%
    end
end

