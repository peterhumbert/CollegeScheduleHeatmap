fid=fopen('data.txt','r');
schedaggragation = zeros(13*12,5);  % aggragation matrix
                                    % 8am to 9pm in 5min blocks, 5d/wk
isem = 0;
schedbysem = zeros(13*12,5,10);     % handle up to 5 years of enrollment
semlookup = {};                     % for YaSb -> schedbysem(,,?)

if(fid == -1)
    error(['Cannot find file named ',file_list(k).name]);
end

line_read = fgets(fid);     % initialize line_read
while line_read ~= -1
    if line_read(1) == 'Y'
        isem = isem + 1;
        semlookup{isem} = line_read(1:4);
    elseif ~all(isspace(line_read)) && line_read(1) ~= 'Y'
        switch line_read(1:3)
            case 'Mon'
                iday = 1;
            case 'Tue'
                iday = 2;
            case 'Wed'
                iday = 3;
            case 'Thu'
                iday = 4;
            case 'Fri'
                iday = 5;
            otherwise
                % must be a time entry
                startHour = str2double(line_read(1:2));
                startMin = str2double(line_read(3:4));
                endHour = str2double(line_read(6:7));
                endMin = str2double(line_read(8:9));

                % convert times to indices
                istart = (startHour-8)*12 + startMin/5 + 1;
                iend = (endHour-8)*12 + endMin/5;

                schedaggragation(istart:iend, iday) = ...
                    schedaggragation(istart:iend, iday) + 1;
                schedbysem(istart:iend, iday, isem) = ...
                    ones(iend-istart+1, 1);
        end
    end
    
    line_read = fgets(fid); % read next line
end

fclose(fid);

% plots for day-by-day aggregation
ff = 1;
figure(ff); ff = ff+1;
imagesc(schedaggragation);
figure(ff); ff = ff+1;
surf(schedaggragation);
figure(ff); ff = ff+1;
contour(schedaggragation);
figure(ff); ff = ff+1;
contourf(schedaggragation);
figure(ff); ff = ff+1;
contour3(schedaggragation);
figure(ff); ff = ff+1;
mesh(schedaggragation);
figure(ff); ff = ff+1;
waterfall(schedaggragation);
figure(ff); ff = ff+1;
ribbon(schedaggragation);

colors = lines(5);

figure(ff); ff = ff+1;
for ii = 1:5
    plot3(ones(156,1)*ii,1:156,schedaggragation(:,ii)); hold on;
end

figure(ff); ff = ff+1;
for ii = 1:5
    h = plot3(ones(156,1)*ii,1:156,schedaggragation(:,ii)); hold on;
    for jj = 1:156
        plot3([ii ii],[jj jj],[0 schedaggragation(jj,ii)],'Color',h.Color);
    end
end

figure(ff); ff = ff+1;
for ii = 1:5
    fill3(ones(1,158)*ii,[1 1:156 156],...
        [0 schedaggragation(:,ii)' 0],colors(ii,:)); hold on;
end

figure(ff); ff = ff+1;
for ii = 1:5
    subplot(5,1,ii);
    fill([1 1:156 156],...
        [0 schedaggragation(:,ii)' 0],colors(ii,:)); hold on;
    ylim([0 6]);
    axis off;
end

% area plot for each of the 5 weekdays during semester _sem_
sem = 1;
figure(ff); ff = ff+1;
for ii = 1:5
    subplot(5,1,ii);
    fill([1 1:156 156],...
        [0 schedbysem(:,ii,sem)' 0],colors(ii,:)); hold on;
    ylim([0 6]);
    axis off;
end

% area plot aggregating the 5 weekdays of semester _sem_
% y-axis is then the number of days each week that have a class scheduled
% at time _x_, max 5
sem = 1;
figure(ff); ff = ff+1;
agg = zeros(156,1);
for ii = 1:156
    agg(ii) = sum(schedbysem(ii,:,sem));
end
fill([1 1:156 156],[0 agg' 0],'blue'); hold on;
ylim([0 5]);
axis off;