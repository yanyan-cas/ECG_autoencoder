function labels = remap_labels(labels)
% AAMI hearbeat classes
% on-ectopic beats(N)----label-1
% Supraventricular ectopic beats(S)----label-2
% Ventricular ectopic----label-3
% beats(V),Fusion beats(F)----label-4
% Unknown beats(Q)----lable-5

labels(labels == 1 | labels == 2 | labels == 3 | labels == 11 | labels == 34) = 1;
labels(labels == 4 | labels == 7 | labels == 8 | labels == 9) = 2;
labels(labels == 5 | labels == 10 |labels == 31) = 3;
labels(labels == 6) = 4;
labels(labels == 12 | labels == 13 | labels == 38) = 5;

end
