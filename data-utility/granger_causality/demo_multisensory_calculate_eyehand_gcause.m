clear all;

exp_list = [70; 71];
kid_list = [6;7;8;10;15;16;18;20;21;22;23;27;29;31;34;35;36;37;38;39;40];
sub_list = [];
for eidx = 1:length(exp_list);
    sub_list = [sub_list; kid_list+ exp_list(eidx)*100];
end

num_exps = length(exp_list);
num_kids = length(kid_list);
start_idx = 1;

save_path = 'datafiles';
plot_path = 'plots';
is_plot = true;
roi_list = 1:3;
roi_str = 'obj';
point_select = 'onset';
var_name_list = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_inhand_child', 'cevent_inhand_parent'};
var_module_list = {'child eye', 'parent eye', 'child hand', 'parent hand'};
behav_module_list = [1 2 3 4];
module_str = 'eyehand';
glm_time_range = 60;

is_var_local = true;
num_vars = length(var_name_list);

[var_data_list, trial_times_list, var_data_length] = get_local_var_file(sub_list, var_name_list);
sample_rate = 0.0334;
num_rois = length(roi_list);

for sidx = start_idx:length(sub_list)
% sidx = 1;
sub_id = sub_list(sidx);

valid_mask = get_valid_data_mask(behav_module_list, sub_id);
has_all_modules = sum(valid_mask) > 1;

if sum(valid_mask) < 1
    fprintf('subject %d do not have enough variable.\n', sub_id);
    continue
end

title_str = sprintf('granger_glm_multipath_%d_data_point_%s_subject_%s_trial', sub_id, point_select, module_str);
file_name = sprintf('%s_range_%d', title_str, glm_time_range);
save_result_file = [file_name '.mat'];

if exist(fullfile(save_path, save_result_file), 'file')
    continue
end

sub_id

var_data_one = var_data_list(sidx, :);
trial_times = trial_times_list{sidx};
trial_times = trial_times(valid_mask(1:size(trial_times, 1)), :);
num_trials = sum(valid_mask);

data_mat_list = cell(num_rois, 1);

for tidx = 1:num_trials
trial_one = trial_times(tidx, :);
times = trial_one(1):sample_rate:(trial_one(2)+sample_rate);
data_length = length(times);

for ridx = 1:num_rois
    roi_one = roi_list(ridx);
    
    for vidx = 1:num_vars
        chunk_one = var_data_one{vidx};
        chunk_one = extract_ranges(chunk_one, 'cevent', trial_one);
        cevents_roi = cevent_category_equals(cevents_one{1}, roi_one);
        cevents_dur = cevents_roi(:,2) - cevents_roi(:,1);
        cevents_roi = cevents_roi(cevents_dur > 0.001, :);
        
        if isempty(cevents_one)
            stream_roi = zeros(1, data_length);
        else
            cstream_roi = event2point_process(cevents_roi, times, point_select);
            stream_roi = cstream_roi(:, 2)';
        end

        if isempty(data_mat_list{ridx})
            data_mat_list{ridx} = stream_roi;
        else
            if sum(stream_roi) ~= size(cevents_roi, 1)
                size(cevents_roi, 1)
                sum(stream_roi)
                times(stream_roi > 0)
                error('Point process converting error');
            end
            data_mat_list{ridx} = [data_mat_list{ridx}; stream_roi];
        end
    end % end of vidx
end % end of ridx

data_mat = nan(num_vars, data_length, num_rois);

for ridx = 1:num_rois
    data_mat(:, :, ridx) = data_mat_list{ridx, 1};
end

% load data_real_nonmove.mat;
results_gcause(tidx).data = data_mat;

% Dimension of data_mat (# Channels x # Samples x # Trials)
[CHN, SMP, TRL] = size(data_mat);

% To fit GLM models with different history orders
window_size = 3;
for neuron = 1:CHN
    for ht = 3:3:glm_time_range                             % history, W=3ms
        [bhat{ht,neuron}] = glmtrial(data_mat,neuron,ht,window_size);
    end
end

% To select a model order, calculate AIC
for neuron = 1:CHN
    for ht = 3:3:glm_time_range
        LLK(ht,neuron) = log_likelihood_trial(bhat{ht,neuron},data_mat,ht,neuron, glm_time_range);
        aic(ht,neuron) = -2*LLK(ht,neuron) + 2*(CHN*ht/3 + 1);
    end
end

% Save results
% save(save_result_file,'bhat','aic','LLK', 'data_mat');

% Identify Granger causality
% CausalTest;
% end
fprintf('\nNow Identify Granger causality for ROI group %s\n', roi_str);

ht = nan(1, num_vars);

% h = figure;
for varidx = 1:num_vars
%     subplot(2, 3, varidx);
%     plot(aic(3:3:glm_time_range,varidx));
    [value, index] = nanmin(aic(3:3:glm_time_range,varidx));
    ht(varidx) = index;
end
results_gcause(tidx).history = ht;

% Re-optimizing a model after excluding a trigger neuron's effect and then
% Estimating causality matrices based on the likelihood ratio
for target = 1:CHN
    LLK0(target) = LLK(3*ht(target),target);
    for trigger = 1:CHN
        % MLE after excluding trigger neuron
        [bhatc{target,trigger},devnewc{target,trigger}] = glmtrialcausal(data_mat,target,trigger,3*ht(target),3);
        
        % Log likelihood obtained using a new GLM parameter and data, which
        % exclude trigger
        LLKC(target,trigger) = log_likelihood_trialcausal(bhatc{target,trigger},data_mat,trigger,3*ht(target),target, glm_time_range);
               
        % Log likelihood ratio
        LLKR(target,trigger) = LLKC(target,trigger) - LLK0(target);
        
        % Sign (excitation and inhibition) of interaction from trigger to target
        % Averaged influence of the spiking history of trigger on target
        SGN(target,trigger) = sign(sum(bhat{3*ht(target),target}(ht(target)*(trigger-1)+2:ht(target)*trigger+1)));
    end
end

% Granger causality matrix, Phi
Phi = -SGN.*LLKR;
% data_gcausal_mat{group_index, tidx} = Phi;
results_gcause(tidx).gcause_mat = Phi;
plot_savefile = fullfile('plots', sprintf('granger_glm_multipath_%d_gmat_%s_subject_%s_trial_%d.png', ...
    sub_id, point_select, module_str, tidx));
visualize_gcause_matrix(results_gcause.gcause_mat, var_module_list, plot_savefile);

results_gcause(tidx).SGN = SGN;
results_gcause(tidx).LLKR = LLKR;

% ==== Significance Testing ====
% Causal connectivity matrix, Psi, w/o FDR
D = -2*LLKR;                                     % Deviance difference
alpha = 0.05;
for ichannel = 1:CHN
    temp1(ichannel,:) = D(ichannel,:) > chi2inv(1-alpha,ht(ichannel)/2);
end
Psi1 = SGN.*temp1;
% data_gcausal_sig{group_index, tidx} = Psi1;
results_gcause(tidx).gcause_sig = Psi1;

% Causal connectivity matrix, Psi, w/ FDR
fdrv = 0.05;
temp2 = FDR(D,fdrv,ht);
Psi2 = SGN.*temp2;
% data_gcausal_fdr{group_index, tidx} = Psi2;
results_gcause(tidx).gcause_fdr = Psi2;

end % end of tidx

% Save results
save(fullfile(save_path, save_result_file), 'results_gcause');

end % end of sidx