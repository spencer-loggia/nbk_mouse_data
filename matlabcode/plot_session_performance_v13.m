

%% ABOUT CODE - plot_session_performance_v8.m
% This code computes data for mouse performance 

%% REFERENCE NOTES

%% CODE FIXES
%   Date                Author                  Description
% 01/01/2019        Ninad B. Kothari            displays data for mouse performance data

% %06/17/2019         Sarah K. Coreas              identifies system name and runs corresponding for loop
%                                                  call function and switch case to display vertical and horizontal trials as appropriate up and down pokes   
%                                                  implemented display type flag
% 
% 06/20/2019        Jessica Zhang               adds plot_flage to plot graphs when required or only shows data without graphs when necessary
% 06/27/2019        Jessica Zhang               makes this script into a function
% %% WARNINGS
%                       DESCRIPTION                                                                                     STATUS

%%  BUGS AND THINGS TO BE IMPLEMENTED
%                       DESCRIPTION                                                                                     STATUS

%% CODE% Behavior data script

% first cd to directory with behavior data

%% TODO: add flag that will return output as object: total trials, correct, incorrect, poke up, poke down, accuracy, water consumed
% cd D:\Postdoc_Mysore_lab\Research_data\behavior
 function data = plot_session_performance_v13(fname,plot_flag)
%clear all; close all;
% plot_flag = 0;
% fname = ['01-Jul2019_001', '.csv'];
% fname = ['19-Dec-2018_001', '.csv'];

delimiter = ',';
startRow = 1;
endRow = 400;
choice_rep_index = 8; % Index into matrix for when mouse reported its choice by nose poke
target_vis_index = 7; % Index into matrix for when target was visible on screen

formatSpec = '%s%s%[^\n\r]'; % first column is to be read as a string and the remaining as they are
fileID = fopen(fname,'r');
dataArray = textscan(fileID, formatSpec, endRow(1), 'Delimiter', delimiter , 'ReturnOnError', false);
fclose(fileID);

default = fileread(fname);
default = regexp(default,'\n','split');
default = default';
dataArray1 = [];
dataArray2 = [];
lines = [];
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
    lines{jj,1} = [cell2mat(dataArray2{1,1}{jj,1}), ',', cell2mat(dataArray2{1,2}{jj,1}), ',', cell2mat(dataArray2{1,3}{jj,1})];
end
% dataArray1 = dataArray1';
% NOTE - this is another way to read the entire csv file (with empty lines)
% default = fileread(fname);
% default = regexp(default,'\n','split');

display_type_flag = 0;

% image_name_list_lineno = 41; % Hopefully this remains constant - no longer this BS
% protocol_database_lineno = 23; % Hopefully this remains constant - no longer this BS

% search for - image list line number
STARTDATA = dataArray2{1,1};
[protocol_database_lineno] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('DB Ref', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);

