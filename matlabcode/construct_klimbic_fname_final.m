function [t_date,fname] = construct_klimbic_fname_final(fname)
if (length(fname) > 0)
end
if strcmp (fname,'today') == 1
        t_date = date;
    else
        t_date = fname;
    end
    
    d = t_date;
    file = dir([char(d), '*']);
    num_file = numel(file);
    fname = {};
    for i = 1:num_file
%         TF = contains(file(i).name,'combine','IgnoreCase',true);
        TF = strfind(file(i).name,'Combined'); % changed by ninad to make it work on previous version of Matlab
        if isempty(TF)
            fname{i} = file(i).name;
        end
    end
end