%function data = WriteS8Data

row = 1;
clear data

% Determine the save location
[FileName,PathName] = uiputfile(expt.file.filelist,'Save file name');

% Get the list of dates in the folder
date_dir = [basepath,expt.file.raw];
date_list = dir(date_dir);

% Check each day folder
for i = 3:length(date_list)
    
    if date_list(i).isdir,
        
        % Get the list of animals in the folder
        animal_dir = date_list(i).name;
        animal_list = dir([date_dir,animal_dir,'/',expt.file.folder_prefix,'*']);
        
        % Check each animal folder
        for j = 1:length(animal_list),
            
            if animal_list(i).isdir,
                
                % Get the list of images
                image_dir = animal_list(j).name;
                
                %% Check if there are flat files present
                image_list = dir([date_dir,animal_dir,'/',image_dir,'/*',expt.file.flat_prefix,'*',expt.file.type]);
                
                if ~isempty(image_list),
                    
                    % Determine the data for the spreadsheet
                    flat = [animal_dir,'/',image_dir,'/'];
                    flatstart = image_list(1).name;
                    flatstart = flatstart(1:length(flatstart)-8);
                    flatgofrom = image_list(1).name;
                    flatgofrom = str2num(flatstart(length(flatstart)-7:length(flatstart)-4));
                    flatgoto = image_list(length(image_list)).name;
                    flatgoto = str2num(flatgoto(length(flatgoto)-7:length(flatgoto)-4));
                    
                    % Add the data to the sheet
                    data{row,6} = flat;
                    data{row,7} = flatstart;
                    data{row,8} = flatgofrom;
                    data{row,9} = flatgoto;
                    data{row,10} = expt.file.type;
                    
                end
                
                %% Check if there are dark files present
                image_list = dir([date_dir,animal_dir,'/',image_dir,'/*',expt.file.dark_prefix,'*',expt.file.type]);
                
                if ~isempty(image_list),
                    
                    % Determine the data for the spreadsheet
                    dark = [animal_dir,'/',image_dir,'/'];
                    darkstart = image_list(1).name;
                    darkstart = darkstart(1:length(darkstart)-8);
                    darkgofrom = image_list(1).name;
                    darkgofrom = str2num(darkgofrom(length(darkgofrom)-7:length(darkgofrom)-4));
                    darkgoto = image_list(length(image_list)).name;
                    darkgoto = str2num(darkgoto(length(darkgoto)-7:length(darkgoto)-4));
                    
                    % Add the data to the sheet
                    data{row,6} = dark;
                    data{row,7} = darkstart;
                    data{row,8} = darkgofrom;
                    data{row,9} = darkgoto;
                    data{row,10} = expt.file.type;
                    
                end
                
                %% Get the list of all experiment files with the expt.file.file_prefix
                image_list = dir([date_dir,animal_dir,'/',image_dir,'/',expt.file.file_prefix,'*',expt.file.run_prefix,'*',expt.file.type]);
                
                if ~isempty(image_list),
                    
                    % Determine the number of runs
                    pos = strfind(image_list(length(image_list)).name,expt.file.run_prefix);
                    runs = str2num(image_list(length(image_list)).name(pos+2:pos+3));
                    
                    % Check the number of images for each run
                    for k = 1:runs
                        
                        % Get the list of files for the run
                        run_dir = sprintf('%s%s%.2d_',image_list(length(image_list)).name(1:pos-1),expt.file.run_prefix,k);
                        run_list = dir([date_dir,animal_dir,'/',image_dir,'/',run_dir,'*',expt.file.type]);
                        
                        % Determine the data for the spreadsheet
                        image = [animal_dir,'/',image_dir,'/'];
                        imagestart = run_dir;
                        imagegofrom = run_list(1).name;
                        imagegofrom = str2num(imagegofrom(length(imagegofrom)-7:length(imagegofrom)-4));
                        imagegoto = run_list(length(run_list)).name;
                        imagegoto = str2num(imagegoto(length(imagegoto)-7:length(imagegoto)-4));
                        
                        % Add the data to the sheet
                        data{row,1} = image;
                        data{row,2} = imagestart;
                        data{row,3} = imagegofrom;
                        data{row,4} = imagegoto;
                        data{row,5} = expt.file.type;
                        
                        % Display the current dataset then increment the row counter
                        data(row,:)
                        row = row + 1;
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
end

% Write out the spreadsheet
xlswrite([PathName,FileName],data);
