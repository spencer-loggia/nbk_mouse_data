function [fname] = convert_mouse_id_to_file_name(fname)

% Behavior data script
% first cd to directory with behavior data

% cd D:\Postdoc_Mysore_lab\Research_data\behavior
%clear all; close all;

% new fname would be '27-May-2019_MiTg01'
%fname = ['29-May-2019_SCB_2', '.csv'];
d = fname([1:11]);
%delete - 4 after i put the function inside the calling function
mouse_id = fname([13:end]);
%mouse_id = fname([13:end-4]);
subject_ID = {};

file = dir([d, '*']);
num_file = numel(file);
fname = {};
    for i = 1:num_file
        TF = contains(file(i).name,'combine','IgnoreCase',true);
        if TF == 0
            fname{i} = file(i).name;
        end
    end
num_file = numel(fname);

delimiter = ',';
startRow = 1;
endRow = 400;
choice_rep_index = 8; % Index into matrix for when mouse reported its choice by nose poke
target_vis_index = 7; % Index into matrix for when target was visible on screen
formatSpec = '%s%s%[^\n\r]'; % first column is to be read as a string and the remaining as they are

for i = 1:num_file
    fileID = fopen(fname{i},'r');
    dataArray = textscan(fileID, formatSpec, endRow(1), 'Delimiter', delimiter, 'ReturnOnError', false);
    %fclose(fileID);
%end

% search for protocol title
STARTDATA = dataArray{1,1};
[linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('Protocol Title', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);


%for i = 1:num_file
    % verify if in the correct protocol
    %fileID = fopen(fname{i},'r');
    bb = textscan(fileID,'%s%s',1,'delimiter',',', 'headerlines',linenum);
    fclose(fileID);
   

    if(strcmp(bb{1,2}, 'grating orientation discrimination with punishment') == 0)
        disp('ERROR - wrong protocol file - this script only works for nbkshaping_06');
        return;
    end

    % Get subject ID
    [linenum] = find(cellfun(@strcmp, STARTDATA, mat2cell(repmat('Subject Id', length(STARTDATA), 1), ones(length(STARTDATA),1))) == 1);
    subject_ID{i} = dataArray{1,2}{linenum,1};
end

%subject_ID

num_sub = numel(subject_ID);

for i = 1:num_sub
    if strcmp(mouse_id, subject_ID{i}) == 1
        fname = fname{i}
    end
end

%if strcmp (mouse_id, subject_ID) == 1
    