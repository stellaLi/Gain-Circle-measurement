%
% nonlinear fitting of operation gain
% 2016.04.06
% Sitian LI
%


%% calc data
M = 10;
[rho, phi] = meshgrid(0:1/M:0.99, -pi:2*pi/M:pi);
rsr = rho.*cos(phi);
rsx = rho.*sin(phi);

rrsr = reshape(rsr,[M*(M+1),1]);
rrsx = reshape(rsx,[M*(M+1),1]);

%%

s22=-0.0957 + 0.0466*1i;
s21abs = 6.05;
rGop_db = 10.*log10(s21abs.^2.*(1-abs(rrsr + 1i.*rrsx).^2)./abs(1-s22.*(rrsr+1i.*rrsx)).^2);
hold on
scatter3(rrsr, rrsx, rGop_db);

%%
rng default % for reproducibility
xdata = rrsr;
ydata = rrsx;
zdata = rGop_db;


objfcn = @(v)(10.*log10((1-abs(xdata + 1i.*ydata).^2)./abs(1-(v(1)+1i.*v(2)).*(xdata+1i.*ydata)).^2)+v(3)- zdata);

opts = optimoptions(@lsqnonlin,...
    'Algorithm','levenberg-marquardt','Display','off');
x0 = (1)*[-1;-1;5]; % arbitrary initial guess
lb = [-1;-1;0];
ub = [1;1;20];
[vestimated,resnorm,residuals,exitflag,output] = lsqnonlin(objfcn,x0,[],[],opts);
vestimated,resnorm,exitflag,output.firstorderopt

%%
rng default % for reproducibility
xdata = rsr;
ydata = rsx;
zdata = Gop_db;


objfcn = @(v)(10.*log10((1-abs(xdata + 1i.*ydata).^2)./abs(1-(v(1)+1i.*v(2)).*(xdata+1i.*ydata)).^2)+v(3)- zdata);

opts = optimoptions(@lsqnonlin,...
    'Algorithm','levenberg-marquardt','Display','off');
x0 = (1)*[0;0;5]; % arbitrary initial guess
lb = [-1;-1;0];
ub = [1;1;20];
[vestimated,resnorm,residuals,exitflag,output] = lsqnonlin(objfcn,x0,lb,ub,opts);
vestimated,resnorm,exitflag,output.firstorderopt

%%

scatter3(rsr,rsx,Gop_db);

axis([-1 1 -1 1 ]);
%axis equal;
%%
hold on

M = 100;
[rho, phi] = meshgrid(0:1/M:0.99, -pi:2*pi/M:pi);
a = rho.*cos(phi);
b = rho.*sin(phi);
c = 10.*log10((1-abs(a + 1i.*b).^2)./abs(1-(vestimated(1)+1i.*vestimated(2)).*(a+1i*b)).^2)+vestimated(3);
surf(a,b,c);
axis([-1 1 -1 1 ]);

%% coutour
hold on
contour(a,b,c,[16 15.5 15 14 13.5 13 12 11 10]);
print -deps epsFig


