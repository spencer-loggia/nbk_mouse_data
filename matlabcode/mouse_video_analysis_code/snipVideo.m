%%Script to extract clip of video, defined by a total number of frames and
%%start time, to be used in combination with another script that dermines
%%stimulous onset times. 
%%params: 
    %full_video_path: path to origanal mouse video
    %out_dir: directory to put output clips in
    %start_frames: list of frame numbers to begin each clip at
    %n: desired length of each clip
%%return: 0 if fails, 1 if successful 

function isSuccess = snipVideo(full_video_path, out_dir, start_frames, n)
    v = VideoReader(full_video_path);
    ext_loc = strfind(full_video_path, '.');
    path_no_ext = full_video_path(1:ext_loc-1);
    if strcmp(out_dir(length(out_dir)), '\\') == 0
        out_dir = strcat(out_dir, '\\\');
    end
    disp(path_no_ext)
    try
        for i = 1:length(start_frames)
            ind = start_frames(i);
            clip = read(v, [ind, ind+n]);
            vw = VideoWriter(strcat(out_dir, v.name, '_clip_', num2str(i), '.avi'));
            open(vw)
            writeVideo(vw, clip)
            close(vw)
        end
    catch 
        warning("Snipping video failed. Check file formats and for valid start frame numbers, clip lengths")
        isSuccess = 0;
        return
    end
    isSuccess = 1;
    return
end
