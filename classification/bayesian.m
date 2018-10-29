function thresholds = bayesian(reference, classes)

n_classes = max(size(classes));
mat = {};

for i=1:n_classes
    indexes = find(reference==classes(i));
    num = max(size(indexes));
    
    for j=1:num
        mat(j, i) = num2cell((indexes(j)));
    end
end

mn = zeros(1, n_classes);
st = zeros(1, n_classes);
p = zeros(1, n_classes);

for i=1:n_classes
    mn(1,i) = mean(cell2mat(mat(1:end,i)));
    st(1,i) = std(cell2mat(mat(1:end,i)));
    
    p(1,i) = 1/n_classes;
end

thresholds = zeros(1, n_classes-1);

for i=1:(n_classes-1)
    meanA = mn(1,i);
    meanB = mn(1,i+1);
    stdA = st(1,i);
    stdB = st(1,i+1);
    PA = p(1,i);
    PB = p(1,i+1);
    
    syms y
    y = solve(((y^2 * (stdB^2 - stdA^2) + y*(2*meanB*stdA^2 - 2*meanA*stdB^2) + (meanA^2 * stdB^2 - meanB^2*stdA^2) - stdB^2*stdA^2*2 *log((PA/PB)*stdB/(stdA)))==0'),y);
    
    for j=1:max(size(y))
        if (y(j,1) < max(classes) && y(j,1) > min(classes))
            thresholds(1,i) = y(j,1);
        end
    end
end
end