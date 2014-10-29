function [] = processEvent2mat(filefunc, eventstruct,rawsubdir,outputsubdir, test, peakonly)
%%% [] = processEvent2mat(filefunc, eventstruct,rawsubdir,outputsubdir)
% filefunc = a function to apply to each mat file which returns a struct
%            this should take the outdir as a parameter in case images
%            /logs need to be saved there
% eventstruct = the struct which contains dirname and files (a list of mat
% files)
% rawsubdir = subdirectory in which the original mat file is saved
% outputsubdir = subdirectory the resulting structs will be saved to

% process each event folder
if nargin < 6
    peakonly = 0;
end
if nargin < 5
    test = 0;
end
    pathroot = fullfile(eventstruct.dirname,rawsubdir);

    % make the subdir
    outdir = fullfile(eventstruct.dirname,outputsubdir);
    if ~isdir(outdir)
        mkdir(eventstruct.dirname,outputsubdir);
        if test
            disp('creating subdir');
        end
    end

    % process files
    numfiles = length(eventstruct.files);
    if peakonly == 0
        for f=1:numfiles
            fname = eventstruct.files(f).name;
            infile = matfile(fullfile(pathroot,fname));

            % pass in the outdir in case we want to save images
            savestruct = filefunc(infile,outdir,fname);

            % we deal with saving as mat files here:
            fnamefull = fullfile(outdir,fname);
            save(fnamefull,'savestruct');


        end
    else
        % ONLY PEAK
        fname = eventstruct.files(numfiles).name;
            infile = matfile(fullfile(pathroot,fname));

            % pass in the outdir in case we want to save images
            savestruct = filefunc(infile,outdir,fname);

            % we deal with saving as mat files here:
            fnamefull = fullfile(outdir,fname);
            save(fnamefull,'savestruct');
    end
     if test
        fprintf('Done with %s \n',eventstruct.dirname);
     end
end