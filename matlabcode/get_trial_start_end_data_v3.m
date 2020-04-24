

%% ABOUT CODE - plot_session_performance_v11.m
% This code computes data for mouse performance - adapted from plot_session_performance_v11.m

%% REFERENCE NOTES

%% CODE FIXES
%   Date                Author                  Description
% 01/01/2019        Ninad B. Kothari            created script

% %06/17/2019         Sarah K. Coreas              identifies system name and runs corresponding for loop
%                                                  call function and switch case to display vertical and horizontal trials as appropriate up and down pokes   
%                                                  implemented display type flag
% 
% 06/20/2019        Jessica Zhang               adds plot_flage to plot graphs when required or only shows data without graphs when necessary
% 06/27/2019        Jessica Zhang               makes this script into a function
% 01/01/2020       Ninad B. Kothari             modified script to get 
% %% WARNINGS
%                       DESCRIPTION                                                                                     STATUS

%%  BUGS AND THINGS TO BE IMPLEMENTED
%                       DESCRIPTION                                                                                     STATUS

%% CODE% Behavior data script

% first cd to directory with behavior data

%% TODO: add flag that will return output as object: total trials, correct, incorrect, poke up, poke down, accuracy, water consumed
% cd D:\Postdoc_Mysore_lab\Research_data\behavior
function [stim_start_end_times, subject_ID] = get_trial_start_end_data_v3(fname)

% error checing flags (optional flags only)
check_if_stimulus_distractor_match = 1;
W4_W5_error_ignore_flag = 0; % 0 = do not ignore
check_protocol_number = 1;

length_mismatch_thr = 10; % if there is a mismatch between the actual number of trials and the # of protocol trials in W2

delimiter = ',';
startRow = 1;
endRow = 400;
choice_rep_index = 8; % Index into matrix for when mouse reported its choice by nose poke
target_vis_index = 7; % Index into matrix for when target was visible on screen

stim_start_index = 7; % Column number of matrix where stim display time is entered
stim_end_index = 8;

formatSpec = '%s%s%[^\n\r]'; % first column is to be read as a string and the remaining as they are
% fileID = fopen(fname,'r');
% dataArray = textscan(fileID, formatSpec, endRow(1), 'Delimiter', delimiter , 'ReturnOnError', false);
% fclose(fileID);

default = fileread(fname);
default = regexp(default,'\n','split');
default = default';
dataArray1 = [];
dataArray2 = [];
t_lines = [];
for jj = 1:length(default)-1
    if(isempty(default{jj,1}))
        dataArray1{jj} = 'ignore';
    else
        dataArray1{jj} = textscan(default{jj}, formatSpec, endRow(1), 'Delimiter', delimiter , 'ReturnOnError', false);
    end
    dataArray2{1,1}(jj,1) = dataArray1{1,jj}(1,1);
    if(isempty(dataArray2{1, 1}{jj, 1}))
        dataArray2{1, 1}{jj, 1} = {'ignore'};
    end
    dataArray2{1,2}(jj,1) = dataArray1{1,jj}(1,2);
    if(isempty(dataArray2{1, 2}{jj, 1}))
        dataArray2{1, 2}{jj, 1} = {'ignore'};
    end
    dataArray2{1,3}(jj,1) = dataArray1{1,jj}(1,3);
    if(isempty(dataArray2{1, 3}{jj, 1}))
        dataArray2{1, 3}{jj, 1} = {'ignore'};
    end
    t_lines{jj,1} = [cell2mat(dataArray2{1,1}{jj,1}), ',', cell2mat(dataArray2{1,2}{jj,1}), ',', cell2mat(dataArray2{1,3}{jj,1})];
end

display_type_flag = 0;

% search for - image list line number
STARTDATA = dataArray2{1,1};
[protocol_database_lineno] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('DB Ref', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);

