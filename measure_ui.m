function [rsr,rsx,Gop_db] = measure_ui

    obj1 = findVNA;
    measure_result_str = '';

    display_ui;
    
    % Create panel for Operation
    panel_Operation = uipanel('Title','Operation','FontSize',12,...
             'BackgroundColor','white',...
             'Unit','pixels',...
             'Position',[560 300 200 100]);
         
    % Create panel for fitting and 3D
    panel_fit = uipanel('Title','Fitting','FontSize',12,...
             'BackgroundColor','white',...
             'Unit','pixels',...
             'Position',[560 50 200 200]);
         
    % Create panel for data
    panel_data = uipanel('Title','Data','FontSize',12,...
             'BackgroundColor','white',...
             'Unit','pixels',...
             'Position',[800 50 200 200]);

    % Create push button catch
    btn_catch = uicontrol('Style', 'pushbutton', 'String', 'catch',...
        'Position', [625 350 80 25],...
        'Callback', @catchpoint);
    
    % Create push button finish
    btn_finish = uicontrol('Style', 'pushbutton', 'String', 'finish',...
        'Position', [625 310 80 25],...
        'Callback', @finishmeas);
    
    % Create push button fit
    btn_fit = uicontrol('Style', 'pushbutton', 'String', 'fit',...
        'Position', [625 190 80 25],...
        'Callback', @fitmeas);
    
    % Create checkbox show result
    box_showResult = uicontrol('Style', 'checkbox', 'String', 'Show fitting result',...
        'Position', [600 150 100 30],...
        'Callback', @showResult,...
        'Enable','off');
    
    % Create checkbox show Surface
    box_showSurf = uicontrol('Style', 'checkbox', 'String', 'Show Surface',...
        'Position', [625 120 100 30],...
        'Callback', @showSurf,...
        'Enable','off');
    
    % Create checkbox show Contour
    box_showContour = uicontrol('Style', 'checkbox', 'String', 'Show Contour',...
        'Position', [625 90 100 30],...
        'Callback', @showContour,...
        'Enable','off');

    % Connect to instrument object
    fopen(obj1);
    
    %global values
    S21_20 = zeros(1);
    S31_20 = zeros(1);
    S31_f = zeros(1);
    S11 = zeros(1);
    S21_p = zeros(1);
    S31_p = zeros(1);
    S11lin = zeros(1);
    rsrtemp = zeros(1);
    rsxtemp = zeros(1);
    rsr = zeros(1);
    rsx = zeros(1);
    rsr2d = zeros(1);
    rsx2d = zeros(1);
    Gop_db = zeros(1);
    finish_meas = 0;
    
    vestimated = zeros(1);
    state_show_res = 0;

    i = 1;
    while (finish_meas == 0)

        pause(0.1);
        fprintf(obj1, 'CALCulate1:PARameter:MEASure "Trc1", "s21"');
        fprintf(obj1, 'CALCulate1:MARKer1:FORMat MLOGarithmic');
        pause(0.1);
        S21Data = query(obj1, 'CALCulate1:MARKer1:Y?');
        S21dBM20_2 = str2num(S21Data);
        S21dBM20 = S21dBM20_2(1);

        fprintf(obj1, 'CALCulate1:MARKer1:FORMat PHASe');
        pause(0.1);
        S21_pha_Data = query(obj1, 'CALCulate1:MARKer1:Y?');
        S21_pha_2 = str2num(S21_pha_Data);
        S21_pha = S21_pha_2(1);

        fprintf(obj1, 'CALCulate1:PARameter:MEASure "Trc1", "s31"');
        fprintf(obj1, 'CALCulate1:MARKer1:FORMat MLOGarithmic');
        pause(0.1);
        S31Data = query(obj1, 'CALCulate1:MARKer1:Y?');
        S31Data
        S31dBM20_2 = str2num(S31Data);
        S31dBM20 = S31dBM20_2(1);

        fprintf(obj1, 'CALCulate1:MARKer1:FORMat PHASe');
        pause(0.1);
        S31_pha_Data = query(obj1, 'CALCulate1:MARKer1:Y?');
        S31_pha_2 = str2num(S31_pha_Data);
        S31_pha = S31_pha_2(1);

        fprintf(obj1, 'CALCulate1:PARameter:MEASure "Trc1", "s11"');
        fprintf(obj1, 'CALCulate1:MARKer1:FORMat MLOGarithmic');
        pause(0.1);
        S11Data = query(obj1, 'CALCulate1:MARKer1:Y?');
        S11dBM_s = str2num(S11Data);
        S11dBM = S11dBM_s(1);

        S21 = S21dBM20 + 20;
        S31 = S31dBM20 + 20;

        S21lin = 10^(S21/20);
        S31lin = 10^(S31/20);

        rs_mag = S31lin/S21lin;
        rs_pha = S31_pha - S21_pha+(-81.5);

        rsrtemp = rs_mag*cos((rs_pha)/180*pi);
        rsxtemp = rs_mag*sin((rs_pha)/180*pi);

        %figure(1);hold on;
        if(state_show_res == 0)
            hold off
            display_smith;
            hold on
            scatter(rsr2d,rsx2d,'filled','r');
            scatter(rsrtemp,rsxtemp,'b');
            axis([-1 1 -1 1]);
            hold off
        end

        %S21_20(i,:) = S21dBM20;
        %S31_20(i,:) = S31dBM20;
        %S11(i,:) = S11dBM;

        %S21_p(i,:) = S21_pha;
        %S31_p(i,:) = S31_pha;

        %i = i + 1;
    end
    fclose(obj1);

    function catchpoint(source,callbackdata)
       S21_20(i,:) = S21dBM20;
       S31_20(i,:) = S31dBM20;
       S11(i,:) = S11dBM;
    
       S21_p(i,:) = S21_pha;
       S31_p(i,:) = S31_pha;
       
       rsr2d(i,:) = rsrtemp;
       rsx2d(i,:) = rsxtemp;
       
       i = i + 1;
    end

    function finishmeas(source,callbackdata)
        finish_meas = 1;
    end

    function fitmeas(source,callbackdata)
        if i > 2
            S21 = S21_20 + 20;
            S31 = S31_20 + 20;
            S31_f = S31 - 0.53;

            S21lin = 10.^(S21./20);
            S31lin = 10.^(S31./20);
            S11lin = 10.^(S11./20);
            
            rs_mag = S31lin./S21lin;
            rs_pha = S31_p - S21_p+(-81.5);

            rsr = rs_mag.*cos((rs_pha)./180.*pi);
            rsx = rs_mag.*sin((rs_pha)./180.*pi);
            
            meas = S21lin.^2.*1.0276.^2;
            Gop = meas.*(1-abs(rsr+1i.*rsx).^2);
            Gop_db = log10(Gop).*10;
            measure_result_str = 'get';
            
            rng default % for reproducibility
            xdata = rsr;
            ydata = rsx;
            zdata = Gop_db;
            sizedata = size(xdata);


            objfcn = @(v)(10.*log10((1-abs(xdata + 1i.*ydata).^2)./abs(1-(v(1)+1i.*v(2)).*(xdata+1i.*ydata)).^2)+v(3)- zdata);

            opts = optimoptions(@lsqnonlin,...
                'Algorithm','levenberg-marquardt','Display','off');
            x0 = (1)*[0;0;5]; % arbitrary initial guess
            lb = [-1;-1;0];
            ub = [1;1;20];
            [vestimated,resnorm,residuals,exitflag,output] = lsqnonlin(objfcn,x0,lb,ub,opts);
            vestimated,resnorm,exitflag,output.firstorderopt
            
            string_display = sprintf('Fitting Result:\n S22 = %.4f + j%.4f,\n S21 = %.3f dB,\n Resnorm = %f', ...
        vestimated(1), vestimated(2), vestimated(3), resnorm/sizedata(1));
            measure_result_str = string_display;
            
            % Add a text uicontrol
            txt = uicontrol('Style','text',...
            'Position',[825 75 150 150],...
            'HorizontalAlignment','left',...
            'FontSize',10,...
            'String',measure_result_str);
            box_showResult.Enable = 'on';
        else
                text = 'no enough points'
        end
        
    end

    function showResult(source,callbackdata)
        if source.Value == 1
            draw_smith;
            scatter3(rsr,rsx,Gop_db,'b');

            axis([-1 1 -1 1 ]);
            xlabel('Reflection Coefficient (Real)') % x-axis label
            ylabel('Reflection Coefficient (Imag)') % y-axis label
            zlabel('Power Gain (db)') % z-axis label

            state_show_res = 1;
            box_showSurf.Enable = 'on';
            box_showContour.Enable = 'on';
        else
            state_show_res = 0;
            box_showSurf.Value = 0;
            box_showContour.Value = 0;
            box_showSurf.Enable = 'off';
            box_showContour.Enable = 'off';
        end
    end
    
    function showSurf(source, callbackdata)
        if source.Value == 1
            hold on

            M = 100;
            [rho, phi] = meshgrid(0:1/M:0.99, -pi:2*pi/M:pi);
            a = rho.*cos(phi);
            b = rho.*sin(phi);
            c = 10.*log10((1-abs(a + 1i.*b).^2)./abs(1-(vestimated(1)+1i.*vestimated(2)).*(a+1i*b)).^2)+vestimated(3);
            mesh(a,b,c);
            colormap(parula(6));
            axis([-1 1 -1 1 ]);
        else
            draw_smith;
            scatter3(rsr,rsx,Gop_db);
            box_showContour.Value = 0;
        end
    end

    function showContour(source, callbackdata)
        if source.Value == 1
            hold on

            M = 100;
            [rho, phi] = meshgrid(0:1/M:0.99, -pi:2*pi/M:pi);
            a = rho.*cos(phi);
            b = rho.*sin(phi);
            c = 10.*log10((1-abs(a + 1i.*b).^2)./abs(1-(vestimated(1)+1i.*vestimated(2)).*(a+1i*b)).^2)+vestimated(3);
            contour(a,b,c,[16 15.5 15 14 13.5 13 12 11 10]);
        else
            draw_smith;
            scatter3(rsr,rsx,Gop_db);
            box_showSurf.Value = 0;
        end
    end
end