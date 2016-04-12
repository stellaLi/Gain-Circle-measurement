%
% Load Pull
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


%% Set up switch connection
% Object defination
MyZT = NET.addAssembly('C:\Windows\SysWOW64\mcl_RF_Switch_Controller64.dll');
obj2 = mcl_RF_Switch_Controller64.USB_RF_SwitchBox;

% Connect device
obj2.Connect();

% Switch change
obj2.Set_Switch('A',0);
obj2.Disconnect();

%% Measurement Setup
% only fot get points
max_point = 100;

%% Get Measurement Data Gamma_s and operation gain

% Connect to instrument object, obj1.
fopen(obj1);
obj2.Connect();

% Measure S44
obj2.Set_Switch('A',0);
pause(0.5);
fprintf(obj1, ':CALC1:PAR1:DEF S44');
fprintf(obj1, ':CALC1:FORM SCOM');

i = 1;
while (i < max_point)
    figure(2);
    userpress = waitforbuttonpress;
    rsData = query(obj1, ':CALC1:MARK1:Y?');
    rsRandX = str2num(rsData);
    
    obj2.Set_Switch('A',1);
    pause(0.5);
    fprintf(obj1, ':CALC1:PAR1:DEF S21');
    fprintf(obj1, ':CALC1:FORM MLOG');
    pause(0.5);
    S21Data = query(obj1, ':CALC1:MARK1:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20 = S21dBM20_2(1);
    
    fprintf(obj1, ':CALC1:PAR1:DEF S31');
    fprintf(obj1, ':CALC1:FORM MLOG');
    pause(0.5);
    S31Data = query(obj1, ':CALC1:MARK1:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20 = S31dBM20_2(1);
    
    fprintf(obj1, ':CALC1:PAR1:DEF S11');
    fprintf(obj1, ':CALC1:FORM MLOG');
    pause(0.5);
    S11Data = query(obj1, ':CALC1:MARK1:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM = S11dBM_s(1);
    
    imped(i,:) = rsRandX;
    S21_20(i,:) = S21dBM20;
    S31_20(i,:) = S31dBM20;
    S11(i,:) = S11dBM;
    i = i + 1;
    
    pause(0.5);
    obj2.Set_Switch('A',0);
    pause(0.5);
    fprintf(obj1, ':CALC1:PAR1:DEF S44');
    fprintf(obj1, ':CALC1:FORM SCOM');

end

fclose(obj1);
obj2.Disconnect();

%%
rsr = imped(:,1);
rsx = imped(:,2);
S21 = S21_20 + 20;
S31 = S31_20 + 20;

S21lin = 10.^(S21./20);
S31lin = 10.^(S31./20);
S11lin = 10.^(S11./20);


%Gop = (S21lin.^2 - S31lin.^2)./(1-S11lin.^2);
Gop = (S21lin.^2 - S31lin.^2)./(S21lin.^2);
Gop_db = log10(Gop)*10;
scatter3(rsr,rsx,Gop_db);
axis([-1 1 -1 1]);


%%savadata data0406.mat   rsr,rsx,Gop_db