% search for - image list line number
[image_name_list_lineno] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('01_cross', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
if(isempty(image_name_list_lineno))
    [image_name_list_lineno] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('01_corss', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1); % How stupid
end

% search for 
STARTDATA = dataArray2{1,1};

% Get subject ID
[sub_linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('Subject Id', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
subject_ID = cell2mat(dataArray2{1,2}{sub_linenum,1});

num_lines = length(dataArray2{1,1});

num_trials = str2num(cell2mat(dataArray2{1,1}{num_lines-1,1}));

if(~isempty(strfind(dataArray2{1,2}{protocol_database_lineno, 1}, 'nbk_shaping07')))
    protocol_name = 'nbk_shaping07';
elseif(~isempty(strfind(dataArray2{1,2}{protocol_database_lineno, 1}, 'nbk_shaping06')))
    protocol_name = 'nbk_shaping06';
else
    disp('ERROR - wrong protocol file - this script only works for nbkshaping_06 or 07');
    protocol_name = 'wrong';
    return
end
    
% error checking - check whether I am extracting the correct cells for stimulus ON and stimulus OFF
t_str = [cell2mat(dataArray2{1,1}{(num_lines-num_trials-4)}), ',', cell2mat(dataArray2{1,2}{(num_lines-num_trials-4)}), ',', cell2mat(dataArray2{1,3}{(num_lines-num_trials-4)})];
t_trial_count = length(strfind(t_str, ','));
tt_cell = textscan(t_str, [repmat('%s', 1,t_trial_count),], 'Delimiter', ',');
if((strcmp(tt_cell{1,stim_start_index}{1,1}, 'Stage (5)')) && (strcmp(tt_cell{1,stim_end_index}{1,1}, 'Stage (5)')))
else
    disp('ERROR - Wrong file? Does not match with Stage 5');
    return;
end

for ii = 1:num_trials
    str = [cell2mat(dataArray2{1,1}{(num_lines-num_trials+ii-1-2+1)}), ',', cell2mat(dataArray2{1,2}{(num_lines-num_trials+ii-1-2+1)}), ',', cell2mat(dataArray2{1,3}{(num_lines-num_trials+ii-1-2+1)})];
%     str = (lines{1,1}{(num_lines-num_trials+ii-1-2+1)});
%         trial_count = count(str,',');
    trial_count = length(strfind(str, ','));
       
%     t_cell = textscan(lines{1,1}{(num_lines-num_trials+ii-1-2+1),1}, [repmat('%d', 1,trial_count),], 'Delimiter', ',');
    t_cell = textscan(str, [repmat('%d', 1,trial_count),], 'Delimiter', ',');
    t_mat(ii,:) = double(cell2mat(t_cell)); 
end
% end for loop here

stim_start_end_times = t_mat(:,stim_start_index:stim_end_index);


%% - scripts from previous script - get_session_data_v2.m
% % Convert times to minutes
% tar_vis_times = t_mat(:,target_vis_index)/6000; % mins
% tar_rep_times = t_mat(:,choice_rep_index)/6000; % mins
% 
% % create TD arrays out of the 'trial table'
% if(check_if_stimulus_distractor_match == 1)
%     image_comb_arr = t_mat(:, 3)+1;
%     t_image_comb = get_mouse_image_comb_list(subject_ID, fname(1:11));
%     
%     % NOTE - these are the variables storing the actual target and distractor displayed to the mouse
%     ttarget_type = [];   ddistractor_type = [];   ddist_contrast = [];  cong_tr_arr = [];     incong_tr_arr = [];   no_dist_tr_arr = [];
%     for jj = 1:length(tar_vis_times)
%         t_image_ind = image_comb_arr(jj);
%         t_image_name = t_image_comb{1, t_image_ind};
%         if(strcmp(t_image_name, 'vt_resp') || strcmp(t_image_name, 'hz_resp'))
%             if(strcmp(t_image_name(1:2), 'vt'))
%                 ttarget_type = [ttarget_type, 0];
%                 ddistractor_type = [ddistractor_type, 9];
%                 ddist_contrast = [ddist_contrast, 0];                
%                 cong_tr_arr = [cong_tr_arr, 0];
%                 incong_tr_arr = [incong_tr_arr, 0];
%                 no_dist_tr_arr = [no_dist_tr_arr, 1];
%             elseif(strcmp(t_image_name(1:2), 'hz'))
%                 ttarget_type = [ttarget_type, 1];
%                 ddistractor_type = [ddistractor_type, 9];
%                 ddist_contrast = [ddist_contrast, 0];
%                 cong_tr_arr = [cong_tr_arr, 0];
%                 incong_tr_arr = [incong_tr_arr, 0];
%                 no_dist_tr_arr = [no_dist_tr_arr, 1];
%             else
%                 disp('ERROR - wrong image combination');
%                 return;        
%             end
%         elseif(strcmp(t_image_name(end-5:end), 'incong'))
%             if(strcmp(t_image_name(1:2), 'vt'))
%                 ttarget_type = [ttarget_type, 0];
%                 ddistractor_type = [ddistractor_type, 1];
%                 ddist_contrast = [ddist_contrast, str2num(t_image_name(8))];
%                 cong_tr_arr = [cong_tr_arr, 0];
%                 incong_tr_arr = [incong_tr_arr, 1];
%                 no_dist_tr_arr = [no_dist_tr_arr, 0];
%             elseif(strcmp(t_image_name(1:2), 'hz'))
%                 ttarget_type = [ttarget_type, 1];
%                 ddistractor_type = [ddistractor_type, 0];
%                 ddist_contrast = [ddist_contrast, str2num(t_image_name(8))];
%                 cong_tr_arr = [cong_tr_arr, 0];
%                 incong_tr_arr = [incong_tr_arr, 1];
%                 no_dist_tr_arr = [no_dist_tr_arr, 0];
%             else
%                 disp('ERROR - wrong image combination');
%                 return;        
%             end
%         elseif(strcmp(t_image_name(end-4:end), '_cong'))
%             if(strcmp(t_image_name(1:2), 'vt'))
%                 ttarget_type = [ttarget_type, 0];
%                 ddistractor_type = [ddistractor_type, 0];
%                 ddist_contrast = [ddist_contrast, str2num(t_image_name(8))];
%                 cong_tr_arr = [cong_tr_arr, 1];
%                 incong_tr_arr = [incong_tr_arr, 0];
%                 no_dist_tr_arr = [no_dist_tr_arr, 0];
%             elseif(strcmp(t_image_name(1:2), 'hz'))
%                 ttarget_type = [ttarget_type, 1];
%                 ddistractor_type = [ddistractor_type, 1];
%                 ddist_contrast = [ddist_contrast, str2num(t_image_name(8))];
%                 cong_tr_arr = [cong_tr_arr, 1];
%                 incong_tr_arr = [incong_tr_arr, 0];
%                 no_dist_tr_arr = [no_dist_tr_arr, 0];
%             else
%                 disp('ERROR - wrong image combination');
%                 return;        
%             end
%         else
%             disp('ERROR - Image not vt or hz');
%         end
%     end
% end
%     
% % Find line number of 'Image Table' Start and End
% [img_tab_linenum_st] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('ImageTableStart', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
% 
% [img_tab_linenum_end] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('ImageTableEnd', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
% 
% % Get the offset position of the 'image_index' - This varies between nbk_shaping07 and 06 :(
% [target_image_linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('W2', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
% [distractor_image_linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('W5', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
% 
% % error checking - there should be only a single W2 (within image table)
% % NOTE - if there are multiple W4 or W5 entries then it just means that there was a mismatch in the number of trials expected and coded
% % So, in this case, error checking can only be done for the table entires that exist
% if(length(target_image_linenum) ~= 1)
%     disp('WARNING - multiple W2 instances found within Image Table');
%     W4_W5_error_ignore_flag = get_mouse_specific_W4_W5_error_ignore_flag(subject_ID, fname);
%     if(W4_W5_error_ignore_flag == 2)
%         target_image_linenum = target_image_linenum(1);
%         distractor_image_linenum = distractor_image_linenum(1);
%     end
% %     return;
% end
% 
% % error checking - No distractor image table entry found
% % NOTE - if W5 is not found then it does NOT mean that the distractor was not displayed to the mouse
% % So, in this case, error checking might not be possible but analysis can still be done
% if(isempty(distractor_image_linenum))
%     disp('ERROR - W5 NOT found within Image Table');
%     W4_W5_error_ignore_flag = get_mouse_specific_W4_W5_error_ignore_flag(subject_ID, fname);
%     w5_exists_flag = 0;
% else
%     w5_exists_flag = 1;
% end
% 
% % error checking - target_image_linenum should lie within the Image Table Limits
% if((target_image_linenum > img_tab_linenum_end) || (target_image_linenum < img_tab_linenum_st))
%     disp('ERROR - W2 lies outside Image Table limits');
%     return;
% end
% 
% % Get total number of trials
% if(W4_W5_error_ignore_flag ~= 1) % do error checking using Image Discrimination Table
%     fileID = fopen(fname,'r');
%     lines = textscan(fileID, '%s', 'Delimiter', '\n');
%     fclose(fileID);
%     % NOTE - the current fix will only work if ERROR TRIALS are NOT repeated 
%     if(strcmp(protocol_name, 'nbk_shaping07') || strcmp(protocol_name, 'nbk_shaping06'))
%         % get image name array
%         t_count = length(strfind(lines{1,1}{(image_name_list_lineno),1}, ','));
%         image_name_list = textscan(lines{1,1}{(image_name_list_lineno),1}, [repmat('%s', 1,t_count),], 'Delimiter', ',');
% 
%         % error checking
%         if(~strcmp(image_name_list{1,1}, '01_cross') && ~strcmp(image_name_list{1,1}, '01_corss'))
%             disp('ERROR - First image name is not 01_cross - this does not seem to be right');
%             return;
%         end
% 
%         % get start of image table
%         % Get Window 2 (Target image Index)
%     %     [img_tab_linenum_st] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('ImageTableStart', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
%         text_val = lines{1,1}{target_image_linenum+1,1};
%         t_count = length(strfind(text_val, ','));
% %         t_cell = textscan(lines{1,1}{(target_image_linenum+1),1}, ['%s', repmat('%d', 1,t_count-1),], 'Delimiter', ',');
%         t_cell = textscan(lines{1,1}{(target_image_linenum+1),1}, ['%s', repmat('%d', 1,t_count),], 'Delimiter', ',');
% 
%         % Construct TD array
%         if(w5_exists_flag == 1)
%             text_val_d = lines{1,1}{target_image_linenum+1,1};
%             d_count = length(strfind(text_val_d, ','));
% %             d_cell = textscan(lines{1,1}{(distractor_image_linenum+1),1}, ['%s', repmat('%d', 1,d_count-1),], 'Delimiter', ',');
%             d_cell = textscan(lines{1,1}{(distractor_image_linenum+1),1}, ['%s', repmat('%d', 1,d_count),], 'Delimiter', ',');
%         end    
%         % error checking
%         if(~strcmp(t_cell{1,1}, 'ImageIndex'))
%             disp('ERROR - Target image index extraction does not seem correct');
%             return;
%         end
% 
%         if((t_count-1) < 140)
%             disp('ERROR - Num target images not equal to 200');
%             return;
%         end
% 
%         target_type = [];   distractor_type = [];   dist_contrast = [];
%         for jj = 2:t_count+1
%             t_image_ind = (t_cell{1,jj});
%             if(~isempty(t_image_ind))
% %                 pause(1);
%                 t_image_name = image_name_list{1, t_image_ind+1};
%                 if(strcmp(t_image_name{1,1}(1:2), 'vt'))
%                     target_type = [target_type, 0];
%                 elseif(strcmp(t_image_name{1,1}(1:2), 'hz'))
%                     target_type = [target_type, 1];
%                 else
%                     disp('ERROR - Image not vt or hz');
%                 end
%             end
%             if(check_if_stimulus_distractor_match == 1 && w5_exists_flag == 1)
%                 t_image_ind = (d_cell{1,jj});
%                 if(~isempty(t_image_ind))
%                     
%                     t_image_name = image_name_list{1, t_image_ind+1};
%                     dist_contrast = [dist_contrast, str2num(t_image_name{1,1}(3))];
%                     if(strcmp(t_image_name{1,1}(1:2), 'vt'))
%                         distractor_type = [distractor_type, 0];
%                     elseif(strcmp(t_image_name{1,1}(1:2), 'hz'))
%                         distractor_type = [distractor_type, 1];
%                     else
%                         distractor_type = [distractor_type, 9];
%                         dist_contrast = [dist_contrast, 0];
%                     end
%                 else
%                     disp(sprintf('t img index empty - %s - %s', subject_ID, fname));
%                 end
%             end
% 
%         end
% 
%         % limit target_type to the actual number of trials
% %         if(num_trials > 200)
% %             return; % I need to deal with this case without a hack
% %             num_trials = 200;
% %             disp('WARNING - number of trials exceeded 200 - restricting analysis to 200 only');
% %             t_mat = t_mat(1:200,:);
% %             tar_vis_times = tar_vis_times(1:200);
% %             tar_rep_times = tar_rep_times(1:200);
% %         end
% % 
% %         % IF num_trials and length(target_type) do not match - this happens if animals does more trials than in 'design'
% %         % SOLUTION - 
% %         % Ignore the extra trials IF under a threshold. Use the 'length(target_type) data for error checking (c_mat 1 == c_mat2)
% %         if(length(target_type) < num_trials)
% %             if(length(target_type)+length_mismatch_thr < num_trials)
% %                 disp('ERROR - length mismatch more than **10** trials');
% %                 return;
% %             else
% %                 disp('WARNING - length mismatch less than **10** trials - IGNORED');
% %                 num_trials = length(target_type);            
% %                 t_mat = t_mat(1:length(target_type),:);
% %                 tar_vis_times = tar_vis_times(1:length(target_type));
% %                 tar_rep_times = tar_rep_times(1:length(target_type));
% % 
% %                 ddistractor_type = ddistractor_type(1:num_trials);
% %                 ddist_contrast = ddist_contrast(1:num_trials);
% %                 ttarget_type = ttarget_type(1:num_trials);
% %                 cong_tr_arr = cong_tr_arr(1:num_trials);
% %                 incong_tr_arr = incong_tr_arr(1:num_trials);
% %                 no_dist_tr_arr = no_dist_tr_arr(1:num_trials);
% %             end
% %         end
% 
% %         target_type = target_type(1:num_trials)';
% %         if(w5_exists_flag == 1)
% %             distractor_type = distractor_type(1:num_trials)';
% %             dist_contrast = dist_contrast(1:num_trials)';
% %         end
% 
%     else % must be nbk_shaping06
% %         target_type = t_mat(:,3); % 0 - vert, 1 - horiz
%     end
% 
% end
% % THINGS TO DO
% % 1) code from 280 - 384 can be made optional
% % 2) In the cde below - starting at "main analysis" we could replace target_type with ttarget_type
% % 3) Again, before 'main analysis' we will fall into two cases
% %       a) actual trials are equal to or less than those from the predefined matrix
% %       b) actual trials are more than from the predefined matrix
% % 4) Further, I need to deal with 2 more cases
% %       a) W5 table entry does not exist
% %       b) There are multiple W4/W5 table entries
% %       In both of the above cases error checking will not be possible on the whole stimulus set but analysis is still possible 
% %       only if there are no mistakes in the protocol. This decision will have to be taken on a per session basis
% 
% 
% % assign target type
% % target_type = t_mat(:,3); % 0 - vert, 1 - horiz
% 
% 
% 
% %% NOTE - MOUSE SPECIFIC CORRECTIONS GO HERE
% % 1) MiTg04 - all dates before 01/03/2019 the condition VT_T6_D8_incong was actually VT_T6_D6_cong. This has now been corrected in the scrip. All
% %       VT_T6_D8 are converted into VT_T6_cong
% 
% if(W4_W5_error_ignore_flag ~= 1)
%     [target_type, distractor_type, dist_contrast, ttarget_type, ddistractor_type, ddist_contrast] = mouse_specific_corrections( ...
%         target_type, distractor_type, dist_contrast, ttarget_type, ddistractor_type, ddist_contrast, subject_ID, fname);
% 
%     if(check_if_stimulus_distractor_match == 1 && w5_exists_flag == 1)
%         c_mat1 = [target_type', distractor_type', dist_contrast'];
%         c_mat2 = [ttarget_type', ddistractor_type', ddist_contrast'];
% 
%         if(c_mat1 == c_mat2)
%             disp('Hooray');
%         else
%             disp('ERROR - TD arrays do not match');
%             return;
%         end
%     end
% end
% 
% % Main analysis
% 
% corr_choice = -1*t_mat(:,2)';
% corr_choice(corr_choice == 0) = 1; % 1 - corr, -1 - incorr, -2 - missed
% 
% % correct/incorrect vert/horiz target presentation times
% times_corr_vert_tar = tar_vis_times(find((ttarget_type == 0) & (corr_choice == 1)));
% % times_corr_vert_tar = tar_vis_times(find(((target_type == 0) | (target_type == 2)  | (target_type == 3)) & (corr_choice == 1)));
% times_incorr_vert_tar = tar_vis_times(find((ttarget_type == 0) & (corr_choice == -1)));
% % times_incorr_vert_tar = tar_vis_times(find(((target_type == 0) | (target_type == 2)  | (target_type == 3)) & (corr_choice == -1)));
% times_missed_vert_tar = tar_vis_times(find((ttarget_type == 0) & (corr_choice == -2)));
% % times_missed_vert_tar = tar_vis_times(find(((target_type == 0) | (target_type == 2)  | (target_type == 3)) & (corr_choice == -2)));
% 
% times_corr_horz_tar = tar_vis_times(find((ttarget_type == 1) & (corr_choice == 1)));
% times_incorr_horz_tar = tar_vis_times(find((ttarget_type == 1) & (corr_choice == -1)));
% times_missed_horz_tar = tar_vis_times(find((ttarget_type == 1) & (corr_choice == -2)));
% 
% 
% % reaction times
% rxn_time = tar_rep_times*60 - tar_vis_times*60; % seconds - reaction time - is this correct?
% 
% rt_corr_vert_choice = rxn_time(find((ttarget_type == 0) & (corr_choice == 1)));
% rt_incorr_vert_choice = rxn_time(find((ttarget_type == 0) & (corr_choice == -1)));
% 
% rt_corr_horz_choice = rxn_time(find((ttarget_type == 1) & (corr_choice == 1)));
% rt_incorr_horz_choice = rxn_time(find((ttarget_type == 1) & (corr_choice == -1)));
% 
% 
% % Percent correct/incorrect
% % corr_vert_choice = sum( corr_choice( find((target_type == 0) | (target_type == 2)  | (target_type == 3))) == 1);
% % incorr_vert_choice = sum( corr_choice( find((target_type == 0) | (target_type == 2)  | (target_type == 3))) == -1);
% % missed_vert_choice = sum( corr_choice( find((target_type == 0) | (target_type == 2)  | (target_type == 3))) == -2);
% corr_vert_choice = sum( corr_choice( find((ttarget_type == 0))) == 1);
% incorr_vert_choice = sum( corr_choice( find((ttarget_type == 0))) == -1);
% missed_vert_choice = sum( corr_choice( find((ttarget_type == 0))) == -2);
% 
% % corr_vert_choice = sum( corr_choice( find(target_type == 0)) == 1);
% % incorr_vert_choice = sum( corr_choice( find(target_type == 0)) == -1);
% % missed_vert_choice = sum( corr_choice( find(target_type == 0)) == -2);
% corr_horz_choice = sum( corr_choice( find(ttarget_type == 1)) == 1);
% incorr_horz_choice = sum( corr_choice( find(ttarget_type == 1)) == -1);
% missed_horz_choice = sum( corr_choice( find(ttarget_type == 1)) == -2);
% 
% % verify num trials
% num_trials_tot = corr_vert_choice + incorr_vert_choice + missed_vert_choice + corr_horz_choice + incorr_horz_choice + missed_horz_choice;
% if(num_trials ~= num_trials_tot)
%     disp('ERROR - num trials do not match');
%     return;
% end
% 
% 
% % Plot Reaction Times - separate and combined
% % stuff to add here 
% % add numbers over each column
% 
% screensize = get(0,'screensize');
% l = screensize(1,3);
% w = screensize(1,4);
% adjusted_ratio_1 = [l/300 w/2-w/15+0.09*w l-l/250 w/2-w/100-0.09*w];
% adjusted_ratio_2 = [l/300 w*0.04 l*2/3-l/250 w/2-w/10];
% adjusted_ratio_3 = [l/300+l*2/3-l/250 w*0.04 (l*2/3-l/250)*0.00046*w w/2-w/10];
% 
% 
% 
% tot_vert_trials = corr_vert_choice+incorr_vert_choice+missed_vert_choice;
% tot_horz_trials = corr_horz_choice+incorr_horz_choice+missed_horz_choice;
% tot_corr = corr_horz_choice+corr_vert_choice;
% tot_incorr = incorr_vert_choice+incorr_horz_choice;
% tot_missed = missed_vert_choice+missed_horz_choice;
% tot_trials = tot_corr + tot_incorr + tot_missed;
% 
% value_of_y = get_mouse_choice_f_v2(subject_ID);
% 
% perc_corr_vert = (corr_vert_choice/tot_vert_trials)*100;
% perc_corr_horz = (corr_horz_choice/tot_horz_trials)*100;
% perc_corr_tot = (tot_corr/tot_trials)*100;
% 
% if value_of_y==1
%    perc_corr_up = perc_corr_vert;
%    perc_corr_dn = perc_corr_horz ;
%           
% else
%     perc_corr_up = perc_corr_horz;
%     perc_corr_dn = perc_corr_vert;     
% end
% 
% details.corr_arr = corr_choice;
% details.rxn_time = rxn_time;
% details.incong_tr_arr = incong_tr_arr;
% details.cong_tr_arr = cong_tr_arr;
% details.no_dist_tr_arr = no_dist_tr_arr;
% details.distractor_type = ddistractor_type;
% details.dist_contrast = ddist_contrast;
% details.target_type = ttarget_type;
% details.fname = fname;
% 
% % error checking
% if(length(incong_tr_arr) ~= length(cong_tr_arr))
%     disp('ERROR - lengths dont match - 1');
%     return;
% end
% 
% if(length(incong_tr_arr) ~= length(ddist_contrast))
%     disp('ERROR - lengths dont match - 2');
%     return;
% end
% 
% if(length(incong_tr_arr) ~= length(corr_choice))
%     disp('ERROR - lengths dont match - 3');
%     return;
% end
% 
% if(length(ddist_contrast) ~= length(corr_choice))
%     disp('ERROR - lengths dont match - 4');
%     return;
% end
% 
% data = MouseData(subject_ID, tot_corr, tot_incorr, tot_missed, tot_trials, perc_corr_tot, perc_corr_up, perc_corr_dn, details);
% 
% if  display_type_flag ==1
%     disp(sprintf('Mouse ID - %s \nDate - %s \nTot trials-%d, \nTot Correct-%d, \nTot Incorr-%d, \nTot Missed-%d, \nPerc tot Corr-%2.1f, \nPerc up Corr-%2.1f, \nPerc dn Corr-%2.1f', ...
%             subject_ID, fname, tot_trials, tot_corr, tot_incorr, tot_missed, perc_corr_tot, perc_corr_up, perc_corr_dn));
% else 
%     disp(sprintf('Mouse ID- %s \nDate - %s \n%d \n%d \n%d \n%2.1f \n%2.1f \n%2.1f', ...
%         subject_ID, fname, tot_trials, tot_corr, tot_incorr, perc_corr_tot, perc_corr_up, perc_corr_dn));
% end
% 
% % Plot percent/num correct/incorrect/missed
% % stuff to add here 
% % add numbers over each column
% 
% if plot_flag == 1
%     fh3 = figure('Position', adjusted_ratio_3); 
% 
%     title([subject_ID, fname]);
%     subplot(121);
%     % bh2 = bar([[mean(rt_corr_vert_choice), mean(rt_incorr_vert_choice)]', ... 
%     %         [mean(rt_corr_horz_choice), mean(rt_incorr_horz_choice)]']'); %, 'FaceColor',[0 .5 .5]
%     bh2 = bar([[median(rt_corr_vert_choice), median(rt_incorr_vert_choice)]', ... 
%             [median(rt_corr_horz_choice), median(rt_incorr_horz_choice)]']'); %, 'FaceColor',[0 .5 .5]
%     ylabel('Median Reaction Times (secs)');
%     xlabel('Trial type');
%     % bh(:).BarWidth = 0.5;
%     set(gca, 'XTickLabel', {'Vertical', 'Horizontal'});
%     set(gca, 'fontname', 'Arial');
%     legend({'Correct', 'Incorrect'});
%     title('Rxn times - separate');
% 
%     subplot(122);
%     bh2 = bar([mean([rt_corr_vert_choice; rt_corr_horz_choice]), mean([rt_incorr_vert_choice; rt_incorr_horz_choice])]');
%     % bh2 = bar([[median(rt_corr_vert_choice), median(rt_incorr_vert_choice)]', ... 
%     %         [median(rt_corr_horz_choice), median(rt_incorr_horz_choice)]']'); %, 'FaceColor',[0 .5 .5]
%     ylabel('Mean Reaction Times (secs)');
%     xlabel('Trial type');
%     % bh(:).BarWidth = 0.5;
%     set(gca, 'XTickLabel', {'Correct', 'Incorrect'});
%     set(gca, 'fontname', 'Arial');
%     title('Rxn times - combined');
% end
% 
% 
% if plot_flag == 1
%     fh1 = figure('Position', adjusted_ratio_2); 
%     subplot(131);
%     bh1 = bar([[tot_vert_trials, corr_vert_choice, incorr_vert_choice, missed_vert_choice]', ... 
%         [tot_horz_trials, corr_horz_choice, incorr_horz_choice, missed_horz_choice]']'); %, 'FaceColor',[0 .5 .5]
%     ylabel('Number of trials');
%     xlabel('Trial type');
%     % bh(:).BarWidth = 0.5;
%     set(gca, 'XTickLabel', {'Vertical', 'Horizontal'});
%     set(gca, 'fontname', 'Arial');
%     legend({'Total', 'Correct', 'Incorrect', 'Missed'});
%     title([subject_ID, fname]);
% 
%     subplot(132);
%     bh2 = bar([[corr_vert_choice/tot_vert_trials, incorr_vert_choice/tot_vert_trials, missed_vert_choice/tot_vert_trials]', ... 
%         [corr_horz_choice/tot_horz_trials, incorr_horz_choice/tot_horz_trials, missed_horz_choice/tot_horz_trials]']'); %, 'FaceColor',[0 .5 .5]
%     ylabel('percentage');
%     xlabel('Trial type');
%     % bh(:).BarWidth = 0.5;
%     set(gca, 'XTickLabel', {'Vertical', 'Horizontal'});
%     set(gca, 'fontname', 'Arial');
%     legend({'Correct', 'Incorrect', 'Missed'});
%     title('Perc Corr - separate');
% 
%     subplot(133);
%     bh = bar([tot_corr/num_trials, tot_incorr/num_trials, tot_missed/num_trials]'); %, 'FaceColor',[0 .5 .5]
%     ylabel('percentage');
%     xlabel('Trial type');
%     % bh(:).BarWidth = 0.5;
%     set(gca, 'XTickLabel', {'Correct', 'Incorrect', 'Missed'});
%     set(gca, 'fontname', 'Arial');
%     title('Perc Corr - Combined');
% end
% 
% %position the figure to the top half of the screen
% 
% if plot_flag == 1
%     fh2 = figure('Position', adjusted_ratio_1);
% 
%     % Plot timeline of trials with correct/incorrect reports
%     ph1 = line([times_incorr_vert_tar, times_incorr_vert_tar]', [zeros(length(times_incorr_vert_tar), 1), ones(length(times_incorr_vert_tar), 1)]', 'color', 'r'); hold on;
%     ph2 = line([times_corr_vert_tar, times_corr_vert_tar]', [zeros(length(times_corr_vert_tar), 1), ones(length(times_corr_vert_tar), 1)]', 'color', 'g');
%     ph3 = line([times_missed_vert_tar, times_missed_vert_tar]', [zeros(length(times_missed_vert_tar), 1), ones(length(times_missed_vert_tar), 1)]', 'color', 'b');
% 
%     ph4 = line([times_incorr_horz_tar, times_incorr_horz_tar]', [zeros(length(times_incorr_horz_tar), 1), -1*ones(length(times_incorr_horz_tar), 1)]', 'color', 'r'); hold on;
%     ph5 = line([times_corr_horz_tar, times_corr_horz_tar]', [zeros(length(times_corr_horz_tar), 1), -1*ones(length(times_corr_horz_tar), 1)]', 'color', 'g');
%     ph6 = line([times_missed_horz_tar, times_missed_horz_tar]', [zeros(length(times_missed_horz_tar), 1), -1*ones(length(times_missed_horz_tar), 1)]', 'color', 'b');
%     title([subject_ID, fname]);
% end
