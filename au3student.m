goteborgLat = 57.71; %57.70723
azimut = 150;
elevation = 25;
efficiency = 0.15;
area = 30;
%EXAMPLE PLOT FROM Au3 doc
%plotDay(5 ,1 , 55.6, 20, 180, 0.15, 30);

figure(1);
subplot(1, 2, 1)
plotDay(1, 15, goteborgLat, elevation, azimut, efficiency, area)
axis([4 16 0 3000])
subplot(1,2,2)
plotDay(6, 15, goteborgLat, elevation, azimut, efficiency, area)
axis([4 16 0 3000])
figure(2);
plotYear(goteborgLat, elevation, azimut, efficiency, area)
figure(3);
subplot(1, 2,1)
plotMonth(1, goteborgLat, elevation, azimut, efficiency, area)
title("Januari");
axis([1 31 0 80]);
subplot(1,2,2)
plotMonth(6, goteborgLat, elevation, azimut, efficiency, area)
title("Juni");
axis([1 30 0 80]);
yearlyPower = calcYearlyPower(goteborgLat, elevation, azimut, efficiency, area)/1000
janPower = calcMonthlyPower(1, goteborgLat, elevation, azimut, efficiency, area)/1000
junPower = calcMonthlyPower(6, goteborgLat, elevation, azimut, efficiency, area)/1000
optimalElevationAngle = optimizeElevation(goteborgLat, azimut, efficiency, area)
area = oneGWarea(3, 8 , 11, goteborgLat, elevation, azimut, efficiency)
%%

%optimize functions
function optimizedAngle = optimizeElevation(lattitude, panelAzimutAngle, efficiency, area)
    fun = @(x)-1*(calcYearlyPower(lattitude, x, panelAzimutAngle, efficiency, area));
    optimizedAngle = fminbnd(fun, 0, 90);
    optimizedPower = calcYearlyPower(lattitude, optimizedAngle, panelAzimutAngle, efficiency, area)/1000
end

function areaValue = oneGWarea(month, day, time, lattitude, panelElevationAngle, panelAzimutAngle, efficiency)
    dayOfYear = calcDayOfYear(month, day);
    declinationAngle = calcDeclinationAngle(dayOfYear);
    hourAngle = calcHourAngle(time);
    elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
    azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
    surfacePower = calcSurfacePower(elevationAngle);
    panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
    areaValue = 1e9/(efficiency*panelPower);
end

