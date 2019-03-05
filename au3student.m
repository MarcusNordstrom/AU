% goteborgLat = 57.70723;

%write current task here
%Optimize panelElevationAngle

%%
%plot functions
function plotDay(month, day, lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    dayOfYear = calcDayOfYear(month, day);
    declinationAngle = calcDeclinationAngle(dayOfYear);
    t = 5:0.25:19; %time array from 5:00 to 19:00 with 15min intervals
    power = zeros(1, length(t));
    for i=1:length(t)
        currentTime = t(i);
        hourAngle = calcHourAngle(currentTime);
        elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
        azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
        surfacePower = calcSurfacePower(elevationAngle);
        panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
        power(i) = calcTotalPower(efficiency, panelPower, area);
    end
    scatter(t, power);
    ylabel("P [W]");
    xlabel("tid [h]");
end
%calculate functions
function totalPower = calcTotalPower(efficiency, panelPower, area)
    totalPower = efficiency*panelPower*area;
end

function panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle)
    deltaAzimut = panelAzimutAngle - azimutAngle;
    deltaElevation = panelElevationAngle - elevationAngle;
    if (-90<=deltaAzimut) && (deltaAzimut <=90) && (-90<=deltaElevation) && (deltaElevation <=90)
       %if (deltaAzimut == 0) || (deltaElevation == 0)
       %    panelPower = surfacePower;
       %else
           panelPower = surfacePower*cosd(deltaAzimut)*cosd(deltaElevation);
       %end
    else
        panelPower = 0;
    end
end

function surfacePower = calcSurfacePower(elevationAngle)
    if elevationAngle ~= 0
        surfacePower = 1.1*1360*(0.7.^((1/sind(elevationAngle)).^0.678));
    elseif elevationAngle == 90
        
    else
        surfacePower = 0;
    end
end

function azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle)
    if hourAngle < 0
       %ekv 4
       azimutAngle = 180-acosd((((sind(lattitude)*sind(elevationAngle)))-sind(declinationAngle))/(cosd(lattitude)*cosd(elevationAngle)));
    %elseif hourAngle > 0
    else
        %ekv 5
       azimutAngle = 180+acosd((((sind(lattitude)*sind(elevationAngle)))-sind(declinationAngle))/(cosd(lattitude)*cosd(elevationAngle)));
%     else
        %0
%        azimutAngle = 0; 
     end
end

function elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle)
    elevationAngle = asind((sind(lattitude)*sind(declinationAngle))+(cosd(lattitude)*cosd(declinationAngle)*cosd(hourAngle)));
end

function hourAngle = calcHourAngle(time)
    hourAngle = (15*time)-180;
end

function declinationAngle = calcDeclinationAngle(dayOfYear)
    declinationAngle = -23.44*cosd(((360/365)*dayOfYear));
end

function timeOfDay = calcTimeOfDay(hour, minute)
    timeOfDay = hour + (minute/60);
end

function dayOfYear = calcDayOfYear(month, day)
   dayOfYear = 0;
   daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
   for i = 1:1:(month-1)
      dayOfYear = dayOfYear + daysInMonths(i);
   end
   dayOfYear = dayOfYear + day;
end

%Common functions
function y = deg2rad(x)
    y = x.*pi./180;
end

function y = rad2deg(x)
    y = (x.*180)./pi;
end