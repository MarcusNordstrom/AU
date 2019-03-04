%ekv 2
%beta = sqrt((omega0).^2-(lambda).^2);
%X = A.*exp(-lambda.*t).*sin(beta.*t+omega);
figure(1);
t = 0:0.1:10;
%amplitud
A = 2;
%sväningsfaktor (mindre är större sväning)
lambda = 0.5;
%dämpningskonsant
omega0 = 1;
%fasförskjutning
delta = pi/2;

X1 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
lambda = 0.25;
X2 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
lambda = 0.75;
X3 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
subplot(2,2,1);
plot(t, X1, t, X2, t, X3);
title("λ");
legend("λ = 0.5", "λ = 0.25", "λ = 0.75");
xlabel("Tid");
ylabel("Amplitud");
hold on
lambda = 0.5;

X1 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
A = 1;
X2 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
A = 3;
X3 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
subplot(2,2,2);
plot(t, X1, t, X2, t, X3);
title("Amplitud");
legend("A = 2", "A = 1", "A = 3");
xlabel("Tid");
ylabel("Amplitud");
A = 2;

X1 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
omega0 = 0.75;
X2 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
omega0 = 1.25;
X3 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
subplot(2,2,3);
plot(t, X1, t, X2, t, X3);
title("ω_0");
legend("ω_0 = 1", "ω_0 = 0.75", "ω_0 = 1.25");
xlabel("Tid");
ylabel("Amplitud");
omega0 = 1;

X1 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
delta = pi /4;
X2 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
delta = pi;
X3 = A.*exp(-lambda.*t).*sin((sqrt((omega0).^2-(lambda).^2)).*t+delta);
subplot(2,2,4);
plot(t, X1, t, X2, t, X3);
title("δ");
legend("δ = ^{π}/_{2}", "δ = ^{π}/_{4}", "δ = π");
xlabel("Tid");
ylabel("Amplitud");
hold off;
%%
%ekv 3
figure(2);
C1 = 2;
%start position
C2 = 2;
lambda = 1;
t = 0:0.1:10;

subplot(2,3,1);
X1 = (C1.*t+C2).*exp(-lambda.*t);
C1 = 1;
X2 = (C1.*t+C2).*exp(-lambda.*t);
C1 = 3;
X3 = (C1.*t+C2).*exp(-lambda.*t);
C1 = 2;
plot(t, X1, t, X2, t, X3);
xlabel("Tid");
ylabel("Amplitud");
legend("C_{1} = 2","C_{1} = 1","C_{1} = 3");
title("C_{1}");
hold on;

subplot(2,3,2);
X1 = (C1.*t+C2).*exp(-lambda.*t);
C2 = 1;
X2 = (C1.*t+C2).*exp(-lambda.*t);
C2 = 3;
X3 = (C1.*t+C2).*exp(-lambda.*t);
C2 = 2;
plot(t, X1, t, X2, t, X3);
xlabel("Tid");
ylabel("Amplitud");
legend("C_{2} = 2","C_{2} = 1","C_{2} = 3");
title("C_{2}");

subplot(2,3,3);
X1 = (C1.*t+C2).*exp(-lambda.*t);
lambda = 0.75;
X2 = (C1.*t+C2).*exp(-lambda.*t);
lambda = 1.25;
X3 = (C1.*t+C2).*exp(-lambda.*t);
plot(t, X1, t, X2, t, X3);
xlabel("Tid");
ylabel("Amplitud");
legend("λ = 1","λ = 0.75","λ = 1.25");
title("λ");

%%
%ekv 4
% beta = sqrt((lambda).^2-(omega0).^2);
% X = C1.*exp(-(lambda-beta).*t)+C2.*exp(-(lambda+beta).*t);
figure(3);
C1 = 1;
C2 = 1;
lambda = 1.5;
omega0 = 1;

X1 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
C1 = 0.75;
X2 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
C1 = 1.25;
X3 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
C1 = 1;
subplot(2,2,1);
plot(t, X1, t, X2, t, X3)
xlabel("Tid");
ylabel("Amplitud");
legend("C_{1} = 1", "C_{1} = 0.75", "C_{1} = 1.25");
title("C_{1}");
hold on;