%plot functions
function plotMonth(month, lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    power = zeros(1, daysInMonths(month));
    days = 1:1:daysInMonths(month);
    for d = 1:daysInMonths(month)
        dayOfYear = calcDayOfYear(month, d);
        declinationAngle = calcDeclinationAngle(dayOfYear);
        t = 1:0.25:23;
        dayPower = zeros(1, length(t));
        for i = 1:length(t)
            currentTime = t(i);
            hourAngle = calcHourAngle(currentTime);
            elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
            azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
            surfacePower = calcSurfacePower(elevationAngle);
            panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
            currentPower = calcTotalPower(dayOfYear, efficiency, panelPower, area);
            dayPower(i) = real(currentPower);
            %power(dayOfYear) = power(dayOfYear) + currentPower;
        end
        power(d) = (trapz(dayPower))/1000;
    end
    length(days)
    length(power)
    scatter(days, power);
    ylabel("P [KWh]");
    xlabel("tid [dagar]");
end

function plotYear(lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    power = zeros(1, 365);
    days = 1:1:365;
    for dayOfYear = 1:365
        declinationAngle = calcDeclinationAngle(dayOfYear);
        t = 1:0.25:23;
        dayPower = zeros(1, length(t));
        for i = 1:length(t)
            currentTime = t(i);
            hourAngle = calcHourAngle(currentTime);
            elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
            azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
            surfacePower = calcSurfacePower(elevationAngle);
            panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
            currentPower = calcTotalPower(dayOfYear, efficiency, panelPower, area);
            dayPower(i) = real(currentPower);
            %power(dayOfYear) = power(dayOfYear) + currentPower;
        end
        power(dayOfYear) = (trapz(dayPower))/1000;
    end
    scatter(days, power);
    axis([1 365 0 110]);
    title("År");
    ylabel("P [KWh]");
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
        power(i) = calcTotalPower(dayOfYear,efficiency, panelPower, area);
    end
    scatter(t, abs(power));
    axis([5 19 0 4000]);
    title([num2str(day),'/',num2str(month)])
    ylabel("P [W]");
    xlabel("tid [h]");
end
%calculate functions
function maxPower = calcDailyMax(month, day, time, lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    dayOfYear = calcDayOfYear(month, day);
    declinationAngle = calcDeclinationAngle(dayOfYear);
    hourAngle = calcHourAngle(time);
    elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
    azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
    surfacePower = calcSurfacePower(elevationAngle);
    panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
    maxPower = calcTotalPower(dayOfYear,efficiency, panelPower, area);
end

function integralPower = calcMonthlyPower(month, lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    integralPower = 0;
    daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    for dayOfYear = calcDayOfYear(month, 1):(daysInMonths(month)+calcDayOfYear(month, 1))
        declinationAngle = calcDeclinationAngle(dayOfYear);
        t = 1:0.25:23;
        power = zeros(1, length(t));
        for i = 1:length(t)
            currentTime = t(i);
            hourAngle = calcHourAngle(currentTime);
            elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
            azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
            surfacePower = calcSurfacePower(elevationAngle);
            panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
            currentPower = calcTotalPower(dayOfYear, efficiency, panelPower, area);
            %power = power + real(currentPower);
            power(i) = real(currentPower);
        end
        integralPower = integralPower + trapz(power);
    end
end

function integralPower = calcYearlyPower(lattitude, panelElevationAngle, panelAzimutAngle, efficiency, area)
    integralPower = 0;
    for dayOfYear = 1:365
        declinationAngle = calcDeclinationAngle(dayOfYear);
        t = 1:0.25:23;
        power = zeros(1, length(t));
        for i = 1:length(t)
            currentTime = t(i);
            hourAngle = calcHourAngle(currentTime);
            elevationAngle = calcElevationAngle(lattitude, hourAngle, declinationAngle);
            azimutAngle = calcAzimutAngle(lattitude, elevationAngle, hourAngle, declinationAngle);
            surfacePower = calcSurfacePower(elevationAngle);
            panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle);
            currentPower = calcTotalPower(dayOfYear, efficiency, panelPower, area);
            %power = power + real(currentPower);
            power(i) = real(currentPower);
        end
        integralPower = integralPower + trapz(power);
    end
end

function totalPower = calcTotalPower(day, efficiency, panelPower, area)
    sunHourFactor = calcSunHourFactor(day);
    %sunHourFactor = 1;
    totalPower = efficiency*panelPower*area*sunHourFactor;
end

function panelPower = calcPanelPower(surfacePower, elevationAngle, azimutAngle, panelElevationAngle, panelAzimutAngle)
    deltaAzimut = panelAzimutAngle - azimutAngle;
    deltaElevation = panelElevationAngle - elevationAngle;
    if (-90<=deltaAzimut) && (deltaAzimut <=90) && (-90<=deltaElevation) && (deltaElevation <=90)
        panelPower = surfacePower*cosd(deltaAzimut)*cosd(deltaElevation);
    elseif (deltaAzimut == 0) && (deltaElevation == 0)
        panelPower = surfacePower;
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
    %declinationAngle = -23.44*cosd(((360/365)*dayOfYear));
    declinationAngle = -23.44*cosd((360*dayOfYear)/365);
end

function timeOfDay = calcTimeOfDay(hour, minute)
    timeOfDay = hour + (minute/60);
end

function sunHourFactor = calcSunHourFactor(day)
    goteborgSunHour = [40, 71, 126, 182, 241, 266, 243, 220, 143, 94, 58, 38];
    daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    t = 1:1:12;
    sunPerDay = goteborgSunHour./daysInMonths;
    days = linspace(1, 12, 365);
    daySunHour = interp1(t, sunPerDay, days);
    sunHourFactor = daySunHour(day)/12;
end

function month = calcMonthFromDay(day)
    daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    for i = 1:12
       if day > daysInMonths(i)
           day = day - daysInMonths(i);
       else
           month = i;
           break
       end
    end
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