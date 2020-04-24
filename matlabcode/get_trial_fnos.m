
% MOUSE, CAMERA AND SESSION SPECIFIC MANUAL DATA ENTRIES - START


mouse_id = 'mitg05';
ses_date_1 = datestr('2020/04/21', 'mmddyyyy');
ses_date_2 = datestr('2020/04/21');
first_stim_fno_cam1 =  1115; %1065; % CAM1 - 839 - The manually obtained frame no of the stim appearance time of the first trial - using implay
first_stim_fno_cam2 = 910; %CAM2 - 533 - The manually obtained frame no of the stim appearance time of the first trial - using implay

% data below for MiTg11 - 13th April 2020
boxdrives = [{'F:\MysoreData\nbk\box1'}, {'F:\MysoreData\nbk\box2'}, {'F:\MysoreData\nbk\box3'}];
subfolders = [{'.\SCB'}, {'..\MiTg'}];

% in_pre = 'F:\\MysoreData\\nbk\\mitg11_4-13-20\\cam2\\mitg11-533--04132020085315.avi';
% out_pre = 'F:\\MysoreData\\nbk\\mitg11_4-13-20\\cam2\\clips';
in_pre = 'F:\MysoreData\nbk\mouse_videos\';
out_pre = 'F:\MysoreData\nbk\mouse_videos';

% MOUSE, CAMERA AND SESSION SPECIFIC MANUAL DATA ENTRIES - END

% DATA BELOW THIS SHOULD REMAIN SAME FOR ALL SESSIONS AND MICE ON BOX 2
FR = 50; % Hz - camera frame rate
num_cams = 2;
extra_fms_minus = 20;
extra_fms_plus = 20;


file_found_flag = 0; % flag to break the box and subfolder loops if the mouse id is matched
for w = 1:length(boxdrives)
    if(file_found_flag == 1)
        break;
    end
    cd(char(boxdrives(w)));
    for x = 1:length(subfolders)
        if(file_found_flag == 1)
            break;
        end
        cd(char(subfolders(x)));
        
        % list
        file = dir([char([ses_date_2, '_']), '*']);
        if(isempty(file))
            continue;
        end
        num_file = numel(file);
        fname = {};
        for i = 1:num_file
    %         TF = contains(file(i).name,'combine','IgnoreCase',true);
            TF = strfind(file(i).name,'Combined'); % changed by ninad to make it work on previous version of Matlab
            if isempty(TF)
                fname{i} = file(i).name;
            end
        end
        
        num_fname = numel(fname);
        i = 1;
        for i=1:num_fname
            [from_excel_sheet, t_subID] = get_trial_start_end_data_v3(fname{i});
            if(~strcmpi((t_subID), mouse_id))                
                continue;
            else
                file_found_flag = 1; % flag to break the box and subfolder loops if the mouse id is matched
                break; % Note - this is not a good way to code. But, it should be changed if and when multiple mice are to be processed.                
            end
        end
    end
end

% [from_excel_sheet, t_subID] = get_trial_start_end_data_v3(fname);

for ii = 1:num_cams

    stim_disp_t = from_excel_sheet(:,1);
    stim_end_t = from_excel_sheet(:,2);


    rel_tr_st_time_wrt_first_tr = stim_disp_t - repmat(stim_disp_t(1,1), length(stim_disp_t), 1);
    rel_tr_end_time_wrt_first_tr = stim_end_t - repmat(stim_disp_t(1,1), length(stim_disp_t), 1);

    rel_st_fno_wrt_first_tr = ceil(rel_tr_st_time_wrt_first_tr/100*FR);
    rel_end_fno_wrt_first_tr = ceil(rel_tr_end_time_wrt_first_tr/100*FR);

    if(ii == 1) % cam1
        next_stim_start_fno = first_stim_fno_cam1 + rel_st_fno_wrt_first_tr;
        next_stim_end_fno = first_stim_fno_cam1 + rel_end_fno_wrt_first_tr;
    elseif(ii == 2) % cam2
        next_stim_start_fno = first_stim_fno_cam2 + rel_st_fno_wrt_first_tr;
        next_stim_end_fno = first_stim_fno_cam2 + rel_end_fno_wrt_first_tr;
    end
    
    snippet_st_fno = next_stim_start_fno - extra_fms_minus;
    snippet_end_fno = next_stim_end_fno + extra_fms_plus;

    %format for use with snipping script
    snippet_st_fno = max(snippet_st_fno, 1); %remove negative frame indexes
    %Test with manual video path
    
    out = [out_pre, '\', lower(mouse_id), '\', ses_date_1, '\cam', num2str(ii), '\'];
    if(~exist(out, 'dir'))
        mkdir([out_pre, '\', lower(mouse_id), '\'], ses_date_1);
        mkdir([out_pre, '\', lower(mouse_id), '\', ses_date_1], ['cam', num2str(ii)]);
        mkdir([out_pre, '\', lower(mouse_id), '\', ses_date_1, '\cam', num2str(ii)], 'clips');
    end
    if(ii == 1) % cam1
        cam = 'cam1';
        in_path = [in_pre, '\', lower(mouse_id), '\', lower(mouse_id), '-839--', ses_date_1];
        in_fname = dir([in_path, '*']);
    elseif(ii == 2) % cam2
        can = 'cam2';
        in_path = [in_pre, '\', lower(mouse_id), '\', lower(mouse_id), '-533--', ses_date_1];
        in_fname = dir([in_path, '*']);
    else
        disp('ERROR - wrong number of cameras');
        return;
    end
    
    out = [out_pre, '\\', lower(mouse_id), '\\', ses_date_1, '\\cam', num2str(ii), '\\clips'];
    disp([in_fname.folder, '\\', in_fname.name])
    snipVideo([in_fname.folder, '\\', in_fname.name], out, snippet_st_fno, snippet_end_fno)
end