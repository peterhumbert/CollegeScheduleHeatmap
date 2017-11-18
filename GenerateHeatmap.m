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

% plots for day-by-day aggregation
ii = 1;
figure(ii); ii = ii+1;
imagesc(schedaggragation);
figure(ii); ii = ii+1;
surf(schedaggragation);
figure(ii); ii = ii+1;
contour(schedaggragation);
figure(ii); ii = ii+1;
contourf(schedaggragation);
figure(ii); ii = ii+1;
contour3(schedaggragation);
figure(ii); ii = ii+1;
mesh(schedaggragation);
figure(ii); ii = ii+1;
waterfall(schedaggragation);
figure(ii); ii = ii+1;
ribbon(schedaggragation);

colors = lines(5);

figure(ii); ii = ii+1;
for ii = 1:5
    plot3(ones(156,1)*ii,1:156,schedaggragation(:,ii)); hold on;
end

figure(ii); ii = ii+1;
for ii = 1:5
    h = plot3(ones(156,1)*ii,1:156,schedaggragation(:,ii)); hold on;
    for jj = 1:156
        plot3([ii ii],[jj jj],[0 schedaggragation(jj,ii)],'Color',h.Color);
    end
end

figure(ii); ii = ii+1;
for ii = 1:5
    fill3(ones(1,158)*ii,[1 1:156 156],...
        [0 schedaggragation(:,ii)' 0],colors(ii,:)); hold on;
end

figure(ii); ii = ii+1;
for ii = 1:5
    subplot(5,1,ii);
    fill([1 1:156 156],...
        [0 schedaggragation(:,ii)' 0],colors(ii,:)); hold on;
    ylim([0 6]);
    axis off;
end

% TODO add plots for each semester: line/area for each day, time
% aggregation