fid=fopen('data.txt','r');
schedaggragation = zeros(13*12,5);  % aggragation matrix
                                    % 8am to 9pm in 5min blocks, 5d/wk

if(fid == -1)
    error(['Cannot find file named ',file_list(k).name]);
end

line_read = fgets(fid);     % initialize line_read
while line_read ~= -1
    if ~all(isspace(line_read)) && line_read(1) ~= 'Y'
        switch line_read(1:3)
            case 'Mon'
                ii = 1;
            case 'Tue'
                ii = 2;
            case 'Wed'
                ii = 3;
            case 'Thu'
                ii = 4;
            case 'Fri'
                ii = 5;
            otherwise
                % must be a time entry
                startHour = str2double(line_read(1:2));
                startMin = str2double(line_read(3:4));
                endHour = str2double(line_read(6:7));
                endMin = str2double(line_read(8:9));

                % convert times to indices
                istart = (startHour-8)*12 + startMin/5 + 1;
                iend = (endHour-8)*12 + endMin/5;

                schedaggragation(istart:iend,ii) = ...
                    schedaggragation(istart:iend,ii) + 1;
        end
    end
    
    line_read = fgets(fid); % read next line
end

fclose(fid);