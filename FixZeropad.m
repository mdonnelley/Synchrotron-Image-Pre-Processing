function FixZeropad(folder,filelist,zeropad)

% EXAMPLE: 
% 
% folder = 'I:\Australian Synchrotron\2016-2\Images\Raw\2016-08-23\piglet5lungs\'
% filelist = dir([folder,expt.naming.file_prefix,'*',expt.naming.type]);
% FixZeropad(folder,filelist,zeropad);

for i=1:length(filelist),
    oldname = filelist(i).name;
    pos = max(strfind(oldname,'_'));
    count = oldname(pos+1:length(oldname)-4);
    if length(count) < 4,
        newname = [oldname(1:pos),sprintf(['%.',num2str(zeropad),'d'],str2num(count)),oldname(length(oldname)-3:length(oldname))]
        movefile([folder,oldname],[folder,newname]);
    end
end