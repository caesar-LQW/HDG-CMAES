
FES_matrix=[];
num_sep=[];
num_nonsep=[];
groups_nonsep=[];

for f = 1:15
    filename = sprintf('./results2013_noH4_test/F%02d.mat', f);
    load(filename);
    s=[];
    m=0;
    mat = zeros(length(group), 20);
    FES_matrix=[FES_matrix;FES];
    num_sep=[num_sep; length(seps)];
    groups_nonsep=[groups_nonsep;length(group)];

    filename1 = sprintf('./cec2013/datafiles/f%02d.mat', f);
    filename2 = sprintf('./cec2013/datafiles/f%02d_opm.mat', f);
    flag = false;
    if(exist(filename1))
        load(filename1);
        flag = true;
    elseif(exist(filename2))
        load(filename2);
        flag = true;
    end
   

    for i=[1:1:length(group)]
        if(flag)
            ldim = 1;
            for g=1:length(s)
                captured = length(intersect(p(ldim:ldim+s(g)-1), group{i}));
                ldim=ldim+s(g)-m;
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
        if(sorted(k)~=0)
            masks(I(II(k)), :) = mask;
            mat(I(II(k)), :) = mat(I(II(k)), :) .* mask;
        end
        [temp I] = max(mat, [], 1);
        [sorted II] = sort(temp, 'descend');
    end
    mat = mat2 .* masks;
    [temp I] = max(mat, [], 1);
    if(ismember(f, [12 13 14 15]))
        gsizes = cellfun('length', group);
        num_nonsep=[num_nonsep;max(gsizes)];
    else
 
        num_nonsep=[num_nonsep;sum(temp(1:length(s)))];
    end
 
end

dims=1000*ones(15,1);
dims([13,14])=905;
var_nonsep=[0 0 0 300 300 300 300 1000 1000 1000 1000 1000 905 905 1000];
overall_acc=[];
sep_acc=[];
nonsep_group_acc=[];
for i=1:15
    if(num_sep(i)<(dims(i)-var_nonsep(i)))
        real_sep=num_sep(i);
    else
        real_sep=(dims(i)-var_nonsep(i));
    end
    if(i<=3)
        acc=num_sep(i)/dims(i);
        s_acc=num2str(acc,'%.4f');
        n_acc="-";
    elseif(i>=8)
        acc=num_nonsep(i)/dims(i);
        n_acc=num2str(acc,'%.4f');
        s_acc="-";
    else
        acc=(num_nonsep(i)+real_sep)/dims(i);
        s_acc=num2str(real_sep/(dims(i)-var_nonsep(i)),'%.4f');
        n_acc=num2str(num_nonsep(i)/var_nonsep(i),'%.4f');
    end
    sep_acc=[sep_acc;s_acc];
    nonsep_group_acc=[nonsep_group_acc;n_acc];
    overall_acc=[overall_acc;acc];  
end