%%
% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 20, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 20);
else
    fclose(obj1);
    obj1 = obj1(1)
end

% Connect to instrument object, obj1.
fopen(obj1);
fclose(obj1);
%% Measurement Setup
% only fot get points
max_point = 31;

%%
fopen(obj1);
fprintf(obj1, 'CALCulate1:MARKer1:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer2:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer3:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer4:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer5:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer6:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer7:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer8:FORMat DEF');
fprintf(obj1, 'CALCulate1:MARKer9:FORMat DEF');
fclose(obj1);
%% Get Measurement Data Gamma_s and operation gain

% Connect to instrument object
fopen(obj1);

i = 1;
while (i < max_point)
    figure(2);
    
    userpress = waitforbuttonpress;
    
    fprintf(obj1, 'CALCulate1:PARameter:MEASure "Trc1", "s21"');
    fprintf(obj1, 'CALC1:FORM MLOG');
    pause(0.1);
    
    %get S21 db
    S21Data = query(obj1, 'CALCulate1:MARKer1:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,1) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer2:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,2) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer3:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,3) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer4:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,4) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer5:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,5) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer6:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,6) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer7:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,7) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer8:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,8) = S21dBM20_2(1);
    S21Data = query(obj1, 'CALCulate1:MARKer9:Y?');
    S21dBM20_2 = str2num(S21Data);
    S21dBM20(:,9) = S21dBM20_2(1);
    
    %get S21 phase
    fprintf(obj1, 'CALC1:FORM PHAS');
    pause(0.1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer1:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,1) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer2:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,2) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer3:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,3) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer4:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,4) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer5:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,5) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer6:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,6) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer7:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,7) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer8:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,8) = S21_pha_2(1);
    S21_pha_Data = query(obj1, 'CALCulate1:MARKer9:Y?');
    S21_pha_2 = str2num(S21_pha_Data);
    S21_pha(:,9) = S21_pha_2(1);
    
    fprintf(obj1, 'CALCulate1:PARameter:MEASure "Trc1", "s31"');
    fprintf(obj1, 'CALC1:FORM MLOG');
    pause(0.1);
    S31Data = query(obj1, 'CALCulate1:MARKer1:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,1) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer2:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,2) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer3:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,3) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer4:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,4) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer5:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,5) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer6:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,6) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer7:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,7) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer8:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,8) = S31dBM20_2(1);
    S31Data = query(obj1, 'CALCulate1:MARKer9:Y?');
    S31dBM20_2 = str2num(S31Data);
    S31dBM20(:,9) = S31dBM20_2(1);
    
    fprintf(obj1, 'CALC1:FORM PHAS');
    pause(0.1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer1:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,1) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer2:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,2) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer3:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,3) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer4:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,4) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer5:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,5) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer6:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,6) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer7:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,7) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer8:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,8) = S31_pha_2(1);
    S31_pha_Data = query(obj1, 'CALCulate1:MARKer9:Y?');
    S31_pha_2 = str2num(S31_pha_Data);
    S31_pha(:,9) = S31_pha_2(1);
    
    fprintf(obj1, 'CALCulate1:PARameter:MEASure "Trc1", "s11"');
    fprintf(obj1, 'CALC1:FORM MLOG');
    pause(0.1);
    S11Data = query(obj1, 'CALCulate1:MARKer1:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,1) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer2:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,2) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer3:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,3) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer4:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,4) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer5:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,5) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer6:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,6) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer7:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,7) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer8:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,8) = S11dBM_s(1);
    S11Data = query(obj1, 'CALCulate1:MARKer9:Y?');
    S11dBM_s = str2num(S11Data);
    S11dBM(:,9) = S11dBM_s(1);
    
    
    figure(1);
    S21 = S21dBM20 + 20;
    S31 = S31dBM20 + 20;

    S21lin = 10.^(S21/20);
    S31lin = 10.^(S31/20);
    
    rs_mag = S31lin/S21lin;
    rs_pha = S31_pha - S21_pha+90.5+174;
    
    rsr_tp = rs_mag*cos((rs_pha)./180*pi);
    rsx_tp = rs_mag*sin((rs_pha)./180*pi);
    
    figure(1);hold on;
    c = linspace(1,20,9);
    scatter(rsr_tp,rsx_tp,[],c,'filled');
    axis([-1 1 -1 1]);
    
    S21_20(i,:) = S21dBM20;
    S31_20(i,:) = S31dBM20;
    S11(i,:) = S11dBM;
    
    S21_p(i,:) = S21_pha;
    S31_p(i,:) = S31_pha;
    
    i = i + 1;
end
fclose(obj1);

%%
S21 = S21_20 + 20;
S31 = S31_20 + 20;

S21lin = 10.^(S21./20);
S31lin = 10.^(S31./20).*0.97; %coupler attenuation
S11lin = 10.^(S11./20);

%%

s22=-0.0957 + 0.0466*1i;
s21abs = 6.04;

s22_f = [-0.0924 + 0.0495i  -0.0935 + 0.0557i  -0.0933 + 0.0644i...
    -0.0923 + 0.0720i  -0.0897 + 0.0789i  -0.0844 + 0.0868i...
    -0.0810 + 0.0915i -0.0809 + 0.0974i  -0.0779 + 0.1064i];

s21abs_f = [6.1239    6.0938    6.0688    6.0212...
    5.9689    5.9265    5.8634    5.8251    5.8046];

s22_rep = repmat(s22_f,max_point-1,1);
s21abs_rep = repmat(s21abs_f,max_point-1,1);

rs_mag = S31lin./S21lin;

%%
att = [1.0050 1.0690 1.1050 1.0570 1 0.9690 0.9810 1.0560 1.099]
%% attenuation at different phase
k = 1;
for ps = -180:0.1:180
    rs_pha = S31_p - S21_p + ps;

	rsr = rs_mag.*cos((rs_pha)./180.*pi);
	rsx = rs_mag.*sin((rs_pha)./180.*pi);

	calc1 = (s21abs)./(abs(1-s22.*(rsr+1i.*rsx)));
	calc = (s21abs_rep)./(abs(1-s22_rep.*(rsr+1i.*rsx)));
	meas = S21lin.^repmat(att, 30,1);

	y1(k,:) = sum((calc1-meas).^2,1);
	y(k,:) = sum((calc-meas).^2,1);
	k = k + 1;
end

%% attenuation at different freq
k = 1;
%for ps = -180:0.1:180
    for att = 0:0.001:1.5  
        rs_pha = S31_p - S21_p-81;

        rsr = rs_mag.*cos((rs_pha)./180.*pi);
        rsx = rs_mag.*sin((rs_pha)./180.*pi);

        calc1 = (s21abs)./(abs(1-s22.*(rsr+1i.*rsx)));
        calc = (s21abs_rep)./(abs(1-s22_rep.*(rsr+1i.*rsx)));
        meas = S21lin.^att;

        y1(k,:) = sum((calc1-meas).^2,1);
        y(k,:) = sum((calc-meas).^2,1);
        k = k + 1;
    end
%end

%% attenuation at diff freq
for MkNr = 1:9
att = 0:0.001:1.5;
figure(1);
subplot(5,2,MkNr);
plot(att,y1(:,MkNr));
figure(2);
subplot(5,2,MkNr);
plot(att,y(:,MkNr));
[minPoint1(MkNr),minindex1(MkNr)] = min(y1(:,MkNr));
[minPoint(MkNr),minindex(MkNr)] = min(y(:,MkNr));   
end

%%
for MkNr = 1:9
ps = -180:0.1:180;
figure(1);
subplot(5,2,MkNr);
plot(ps,y1(:,MkNr));
figure(2);
subplot(5,2,MkNr);
plot(ps,y(:,MkNr));
[minPoint1(MkNr),minindex1(MkNr)] = min(y1(:,MkNr));
[minPoint(MkNr),minindex(MkNr)] = min(y(:,MkNr));   
end

%%  attenuation freq
figure(3);
subplot(2,1,1);
plot(minPoint1);
axis([1 9 0 1.5]);
subplot(2,1,2);
a = minindex1/1000;
plot(a);
axis([1 9 0.9 1.2]);

figure(4);
subplot(2,1,1);
plot(minPoint);
axis([1 9 0 1.5]);
subplot(2,1,2);
a = minindex/1000;
plot(a);
axis([1 9 0.9 1.2]);

%% phase freq
figure(3);
subplot(2,1,1);
plot(minPoint1);
%axis([1 9 0 1.5]);
subplot(2,1,2);
a = minindex1/3601*360-180;
plot(a);
%axis([1 9 0.9 1.2]);

figure(4);
subplot(2,1,1);
plot(minPoint);
%axis([1 9 0 1.5]);
subplot(2,1,2);
a = minindex/3601*360-180;
a(1) = a(1)+ 360;
a(2) = a(2)+ 360;
a(3) = a(3)+ 360;
plot(a);
%axis([1 9 0.9 1.2]);
%% fiiting
freq = [500 550 600 650 700 750 800 850 900];
phase_shift = a;

[xData, yData] = prepareCurveData( freq, phase_shift );

% Set up fittype and options.
ft = fittype( 'poly1' );
excludedPoints = excludedata( xData, yData, 'Indices', 8 );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData, excludedPoints );
legend( h, 'phase_shift vs. freq', 'Excluded phase_shift vs. freq', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel freq
ylabel phase_shift
grid on

phas_p1 = fitresult.p1;
phas_p2 = fitresult.p2;

%% 
figure
mm = 1;
for freqtest = 500:1:900
    attens(mm) = attenuation(freqtest);
    mm = mm+1;
end
freqtest = 500:1:900;
plot(freqtest,attens);