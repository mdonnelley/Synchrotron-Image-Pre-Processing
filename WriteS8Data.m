% Script to produce an file list of all files acquired during a beamtime
%
% setbasepath
% S8_15B_XU
% WriteS8Data

if isfield(expt.naming,'zeropad') zeropad = expt.naming.zeropad; else zeropad = 4; end

row = 1;
clear data

% Determine the save location
[FileName,PathName] = uiputfile(expt.file.filelist,'Save file name');

% Get the list of dates in the folder
date_dir = fullfile(basepath,expt.file.raw);
date_list = dir(date_dir)

% Check each day folder
for i = 3:length(date_list)
    
    if date_list(i).isdir,
        
        % Get the list of samples in the folder
        sample_dir = date_list(i).name;
        sample_list = dir(fullfile(date_dir,sample_dir,[expt.naming.folder_prefix,'*']));
        
        % Check each sample folder
        for j = 1:length(sample_list),
            
            if sample_list(j).isdir,
                
                % Get the list of images
                image_dir = sample_list(j).name;
                
                %% Check if there are flat files present
                image_list = dir(fullfile(date_dir,sample_dir,image_dir,['*',expt.naming.flat_prefix,'*',expt.naming.type]));
                if ~isempty(image_list),
                    data{row,6} = fullfile(sample_dir,image_dir);
                    outfile = regexp(image_list(i).name,'_|\.','split');
                    data{row,7} = [outfile{1},'_'];
                end
                
                %% Check if there are dark files present
                image_list = dir(fullfile(date_dir,sample_dir,image_dir,['*',expt.naming.dark_prefix,'*',expt.naming.type]));
                if ~isempty(image_list),
                    data{row,11} = fullfile(sample_dir,image_dir);
                    outfile = regexp(image_list(i).name,'_|\.','split');
                    data{row,12} = [outfile{1},'_'];
                end
                
                %% Get the list of all experiment files with the expt.naming.file_prefix
                image_list = dir(fullfile(date_dir,sample_dir,image_dir,[expt.naming.file_prefix,'*',expt.naming.run_prefix,'*',expt.naming.type]));
                if ~isempty(image_list),
                    
                    % Determine the ID and number of runs
                    a = image_list(length(image_list)).name;
                    b = erase(a,expt.naming.file_prefix);
                    c = split(b,expt.naming.run_prefix);
                    ID = str2num(c{1}(1:2));
                    runs = str2num(c{2}(1:2));

                    % Add each run
                    for k = 1:runs,

                        % Get the list of files for the run
                        imagepath = fullfile(sample_dir,'/',image_dir,'/');
                        imagestart = sprintf('%s%.2d%s%.2d',expt.naming.file_prefix,ID,expt.naming.run_prefix,k);
                        run_list = dir(fullfile(date_dir,imagepath,[imagestart,'*',expt.naming.type]));
                     
                        if ~isempty(run_list),

                            outfile = regexp(run_list(1).name,'_|\.','split');
                            data{row,1} = imagepath;
                            data{row,2} = [outfile{1},'_'];

                            % Display the current dataset then increment the row counter
                            data(row,:)
                            row = row + 1;

                        end
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
end

% Write out the spreadsheet
xlswrite([PathName,FileName],data);
