goteborgLat = 57.70723;
azimut = 150;
elevation = 25;
efficiency = 0.15;
area = 30;
%write current task here
%Make plotDay pretty
%Add in sunHours to all formulas

figure(1);
plotDay(5, 1, goteborgLat, elevation, azimut, efficiency, area)
figure(2);
plotYear(goteborgLat, elevation, azimut, efficiency, area)
optimalElevationAngle = optimizeElevation(goteborgLat, azimut, efficiency, area)
%%

%optimize functions
function optimized = optimizeElevation(lattitude, panelAzimutAngle, efficiency, area)
    fun = @(x)-1*(calcYearlyPower(lattitude, x, panelAzimutAngle, efficiency, area));
    optimized = fminbnd(fun, 0, 90);
end

%plot functions
function plotYear(lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    power = zeros(1, 365);
    days = 1:1:365;
    for dayOfYear = 1:365
        declinationAngle = calcDeclinationAngle(dayOfYear);
        t = 1:0.25:23;
        for i = 1:length(t)
            currentTime = t(i);
            hourAngle = calcHourAngle(currentTime);
            elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
            azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
            surfacePower = calcSurfacePower(elevationAngle);
            panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
            currentPower = calcTotalPower(efficiency, panelPower, area);
            power(dayOfYear) = power(dayOfYear) + currentPower;
        end
    end
    scatter(days, (abs(power)/1000));
    axis([1 365 20 110]);
    title("År");
    ylabel("P [KW]");
    xlabel("tid [dagar]");
end

function plotDay(month, day, lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    dayOfYear = calcDayOfYear(month, day);
    declinationAngle = calcDeclinationAngle(dayOfYear);
    t = 1:0.25:23; %time array from 1:00 to 23:00 with 15min intervals
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
    scatter(t, abs(power));
    title([num2str(day),'/',num2str(month)])
    ylabel("P [W]");
    xlabel("tid [h]");
end
%calculate functions
function power = calcYearlyPower(lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    power = 0;
    for dayOfYear = 1:365
        declinationAngle = calcDeclinationAngle(dayOfYear);
        t = 1:0.25:23;
        for i = 1:length(t)
            currentTime = t(i);
            hourAngle = calcHourAngle(currentTime);
            elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
            azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
            surfacePower = calcSurfacePower(elevationAngle);
            panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
            currentPower = calcTotalPower(efficiency, panelPower, area);
            power = power + real(currentPower);
        end
    end
end

function totalPower = calcTotalPower(efficiency, panelPower, area)
    totalPower = efficiency*panelPower*area;
end

function panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle)
    deltaAzimut = panelAzimutAngle - azimutAngle;
    deltaElevation = panelElevationAngle - elevationAngle;
    if (-90<=deltaAzimut) && (deltaAzimut <=90) && (-90<=deltaElevation) && (deltaElevation <=90)
        panelPower = surfacePower*cosd(deltaAzimut)*cosd(deltaElevation);
    else
        panelPower = 0;
    end
end

function surfacePower = calcSurfacePower(elevationAngle)
    if elevationAngle <= 0
        surfacePower = 0;   
    else
        surfacePower = 1.1*1360*(0.7.^((1/sind(elevationAngle)).^0.678));
    end
end

function azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle)
    if hourAngle < 0
       %ekv 4
       azimutAngle = 180-acosd((((sind(lattitude)*sind(elevationAngle)))-sind(declinationAngle))/(cosd(lattitude)*cosd(elevationAngle)));
    else
        %ekv 5
       azimutAngle = 180+acosd((((sind(lattitude)*sind(elevationAngle)))-sind(declinationAngle))/(cosd(lattitude)*cosd(elevationAngle)));
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

function sunHourFactor = calcSunHourFactor(month)   %MAYBE WRONG
    goteborgSunHour = [40, 71, 126, 182, 241, 266, 243, 220, 143, 94, 58, 38];
    daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    sunHourFactor = goteborgSunHour(month)/(daysInMonths(month)*12);
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