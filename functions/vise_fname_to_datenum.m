% function to convert VISE####### file names to MATLAB date
function timestamp = vise_fname_to_datenum(f)

% find the part with the VISE filename
viseind = strfind(f,'VISE');%regexp(f, pattern, 'match')
year = str2double(f(viseind+4));

if year >= 6
    year = 1990 + year;
elseif year < 5
    year = 2000 + year;
end

dayofyear = str2double(f(viseind+5:viseind+7));

datematlab = doy2date(dayofyear,year);


secofday = str2double(f(viseind+8:viseind+12));

dayfrac = secofday/(60*60*24);


% now construct our final time vector
timestamp = datematlab+dayfrac;
