function norm_data = normalize(data)

% Squash data to [0, 1] since we use sigmoid as the activation
data_mean = mean(data,1);
% Truncate to +/-5 standard deviations and scale to -1 to 1
data_std = 5 * std(data,0,1);
redata_std = repmat(data_std,size(data,1),1);
dm_data = bsxfun(@minus,data,data_mean);
norm_data = max(min(dm_data, redata_std), -redata_std) ./ redata_std;
% Rescale from [-1,1] to [0,1]
norm_data = (norm_data + 1) * 0.5;

end