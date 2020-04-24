function calling_final(fname, plot_flag)

%plot_flag = 0 shows only the data in the command window, plot_flag =1
%shows the graphs and the data
% plot_flag = 0;

% enter a file name with one of the format: 'today', a specific date (e.g.,
% 27-May-2019), a specific date with a mouse order (e.g., 27-May-2019_001),
% or a specific date with a mouse id (e.g., 27-May-2019_SCB05)
% fname = 'today';


% if the fname is '18-Jun-2019_MiTg01' instead of the number at end, 
% insert the get_mouse_id function which convert the mouse id into the
% order number

%The array that defines the expected mice in all cohorts. Print occurs in
%this order, with null colunms in place of data for mice that were not
%trained
EXPECTED_IDS = [{'MiTg01'}, {'MiTg02'}, {'MiTg03'}, {'MiTg04'}, {'MiTg05'}, {'MiTg06'}, {'MiTg07'}, {'MiTg08'}, {'MiTg09'}, {'MiTg10'}, {'MiTg11'}, {'MiTg12'}, {'SCB_2'}, {'SCB05'}, {'SCB06'}];

%add the matlab code folder to the current path
addpath('F:\MysoreData\nbk\matlabcode');

boxdrives = [{'F:\MysoreData\nbk\box1'}, {'F:\MysoreData\nbk\box2'}, {'F:\MysoreData\nbk\box3'}];
subfolders = [{'.\SCB'}, {'..\MiTg'}];

L = length(fname);

if L == 17 || L == 18
    fname = convert_mouse_id_to_file_name(fname);
end

year_str = fname(end-3:end);
year_num = str2double(year_str);
order_id = fname(end-2:end);
order_num = str2double(order_id);

if strcmp(fname,'today') == 1 || (isnumeric(year_num) == 1 && L == 11)
    dataArray = zeros(7, length(EXPECTED_IDS));
    for w = 1:length(boxdrives)
        cd(char(boxdrives(w)));
        for x = 1:length(subfolders)
            cd(char(subfolders(x)));
            correct_klimbic_fnames(fname);
            if length(fname) > 4
                [date, fname_arr] = construct_klimbic_fname_final(fname);
                
            else
                continue
            end
           
            
            num_fname = numel(fname_arr);
            i = 1;
            while i <= num_fname
                data = plot_session_performance_v8(fname_arr{i}, plot_flag);
                z = 1;
                while strcmp(data.name, char(EXPECTED_IDS(z))) == 0 && z <= 15
                    z = z + 1;
                end
                dataArray(:,z) = data.toColumn;
                i = i + 1;
            end
        end
    end
%     dataArray = num2cell(dataArray);
%     dataArray = cell2table(dataArray);
    disp('MiTg data');
    
    for jj = 1:size(dataArray, 1)
        
        for kk = 1:size(dataArray, 2)
            t_val = dataArray(jj, kk);
            disp(sprintf('%2.2f \t', t_val));
%             sprintf('%2.2f\t', t_val)
        end
        disp('\n');
    end
    
    disp(dataArray(:,1:12));
    disp('SCB data');
    disp(dataArray(:,13:15))
else
    if isnumeric(order_num) == 1 && L == 15
        plot_session_performance_v8([fname, '.csv'], plot_flag)
    elseif L == 17 || L == 18
        plot_session_performance_v8(fname, plot_flag)
    else
       disp('ERROR. Wrong file name format')
    end
end 
