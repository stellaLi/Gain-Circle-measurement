%
% Measure transducer gain of a Rf Amp, as a function of source impedence
% after the DUT is the coupler
% S21 is a of coupler
% S31 is b of coupler, because 50ohm load, S31 is very small
% S44 source impedence looked from the Amp side (cable length included)
%
% Sitian LI
% 2016.03.30
%
% GPIB, MATLAB, Gain Circle, Two Port Network
%

%% Set up GPIB Connection
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
obj2.Set_Switch('D',0);
obj2.Disconnect();

%% Measurement Setup
% only fot get points
max_point = 30;

%% Get Measurement Data Gamma_s and S21

% Connect to instrument object, obj1.
fopen(obj1);
obj2.Connect();

% Measure S44
obj2.Set_Switch('D',0);
pause(0.5);
fprintf(obj1, ':CALC1:PAR1:DEF S44');
fprintf(obj1, ':CALC1:FORM SCOM');

i = 1;
while (i < max_point)
    figure(2);
    userpress = waitforbuttonpress;
    rsData = query(obj1, ':CALC1:MARK1:Y?');
    rsRandX = str2num(rsData);
    
    obj2.Set_Switch('D',1);
    pause(0.5);
    fprintf(obj1, ':CALC1:PAR1:DEF S21');
    fprintf(obj1, ':CALC1:FORM MLOG');
    pause(0.5);
    S21Data = query(obj1, ':CALC1:MARK1:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20 = S21dBM20_2(1);
    
    imped(i,:) = rsRandX;
    S21_20(i,:) = S21dBM20;
    i = i + 1;
    
    pause(0.5);
    obj2.Set_Switch('D',0);
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