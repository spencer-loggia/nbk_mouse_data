%% Script to rename files which do not have an underscore between the month and the year

function correct_klimbic_fnames(input_str)

% input_str = 'today';

if( strcmp(input_str, 'today'))
    t_date = date;
    
    

elseif( isstr(input_str))
    t_date = input_str;
    
    % function still incomplete
    
else
    disp('ERROR - input argument needs to be "today" or a date string');
    return;
end
    
    
% list all files with input date date
l_fnames = dir([t_date(1:6), '*']);

for ii = 1:length(l_fnames)

    c_fname = l_fnames(ii).name;


    if( strcmp( c_fname(7), '-'))
        disp('MSG - date format seems okay');
%             return;
    else
        disp('MSG - fname in wrong format');
        new_fname = [c_fname(1:6), '-', c_fname(7:end)];

        % Also move to back up folder
        mkdir('bkp');
        copyfile(c_fname, ['bkp\', c_fname]); % just do a bkp - this is really not required
        movefile(c_fname, new_fname);
        % list all files

    end

end
        



    