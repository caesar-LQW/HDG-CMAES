numNonSep = [0 0 0 1 1 1 1 1 10 10 10 10 10 20 20 20 20 20 20 20];
var_nonsep=[0 0 0 50 50 50 50 50 500 500 500 500 500 1000 1000 1000 1000 1000 1000 1000];
num_sep=[];
num_nonsep=[];
for f=1:20
    filename = sprintf('./results2010_noH4_test/F%02d.mat', f);
    load(filename);
    p = 1:1:1000;
    mat = zeros(length(group), 20);
    num_sep=[num_sep; length(seps)];
    
    filename1 = sprintf('./cec2010/datafiles/f%02d_op.mat', f);
    filename2 = sprintf('./cec2010/datafiles/f%02d_opm.mat', f);
    flag = false;
    if(exist(filename1))
        load(filename1);
        flag = true;
    elseif(exist(filename2))
        load(filename2);
        flag = true;
    end


    for i=[1:1:length(group)]
        m = 50;
        if(flag)
            for g=[1:1:20]
                captured = length(intersect(p((g-1)*m+1:g*m), group{i}));
                mat(i, g) = captured;
            end
        end
    end
    mat2 = mat;
    [temp I] = max(mat, [], 1);
    [sorted II] = sort(temp, 'descend');
    masks = zeros(size(mat));
    for k = 1:min(size(mat))
        mask = zeros(1, length(sorted));
        mask(II(k)) = 1;
        masks(I(II(k)), :) = mask;
        %point = [I(k) II(k)];
        mat(I(II(k)), :) = mat(I(II(k)), :) .* mask;
        [temp I] = max(mat, [], 1);
        [sorted II] = sort(temp, 'descend');
    end
    mat = mat2 .* masks;
    [temp I] = max(mat, [], 1);

    if(ismember(f, [19 20]))
        gsizes = cellfun('length', group);
        num_nonsep=[num_nonsep;max(gsizes)];     
    else
        if(length(group)==0)
            num_nonsep=[num_nonsep;0];
        else
            num_nonsep=[num_nonsep;sum(temp(1:numNonSep(f)))];
        end
    end
end

var_misplaced=var_nonsep'-num_nonsep;
overall_acc=[];
sep_acc=[];
nonsep_group_acc=[];
for i=1:20
    if(num_sep(i)<(1000-var_nonsep(i)))
        real_sep=num_sep(i);
    else
        real_sep=(1000-var_nonsep(i));
    end
    if(i<=3)
        acc=num_sep(i)/1000;
        s_acc=num2str(acc,'%.4f');
        n_acc="-";
    elseif(i>=14)
        acc=num_nonsep(i)/1000;
        n_acc=num2str(acc,'%.4f');
        s_acc="-";
    else
        acc=(num_nonsep(i)+real_sep)/1000;
        s_acc=num2str(real_sep/(1000-var_nonsep(i)),'%.4f');
        n_acc=num2str(num_nonsep(i)/var_nonsep(i),'%.4f');
    end
    sep_acc=[sep_acc;s_acc];
    nonsep_group_acc=[nonsep_group_acc;n_acc];
    overall_acc=[overall_acc;acc];
    
end