% search for - image list line number
[image_name_list_lineno] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('01_cross', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
if(isempty(image_name_list_lineno))
    [image_name_list_lineno] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('01_corss', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1); % How stupid
end

% search for - image list line number
[fluid_count_entry_lineno] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('Fluid Count', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);


% search for 
STARTDATA = dataArray2{1,1};
[prot_tit_linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('Protocol Title', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);


%commented out to remove issues with textscan in matlab 2017b and later verify if in the correct protocol - don't need this anymore
% fileID = fopen(fname,'r');
% bb = textscan(fileID,'%s%s',1,'delimiter',',', 'headerlines',prot_tit_linenum);
% fclose(fileID);
% 
% if((strcmp(bb{1,2}, 'grating orientation discrimination with punishment') == 1) || (strcmp(bb{1,2}, 'orientation discrimination with punishment (prev bug removed)') == 1) ...
%          || (strcmp(bb{1,2}, 'grating orientation discrimination with punishment and distractors (bug fixed)') == 1))
%     
% else
%     disp('ERROR - wrong protocol file - this script only works for nbkshaping_06 or 07');
%     return;
% end

% Get subject ID
[sub_linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('Subject Id', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
subject_ID = cell2mat(dataArray2{1,2}{sub_linenum,1});

% Get total number of trials
fileID = fopen(fname,'r');
lines = textscan(fileID, '%s', 'Delimiter', '\n');
fclose(fileID);

% num_lines = length(lines{1,1});
num_lines = length(dataArray2{1,1});

% t_val = textscan(dataArray2{1,1}{num_lines-1,1}, '%s%s%[\n\r]', 'Delimiter', ',');
num_trials = str2num(cell2mat(dataArray2{1,1}{num_lines-1,1}));

% Get protocol name
if(contains(dataArray2{1,2}{protocol_database_lineno, 1}, 'nbk_shaping07'))
    protocol_name = 'nbk_shaping07';
elseif(contains(dataArray2{1,2}{protocol_database_lineno, 1}, 'nbk_shaping06'))
    protocol_name = 'nbk_shaping06';
elseif(contains(dataArray2{1,2}{protocol_database_lineno, 1}, 'nbk_shaping04'))
    protocol_name = 'nbk_shaping04';
else
    disp('ERROR - wrong protocol file - this script only works for nbkshaping_06 or 07');
    protocol_name = 'wrong';
    return
end

% Perform analysis for nbk_shaping04 - no need of rest of the script
if(strcmp(protocol_name, 'nbk_shaping04') == 1)
    if(strcmp(dataArray2{1,1}{fluid_count_entry_lineno, 1}, 'Fluid Count') == 1)
        fluid_count = str2num(cell2mat(dataArray2{1,2}{fluid_count_entry_lineno, 1}));
        data = MouseData(subject_ID, fluid_count, 0, 0, fluid_count, 0, 0, 0);
        return;
    else
        disp('ERROR - wrong Fluid Count Entry');
        return
    end
    
end

% Read all trials into a matrix
% add a for loop here

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

% Convert times to minutes
tar_vis_times = t_mat(:,target_vis_index)/6000; % mins
tar_rep_times = t_mat(:,choice_rep_index)/6000; % mins

% Find line number of 'Image Table' Start and End
[img_tab_linenum_st] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('ImageTableStart', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);

[img_tab_linenum_end] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('ImageTableEnd', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);

% Get the offset position of the 'image_index' - This varies between nbk_shaping07 and 06 :(
[target_image_linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('W2', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);

% error checking - there should be only a single W2 (within image table)
if(length(target_image_linenum) ~= 1)
    disp('ERROR - multiple W2 instances found within Image Table');
    target_image_linenum = target_image_linenum(1);
%     return;
end

% error checking - target_image_linenum should lie within the Image Table Limits
if((target_image_linenum(1) > img_tab_linenum_end) || (target_image_linenum(1) < img_tab_linenum_st))
    disp('ERROR - W2 lies outside Image Table limits');
    return;
end

% NOTE - the current fix will only work if ERROR TRIALS are NOT repeated 
if(strcmp(protocol_name, 'nbk_shaping07') || strcmp(protocol_name, 'nbk_shaping06'))
    % get image name array
    t_count = length(strfind(lines{1,1}{(image_name_list_lineno),1}, ','));
    image_name_list = textscan(lines{1,1}{(image_name_list_lineno),1}, [repmat('%s', 1,t_count),], 'Delimiter', ',');

    % error checking
    if(~strcmp(image_name_list{1,1}, '01_cross') && ~strcmp(image_name_list{1,1}, '01_corss'))
        disp('ERROR - First image name is not 01_cross - this does not seem to be right');
        return;
    end

    % get start of image table
    % Get Window 2 (Target image Index)
%     [img_tab_linenum_st] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('ImageTableStart', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
    text_val = lines{1,1}{target_image_linenum+1,1};
    t_count = length(strfind(text_val, ','));
    t_cell = textscan(lines{1,1}{(target_image_linenum+1),1}, ['%s', repmat('%d', 1,t_count-1),], 'Delimiter', ',');

    % error checking
    if(~strcmp(t_cell{1,1}, 'ImageIndex'))
        disp('ERROR - Target image index extraction does not seem correct');
        return;
    end

    if((t_count-1) < 140)
        disp('ERROR - Num target images not equal to 200');
%         return;
    end

    target_type = [];
    for jj = 2:t_count
        t_image_ind = (t_cell{1,jj});
        t_image_name = image_name_list{1, t_image_ind+1};
        if(strcmp(t_image_name{1,1}(1:2), 'vt'))
            target_type = [target_type, 0];
        elseif(strcmp(t_image_name{1,1}(1:2), 'hz'))
            target_type = [target_type, 1];
        else
            disp('ERROR - Image not vt or hz');
        end
    end

    % limit target_type to the actual number of trials
    if(num_trials > 200)
        num_trials = 200;
        disp('WARNING - number of trials exceeded 200 - restricting analysis to 200 only');
        t_mat = t_mat(1:200,:);
        tar_vis_times = tar_vis_times(1:200);
        tar_rep_times = tar_rep_times(1:200);
        
    end
    % NOTE - the below code is a temporary hack. This has to be FIXED
    if(length(target_type) < num_trials)
        num_trials = length(target_type);
        target_type = target_type(1:num_trials)';
        disp('WARNING - number of trials performed does not match the image discrimination length - FIX THIS');
        t_mat = t_mat(1:num_trials,:);
        tar_vis_times = tar_vis_times(1:num_trials);
        tar_rep_times = tar_rep_times(1:num_trials);
    else
        target_type = target_type(1:num_trials)';
    end
else % must be nbk_shaping06
    target_type = t_mat(:,3); % 0 - vert, 1 - horiz
end

corr_choice = -1*t_mat(:,2);
corr_choice(corr_choice == 0) = 1; % 1 - corr, -1 - incorr, -2 - missed

% correct/incorrect vert/horiz target presentation times
times_corr_vert_tar = tar_vis_times(find((target_type == 0) & (corr_choice == 1)));
% times_corr_vert_tar = tar_vis_times(find(((target_type == 0) | (target_type == 2)  | (target_type == 3)) & (corr_choice == 1)));
times_incorr_vert_tar = tar_vis_times(find((target_type == 0) & (corr_choice == -1)));
% times_incorr_vert_tar = tar_vis_times(find(((target_type == 0) | (target_type == 2)  | (target_type == 3)) & (corr_choice == -1)));
times_missed_vert_tar = tar_vis_times(find((target_type == 0) & (corr_choice == -2)));
% times_missed_vert_tar = tar_vis_times(find(((target_type == 0) | (target_type == 2)  | (target_type == 3)) & (corr_choice == -2)));

times_corr_horz_tar = tar_vis_times(find((target_type == 1) & (corr_choice == 1)));
times_incorr_horz_tar = tar_vis_times(find((target_type == 1) & (corr_choice == -1)));
times_missed_horz_tar = tar_vis_times(find((target_type == 1) & (corr_choice == -2)));


% reaction times
rxn_time = tar_rep_times*60 - tar_vis_times*60; % seconds - reaction time - is this correct?

rt_corr_vert_choice = rxn_time(find((target_type == 0) & (corr_choice == 1)));
rt_incorr_vert_choice = rxn_time(find((target_type == 0) & (corr_choice == -1)));

rt_corr_horz_choice = rxn_time(find((target_type == 1) & (corr_choice == 1)));
rt_incorr_horz_choice = rxn_time(find((target_type == 1) & (corr_choice == -1)));


% Percent correct/incorrect
% corr_vert_choice = sum( corr_choice( find((target_type == 0) | (target_type == 2)  | (target_type == 3))) == 1);
% incorr_vert_choice = sum( corr_choice( find((target_type == 0) | (target_type == 2)  | (target_type == 3))) == -1);
% missed_vert_choice = sum( corr_choice( find((target_type == 0) | (target_type == 2)  | (target_type == 3))) == -2);
corr_vert_choice = sum( corr_choice( find((target_type == 0))) == 1);
incorr_vert_choice = sum( corr_choice( find((target_type == 0))) == -1);
missed_vert_choice = sum( corr_choice( find((target_type == 0))) == -2);

% corr_vert_choice = sum( corr_choice( find(target_type == 0)) == 1);
% incorr_vert_choice = sum( corr_choice( find(target_type == 0)) == -1);
% missed_vert_choice = sum( corr_choice( find(target_type == 0)) == -2);
corr_horz_choice = sum( corr_choice( find(target_type == 1)) == 1);
incorr_horz_choice = sum( corr_choice( find(target_type == 1)) == -1);
missed_horz_choice = sum( corr_choice( find(target_type == 1)) == -2);

% verify num trials
num_trials_tot = corr_vert_choice + incorr_vert_choice + missed_vert_choice + corr_horz_choice + incorr_horz_choice + missed_horz_choice;
if(num_trials ~= num_trials_tot)
    disp('ERROR - num trials do not match');
    return;
end


% Plot Reaction Times - separate and combined
% stuff to add here 
% add numbers over each column

screensize = get(0,'screensize');
l = screensize(1,3);
w = screensize(1,4);
adjusted_ratio_1 = [l/300 w/2-w/15+0.09*w l-l/250 w/2-w/100-0.09*w];
adjusted_ratio_2 = [l/300 w*0.04 l*2/3-l/250 w/2-w/10];
adjusted_ratio_3 = [l/300+l*2/3-l/250 w*0.04 (l*2/3-l/250)*0.00046*w w/2-w/10];

if plot_flag == 1
    fh3 = figure('Position', adjusted_ratio_3); 

    title([subject_ID, fname]);
    subplot(121);
    % bh2 = bar([[mean(rt_corr_vert_choice), mean(rt_incorr_vert_choice)]', ... 
    %         [mean(rt_corr_horz_choice), mean(rt_incorr_horz_choice)]']'); %, 'FaceColor',[0 .5 .5]
    bh2 = bar([[median(rt_corr_vert_choice), median(rt_incorr_vert_choice)]', ... 
            [median(rt_corr_horz_choice), median(rt_incorr_horz_choice)]']'); %, 'FaceColor',[0 .5 .5]
    ylabel('Median Reaction Times (secs)');
    xlabel('Trial type');
    % bh(:).BarWidth = 0.5;
    set(gca, 'XTickLabel', {'Vertical', 'Horizontal'});
    set(gca, 'fontname', 'Arial');
    legend({'Correct', 'Incorrect'});
    title('Rxn times - separate');

    subplot(122);
    bh2 = bar([mean([rt_corr_vert_choice; rt_corr_horz_choice]), mean([rt_incorr_vert_choice; rt_incorr_horz_choice])]');
    % bh2 = bar([[median(rt_corr_vert_choice), median(rt_incorr_vert_choice)]', ... 
    %         [median(rt_corr_horz_choice), median(rt_incorr_horz_choice)]']'); %, 'FaceColor',[0 .5 .5]
    ylabel('Mean Reaction Times (secs)');
    xlabel('Trial type');
    % bh(:).BarWidth = 0.5;
    set(gca, 'XTickLabel', {'Correct', 'Incorrect'});
    set(gca, 'fontname', 'Arial');
    title('Rxn times - combined');
end

tot_vert_trials = corr_vert_choice+incorr_vert_choice+missed_vert_choice;
tot_horz_trials = corr_horz_choice+incorr_horz_choice+missed_horz_choice;
tot_corr = corr_horz_choice+corr_vert_choice;
tot_incorr = incorr_vert_choice+incorr_horz_choice;
tot_missed = missed_vert_choice+missed_horz_choice;
tot_trials = tot_corr + tot_incorr + tot_missed;

value_of_y = get_mouse_choice_f_v2(subject_ID);

perc_corr_vert = (corr_vert_choice/tot_vert_trials)*100;
perc_corr_horz = (corr_horz_choice/tot_horz_trials)*100;
perc_corr_tot = (tot_corr/tot_trials)*100;




if value_of_y==1
   perc_corr_up = perc_corr_vert;
   perc_corr_dn = perc_corr_horz ;
          
else
    perc_corr_up = perc_corr_horz;
    perc_corr_dn = perc_corr_vert;     
end

data = MouseData(subject_ID, tot_corr, tot_incorr, tot_missed, tot_trials, perc_corr_tot, perc_corr_up, perc_corr_dn);

if  display_type_flag ==1

disp(sprintf('Mouse ID - %s \nDate - %s \nTot trials-%d, \nTot Correct-%d, \nTot Incorr-%d, \nTot Missed-%d, \nPerc tot Corr-%2.1f, \nPerc up Corr-%2.1f, \nPerc dn Corr-%2.1f', ...
            subject_ID, fname, tot_trials, tot_corr, tot_incorr, tot_missed, perc_corr_tot, perc_corr_up, perc_corr_dn));

else 
    
disp(sprintf('Mouse ID- %s \nDate - %s \n%d \n%d \n%d \n%2.1f \n%2.1f \n%2.1f', ...
        subject_ID, fname, tot_trials, tot_corr, tot_incorr, perc_corr_tot, perc_corr_up, perc_corr_dn));
    

end

% Plot percent/num correct/incorrect/missed
% stuff to add here 
% add numbers over each column

if plot_flag == 1
    fh1 = figure('Position', adjusted_ratio_2); 
    subplot(131);
    bh1 = bar([[tot_vert_trials, corr_vert_choice, incorr_vert_choice, missed_vert_choice]', ... 
        [tot_horz_trials, corr_horz_choice, incorr_horz_choice, missed_horz_choice]']'); %, 'FaceColor',[0 .5 .5]
    ylabel('Number of trials');
    xlabel('Trial type');
    % bh(:).BarWidth = 0.5;
    set(gca, 'XTickLabel', {'Vertical', 'Horizontal'});
    set(gca, 'fontname', 'Arial');
    legend({'Total', 'Correct', 'Incorrect', 'Missed'});
    title([subject_ID, fname]);

    subplot(132);
    bh2 = bar([[corr_vert_choice/tot_vert_trials, incorr_vert_choice/tot_vert_trials, missed_vert_choice/tot_vert_trials]', ... 
        [corr_horz_choice/tot_horz_trials, incorr_horz_choice/tot_horz_trials, missed_horz_choice/tot_horz_trials]']'); %, 'FaceColor',[0 .5 .5]
    ylabel('percentage');
    xlabel('Trial type');
    % bh(:).BarWidth = 0.5;
    set(gca, 'XTickLabel', {'Vertical', 'Horizontal'});
    set(gca, 'fontname', 'Arial');
    legend({'Correct', 'Incorrect', 'Missed'});
    title('Perc Corr - separate');

    subplot(133);
    bh = bar([tot_corr/num_trials, tot_incorr/num_trials, tot_missed/num_trials]'); %, 'FaceColor',[0 .5 .5]
    ylabel('percentage');
    xlabel('Trial type');
    % bh(:).BarWidth = 0.5;
    set(gca, 'XTickLabel', {'Correct', 'Incorrect', 'Missed'});
    set(gca, 'fontname', 'Arial');
    title('Perc Corr - Combined');
end

%position the figure to the top half of the screen

if plot_flag == 1
    fh2 = figure('Position', adjusted_ratio_1);

    % Plot timeline of trials with correct/incorrect reports
    ph1 = line([times_incorr_vert_tar, times_incorr_vert_tar]', [zeros(length(times_incorr_vert_tar), 1), ones(length(times_incorr_vert_tar), 1)]', 'color', 'r'); hold on;
    ph2 = line([times_corr_vert_tar, times_corr_vert_tar]', [zeros(length(times_corr_vert_tar), 1), ones(length(times_corr_vert_tar), 1)]', 'color', 'g');
    ph3 = line([times_missed_vert_tar, times_missed_vert_tar]', [zeros(length(times_missed_vert_tar), 1), ones(length(times_missed_vert_tar), 1)]', 'color', 'b');

    ph4 = line([times_incorr_horz_tar, times_incorr_horz_tar]', [zeros(length(times_incorr_horz_tar), 1), -1*ones(length(times_incorr_horz_tar), 1)]', 'color', 'r'); hold on;
    ph5 = line([times_corr_horz_tar, times_corr_horz_tar]', [zeros(length(times_corr_horz_tar), 1), -1*ones(length(times_corr_horz_tar), 1)]', 'color', 'g');
    ph6 = line([times_missed_horz_tar, times_missed_horz_tar]', [zeros(length(times_missed_horz_tar), 1), -1*ones(length(times_missed_horz_tar), 1)]', 'color', 'b');
    title([subject_ID, fname]);
end



% Steps 
% - First check whether I have the correct protocol                                                                                                                 DONE
% - I need to redo the open-klimbic function to allow getting about 400 rows and columns.                                                                           DONE
% - get total number of trials                                                                                                                                      DONE
% - type of image presented on which trial                                                                                                                          DONE
% - get the time at which each image was presented                                                                                                                  DONE


% Here re the thingsto do now
% 1) get number of vertical and horizontal images presented
% 2) get number of correct for vertical and horizontal                                                                                                              DONE
% 3) Get time line of how the choices are presented and whether they were correct or not                                                                            DONE
% 4) Get average reaction time of the mouse from image presentatoin till choice report for correct horizontal, vertical, incorrect horizontal and vertical
% 5) Pot time line of image presentation with corr/incorr/missed choices all plotted in diff colors                                                                 DONE
% 6) Plot reaction times for correct/incorrect/missed according to trial type





















