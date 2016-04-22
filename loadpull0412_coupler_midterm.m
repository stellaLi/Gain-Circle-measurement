%
% Load Pull  no switch
% Measure operation gain of a Rf Amp, as a function of load impedence
% after the DUT is the coupler
% S21 is a2/a1 of coupler
% S31 is b2/a1 of coupler, because 50ohm load, S31 is very small
% S44 load impedence looked from the Amp side (cable length included)
% S11 is b1/a1
% 
%
% Sitian LI
% 2016.03.30
%
% GPIB, MATLAB, Gain Circle, Two Port Network
%%
% Set up GPIB Connection
% connection via GPIB test
% data available
% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 17, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 17);
else
    fclose(obj1);
    obj1 = obj1(1)
end

% Connect to instrument object, obj1.
fopen(obj1);

% Communicating with instrument object, obj1.
fprintf(obj1, ':CALC1:PAR1:DEF S44');
fprintf(obj1, ':CALC1:FORM SCOM');
data1 = query(obj1, ':CALC1:MARK1:Y?');
fprintf(obj1, ':CALC1:PAR1:DEF S21');
fprintf(obj1, ':CALC1:FORM MLOG');
data2 = query(obj1, ':CALC1:MARK1:Y?');

% Disconnect from instrument object, obj1.
fclose(obj1);

% Test if data valid
datanum1 = str2num(data1);
datanum2 = str2num(data2);


%% Measurement Setup
% only fot get points
max_point = 11;

%% Get Measurement Data Gamma_s and operation gain

% Connect to instrument object
fopen(obj1);

i = 1;
while (i < max_point)
    figure(2);
    userpress = waitforbuttonpress;
    
    fprintf(obj1, ':CALC1:PAR1:DEF S21');
    fprintf(obj1, ':CALC1:FORM MLOG');
    pause(0.5);
    S21Data = query(obj1, ':CALC1:MARK1:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20 = S21dBM20_2(1);
    
    fprintf(obj1, ':CALC1:FORM PHAS');
    pause(0.5);
    S21_pha_Data = query(obj1, ':CALC1:MARK1:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha = S21_pha_2(1);
    
    fprintf(obj1, ':CALC1:PAR1:DEF S31');
    fprintf(obj1, ':CALC1:FORM MLOG');
    pause(0.5);
    S31Data = query(obj1, ':CALC1:MARK1:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20 = S31dBM20_2(1);
    
    fprintf(obj1, ':CALC1:FORM PHAS');
    pause(0.5);
    S31_pha_Data = query(obj1, ':CALC1:MARK1:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha = S31_pha_2(1);
    
    fprintf(obj1, ':CALC1:PAR1:DEF S11');
    fprintf(obj1, ':CALC1:FORM MLOG');
    pause(0.5);
    S11Data = query(obj1, ':CALC1:MARK1:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM = S11dBM_s(1);
    
    S21_20(i,:) = S21dBM20;
    S31_20(i,:) = S31dBM20;
    S11(i,:) = S11dBM;
    
    S21_p(i,:) = S21_pha;
    S31_p(i,:) = S31_pha;
    
    figure(1);
    S21 = S21dBM20 + 20;
    S31 = S31dBM20 + 20;

    S21lin = 10^(S21/20);
    S31lin = 10^(S31/20);
    
    rs_mag = S31lin/S21lin;
    rs_pha = S31_pha - S21_pha+90.5+174;
    
    rsr = rs_mag*cos((rs_pha)/180*pi);
    rsx = rs_mag*sin((rs_pha)/180*pi);
    
    figure(1);hold on;
    scatter(rsr,rsx,'b');
    axis([-1 1 -1 1]);
    
    i = i + 1;
end
fclose(obj1);

%%

S21 = S21_20 + 20;
S31 = S31_20 + 20;


S21lin = 10.^(S21./20);
S31lin = 10.^(S31./20);
S11lin = 10.^(S11./20);

%%
rs_mag = S31_f./S21lin;
rs_pha = S31_p - S21_p+(-81.7);

rsr = rs_mag.*cos((rs_pha)./180.*pi);
rsx = rs_mag.*sin((rs_pha)./180.*pi);

%Gop = (S21lin.^2 - S31lin.^2)./(1-S11lin.^2);
%Gop = (S21lin.^2 - S31lin.^2)./(S21lin.^2);
%G_L = Gop .* (1 - S11lin.^2);
%G_L_db = log10(G_L).*10;
%scatter3(rsr,rsx,G_L_db);
%axis([-1 1 -1 1]);

%%
s22=-0.0957 + 0.0466*1i;
s21abs = 6.04;
%calc = (s21abs.^2)./(abs(1-s22.*(rsr+1i.*rsx)).^2);
meas = S21lin.^2;
%meas = 73.8366 - meas;

%scatter3(rsr,rsx,calc,'b');
hold on;
%scatter3(rsr,rsx,meas,'r');
%daspect([1 1 1]);
axis([-1 1 -1 1]);
%Gop_db = 10.*log10(s21abs.^2.*(1-abs(rsr + 1i.*rsx).^2)./abs(1-s22.*(rsr+1i.*rsx)).^2);
%Gop_db = 10.*log10((S21lin.^2).*(1-abs(rsr + 1i.*rsx).^2));
%Gop = calc.*(1-abs(rsr+1i.*rsx).^2);
Gop = meas.*(1-abs(rsr+1i.*rsx).^2);
%Gop = S21lin.^2 - S31lin.^2;
Gop_db = log10(Gop).*10;
scatter3(rsr,rsx,Gop_db);
axis([-1 1 -1 1]);

%%

rs_mag = S31lin./S21lin;

k = 1;
for ps = -180:0.1:180
    rs_pha = S31_p - S21_p+ps;

    rsr = rs_mag.*cos((rs_pha)./180.*pi);
    rsx = rs_mag.*sin((rs_pha)./180.*pi);

    calc = (s21abs)./(abs(1-s22.*(rsr+1i.*rsx)));
    meas = S21lin;

    y(k) = sum((calc - meas).^2);
    k = k + 1;
end
ps = -180:0.1:180;
plot(ps,y);
%%
calc = (s21abs)./(abs(1-s22.*(rsr+1i.*rsx)));
meas = S21lin;
scatter3(rsr,rsx,calc,'b');
hold on;
scatter3(rsr,rsx,meas,'r');
axis([-1 1 -1 1]);