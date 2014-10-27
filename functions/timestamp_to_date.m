function [ datestring ] = timestamp_to_date( unix_time )
%TIMESTAMP_TO_DATE Takes a UNIX timestamp in seconds and converts

    datestring = datestr(unix_time/86400 + datenum(1970,1,1));

end

