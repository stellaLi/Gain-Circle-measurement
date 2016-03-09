%
% Measure transducer gain of a Rf Amp, as a function of source impedence
% S21 seen from VNA the gain seen by VNA
% S33 source impedence looked from the Amp side
%
% Sitian LI
% 2016.03.08
%
% GPIB, MATLAB
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
fprintf(obj1, ':CALC1:PAR1:DEF S33');
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

% define graph color
colors = ['b','r','y','k','g'];

%define measurement parameters
strtdB = 11.5;  %start freq 
dBNum  = 3; %freq nums
dBstep = 0.5; %freq step
smpl = 10;     % sample per circle

%stop frequency
stpdB = strtdB + dBNum * dBstep;

%% Measurement

% Connect to instrument object, obj1.
fopen(obj1);
obj2.Connect();

% RAM for Measurement
cirGrp = 1;
i = ones(1,dBNum);

% Measure S21 
fprintf(obj1, ':CALC1:PAR1:DEF S21');
fprintf(obj1, ':CALC1:FORM MLOG');

% Figure for measurment result
figure(1);
% Figure for user interaction
figure(2);

while (min(i) < smpl)
    figure(2);
    userpress = waitforbuttonpress;
    data2 = query(obj1, ':CALC1:MARK1:Y?');
    datanum2 = str2num(data2);
    cirGrp = 1;
    for S = strtdB: dBstep: stpdB
        if ((datanum2(1) < S + 0.05) && (datanum2(1) > S - 0.05))
            S21(cirGrp,i(cirGrp),:) = datanum2(1);
            
            % switch to source impedence
            
            obj2.Set_Switch('A',1);
            pause(1);
            fprintf(obj1, ':CALC1:PAR1:DEF S33');
            pause(0.5);
            fprintf(obj1, ':CALC1:FORM SCOM');
            pause(0.5);
            data1 = query(obj1, ':CALC1:MARK1:Y?');
            pause(0.5);
            
            datanum1 = str2num(data1);
            imped(cirGrp,i(cirGrp),:) = datanum1;
            
            % scatter point 
            figure(1);
            hold on;
            scatter3(datanum1(1),datanum1(2),datanum2(1),colors(cirGrp));
            axis([-1 1 -1 1 5 13])
            i(cirGrp) = i(cirGrp) + 1;
            
            % switch to Gain S21(vna)
            
            obj2.Set_Switch('A',0);
            pause(1);
            fprintf(obj1, ':CALC1:PAR1:DEF S21');
            pause(0.5);
            fprintf(obj1, ':CALC1:FORM MLOG');
            pause(0.5);
            
            break;
        end
        cirGrp = cirGrp + 1;
    end
end
fclose(obj1);
obj2.Disconnect();

%% Data processing
rin = imped(:,:,1);
xin = imped(:,:,2);
s = S21;

%% Circle at gain steps
for k = 1:dBNum
    N = nnz(rin(k,:));
    [R,A,B] = circ(rin(k,1:N),xin(k,1:N),N);
    ang=0:0.01:2*pi; 
    xp=R*cos(ang);
    yp=R*sin(ang);
    hold on;
    plot(A+xp,B+yp,colors(k));
    axis([-1 1 -1 1])
end