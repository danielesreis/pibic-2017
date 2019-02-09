function metrics = calculate_metrics(classes, predicted, reference)
% classes different than zero
n_classes = max(size(classes));

m = max(size(predicted));
sensitivity = zeros(1, n_classes+1);
specificity = zeros(1, n_classes+1);
accuracy = zeros(1, n_classes+1);
fp_rate = zeros(1, n_classes+1);
conf_matrix = zeros(n_classes, n_classes);

for i=1:n_classes
    tp = 0;
    fp = 0;
    fn = 0;
    tn = 0;
    
    for j=1:m
        if(predicted(j) ~= 0)
            if(reference(j) == classes(i) && predicted(j) == classes(i))
                tp = tp + 1;
                
            elseif(reference(j) == classes(i) && predicted(j) ~= classes(i))
                fn = fn + 1;
                
            elseif(reference(j) ~= classes(i) && predicted(j) == classes(i))
                fp = fp + 1;
                
            else
                if(reference(j) == predicted(j))
                    tn = tn + 1;
                end
            end
            
            if (i==1)
                ind2 = find(classes == reference(j));
                ind1 = find(classes == predicted(j));
                conf_matrix(ind1, ind2) = conf_matrix(ind1, ind2) + 1;
            end
        end
    end
    
    sensitivity(1, i) = tp/(tp+fn);
    specificity(1, i) = tn/(tn+fp);
    accuracy(1, i) = (tp+tn)/m;
    fp_rate(1, i) = fp/(fp+tn);
end
sensitivity(1, n_classes+1) = mean(sensitivity(1, 1:n_classes));
specificity(1, n_classes+1) = mean(specificity(1, 1:n_classes));
accuracy(1, n_classes+1) = mean(accuracy(1, 1:n_classes));
fp_rate(1, n_classes+1) = mean(fp_rate(1, 1:n_classes));

metrics = struct('sensitivity', sensitivity, 'specificity', specificity, 'accuracy', accuracy, 'fp_rate', fp_rate, 'conf_matrix', conf_matrix);
end