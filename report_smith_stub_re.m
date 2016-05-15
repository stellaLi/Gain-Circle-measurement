draw_smith;
hold on

x = -1:0.1:1;
y = 0.*x;
plot(x,y,'Color',[0.5 0.5 0.5]);

t = linspace(0,2*pi,100);
plot(0.75.*sin(t),0.75.*cos(t),'Color',[0.5 0.5 0.5]);
scatter(0,0,'b');
scatter(-0.09494,0.744,'black');
scatter(-0.4209,0.5044,'black');
scatter(0.5668,-0.4911,'black');

scatter(-0.09494,-0.744,'black');
scatter(-0.4209,-0.5044,'black');
scatter(0.5668,0.4911,'black');

t = linspace(-0.28*pi,-0.12*pi,100);
r = 0.8;
plot(r.*sin(t)+1-r,r.*cos(t),'Color','r');
t = linspace(-0.05*pi,0.72*pi,100);
plot(0.75.*sin(t),0.75.*cos(t),'Color','r');
t = linspace(0.95*pi,1.5*pi,100);
r = 0.5;
plot(r.*sin(t)+1-r,r.*cos(t),'Color','r');

t = linspace(1.5*pi,2.05*pi,100);
r = 0.5;
plot(r.*sin(t)+1-r,r.*cos(t),'Color','b');
t = linspace(0.27*pi,1.04*pi,100);
plot(0.76.*sin(t),0.76.*cos(t),'Color','b');
t = linspace(1.28*pi,1.12*pi,100);
r = 0.8;
plot(r.*sin(t)+1-r,r.*cos(t),'Color','b');