function SaveCalib(P, subjectNumber)

filename = sprintf('logfiles/sub-%03i_calibration_%s.mat',...
    subjectNumber,day, datestr(now,30));

if exist(filename,'file') == 2
    fprintf(['WARNING: log-file already existed!\n' ...
        'Trying to append new version number: ']);
    I_MAX = 10000;
    [folder, oldFilename, ext] = fileparts(filename);
    for i = 2:I_MAX
        newFilename = sprintf('%s/%s_%i_%s.%s',...
            folder,oldFilename,i,datestr(now,30),ext);
        if ~exist(newFilename,'file')
            filename = newFilename;
            break
        end
    end
    fprintf('%i \n Will write to file %s\n', i, filename);
end

save(filename, 'P','subjectNumber');
fprintf('data saved to file %s\n', filename);
end