X1 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
C2 = 0.25;
X2 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
C2 = 1.75;
X3 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
C2 = 1;
subplot(2,2,2);
plot(t, X1, t, X2, t, X3)
xlabel("Tid");
ylabel("Amplitud");
legend("C_{2} = 1", "C_{2} = 0.25", "C_{2} = 1.75");
title("C_{2}");

X1 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
lambda = 1.25;
X2 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
lambda = 1.75;
X3 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
lambda = 1.5;
subplot(2,2,3);
plot(t, X1, t, X2, t, X3)
xlabel("Tid");
ylabel("Amplitud");
legend("λ = 1.5", "λ = 1.25", "λ = 1.75");
title("λ");

X1 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
omega0 = 0.75;
X2 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
omega0 = 1.25;
X3 = C1.*exp(-(lambda-(sqrt((lambda).^2-(omega0).^2))).*t)+C2.*exp(-(lambda+(sqrt((lambda).^2-(omega0).^2))).*t);
omega0 = 1;
subplot(2,2,4);
plot(t, X1, t, X2, t, X3)
xlabel("Tid");
ylabel("Amplitud");
legend("ω_0 = 1", "ω_0 = 0.75", "ω_0 = 1.75");
title("ω_0");
%%
% amplitud
figure(4);
omega = 0:0.001:3;
b = 1;
L = 0.0083;
m = 1;
omega0 = 1;
c = 1
A = b./(sqrt(m.^2*((omega.^2 - omega0.^2).^2) + (c.^2.*omega.^2)));
plot(omega, A)
c = 1.5
hold on
A = b./(sqrt(m.^2*((omega.^2 - omega0.^2).^2) + (c.^2.*omega.^2)));
plot(omega,A)
c = 0.5
A = b./(sqrt(m.^2*((omega.^2 - omega0.^2).^2) + (c.^2.*omega.^2)));
plot(omega,A)
legend("C = 1","C = 1.5","C = 0.5");
%%
%RLC
figure(5);
R = 5;
L = 0.0082;
C = 0.0001;
resonansfrekvens = 1/(2.*pi.*sqrt(L.*C))
H1 = tf((1/(L.*C)), [1 (R/L) 1/(L.*C)]);
R = 13;
H2 = tf((1/(L.*C)), [1 (R/L) 1/(L.*C)]);
h = bodeplot(H1, H2);
title("Frekvensspektrum");
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
legend("R = 5", "R = 13");

%%
%ODE45
figure(6);
clf
c=1.0;              % dämpningskonstant 0.5
m=1.0;              % massa 1.0
k=1.0;              % fjäderkonstant 1.0
b=0.0;              % amplitud av drivkraft
w0=sqrt(k/m);       % resonansfrekvens
dx = @(t,x) [x(2) ; -c/m*x(2)-k/m*x(1)+b*cos(w0*t)];
[t,x] = ode45(dx,[0 10],[2 0]); % [3 -0.75]
subplot(2,2,1);
plot(t,x(:,1))
xlabel('t')
ylabel('x(t)')
title("ODE45");
%step function
subplot(2,2,2)
[t1,x1] = stepSolver(dx,[0 10],[2 0], 16);
[t2,x2] = stepSolver(dx,[0 10],[2 0], 32);
[t3,x3] = stepSolver(dx,[0 10],[2 0], 64);
plot(t1,x1(:,1), t2, x2(:,1), t3, x3(:,1))
title("Eulers steglösning");
xlabel('t')
ylabel('x(t)')
legend("steg = 16", "steg = 32", "steg = 64")
function [Tout, Xout] = stepSolver(f, targ, init, nrOfStep)
    T0 = targ(1);                              %start
    T = targ(2);                               %end
    step = (T-T0)/nrOfStep;                    %stegstorlek
    Tout = zeros(nrOfStep+1,1);                %tid utvariabel
    Xout = zeros(nrOfStep+1, length(init));    %värde utvariabel
    t = T0;                                    
    x = init';
    Tout(1) = t;
    Xout(1,:) = init;
    
    for i=1:nrOfStep
       x1 = f(t,x);
       euler = x + x1*step;
       x2 = f(t+step, euler);
       x = x + ((x1+x2)/2*step);
       t = t + step;
       Tout(i+1) = t;
       Xout(i+1,:) = x';
    end
end