% day = calcDayOfYear(5, 3);
% goteborgLat = 57.70723;
% declinationAngle = calcDeclinationAngle(day);
% hourAngle = calcHourAngle(10);
%calcElevationAngle(goteborgLat, declinationAngle, hourAngle)


%%
%Solar functions
function elevationAngle = calcElevationAngle(lattitude, declinationAngle, hourAngle)
    elevationAngle = asind((sind(lattitude)*sind(declinationAngle))+(cosd(lattitude)*cosd(declinationAngle)*cosd(hourAngle)));
end

function hourAngle = calcHourAngle(time)
    hourAngle = (15*time)-180;
end

function declinationAngle = calcDeclinationAngle(dayOfYear)
    declinationAngle = -23.44*cosd(((360/365)*dayOfYear));
end

function dayOfYear = calcDayOfYear(day, month)
   dayOfYear = 0;
   daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
   for i = 1:1:(month-1)
      dayOfYear = dayOfYear + daysInMonths(i);
   end
   dayOfYear = dayOfYear + day;
end
%%
%Common functions
function y = deg2rad(x)
    y = x.*pi./180;
end

function y = rad2deg(x)
    y = (x.*180)./pi;
end