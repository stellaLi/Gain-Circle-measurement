f = warndlg('This is a warning.', 'A Warning Dialog');
disp('This prints immediately');
drawnow     % Necessary to print the message
waitfor(f);
disp('This prints after you close the warning dialog');

%%
f = figure('Name', datestr(now));
h = uicontrol('String','Change Name',...
              'Position',[20 20 100 30],...
'Callback', 'set(gcbf, ''Name'', datestr(now))');
disp('This prints immediately');
drawnow     % Necessary to print the message
waitfor(f, 'Name');
disp('This prints after clicking the push button'); 

%%
figure;
textH = text(.5, .5, 'Edit me and click away');
set(textH,'Editing','on', 'BackgroundColor',[1 1 1]);
disp('This prints immediately.');
drawnow
waitfor(textH,'Editing','off');
set(textH,'BackgroundColor',[1 1 0]);
disp('This prints after text editing is complete.');

%%
f = figure;
h = uicontrol('Position',[20 20 200 40],'String','Continue',...
              'Callback','uiresume(gcbf)');
disp('This will print immediately');
uiwait(gcf); 
disp('This will print after you click Continue');
close(f);