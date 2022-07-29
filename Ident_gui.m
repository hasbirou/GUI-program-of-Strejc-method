function Ident_gui

% Ident_gui for identification model . Clicking the button
% plots the selected data in the axes.
   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[360,200,450,485],...
       'color',[0.9 0.9 0.9 ],'NumberTitle', 'off');
   %  Construct the components.
   hreal = uicontrol('Style','pushbutton','String','real',...
          'Position',[1280,480,70,25],...
          'Callback',{@realbutton_Callback});
   htext = uicontrol('Style','text','String','non évolutif',...
          'Position',[100,410,90,15]);      
   htext1 = uicontrol('Style','text','String','Strejc',...
          'Position',[550,380,60,15]); 
   ph = uipanel('Parent',f,'Units','pixels',...
           'Position',[660 260 130 140]);   
   hBO = uicontrol('Style','pushbutton','String','BO',...
          'Position',[300,340,70,25],...
          'Callback',{@BObutton_Callback});
   hBF = uicontrol('Style','pushbutton','String','BF',...
          'Position',[690,300,70,25],...
          'Callback',{@BFbutton_Callback});
   htext2 = uicontrol('Style','text','String','non évolutif',...
         'Position',[240,180,100,15]);
   htext6 = uicontrol('Style','text','String','Broida',...
         'Position',[240,150,100,15]);  
   ph2 = uipanel('Parent',f,'Units','pixels',...
           'Position',[225 30 130 140]);    
   hbo = uicontrol('Style','pushbutton','String','bo',...
          'Position',[255,113,70,27],...
          'Callback',{@bobutton_Callback});
   hbf = uicontrol('Style','pushbutton',...
          'String','bf','Position',[255,70,70,27],...
          'Callback',{@bfbutton_Callback});    
   htext3 = uicontrol('Style','text','String','évolutif',...
          'Position',[680,210,90,15]);      
   htext4 = uicontrol('Style','text','String','Strejc',...
          'Position',[695,180,60,15]);
   ph1 = uipanel('Parent',f,'Units','pixels',...
           'Position',[660 60 130 140]);      
   hBO1 = uicontrol('Style','pushbutton','String','BO1',...
         'Position',[690,140,70,25],...
          'Callback',{@BO1button_Callback});
   hBF1 = uicontrol('Style','pushbutton','String','BF1',...
          'Position',[690,100,70,25],...
          'Callback',{@BF1button_Callback});      
   ha = axes('Units','Pixels','Position',[50,230,500,250]); 
  align([hreal,htext,htext1,hBO,hBF,htext3,...
       htext4,hBO1,hBF1],'Center','None');
  htext5 = uicontrol('Style','text','String',...
'cliquer sur pushboutton remarque pour connaitre les étapes',...
          'Position',[50,90,90,80]);
    hre = uicontrol('Style','pushbutton','String','remarque',...
         'Position',[690,20,70,25],...
          'Callback',{@rebutton_Callback});  
     
   % Initialize the GUI.
   % Assign the GUI a name to appear in the window title.
   set(f,'Name','Ident GUI')
   % Move the GUI to the center of the screen.
   movegui(f,'center')
   % Make the GUI visible.
   set(f,'Visible','on');
 
   %  Callbacks for Ident_gui. These callbacks automatically
   %  have access to component handles and initialized data 
   %  because they are nested at a lower level.   
   % Push button callbacks. Each callback plots current_data in
   % the specified plot type.
 function realbutton_Callback(source,eventdata)
 %systéme real
global sys   
num=input('num=');
den=input('den=');
sys=tf(num,den)
step(sys,'cyan')
grid on
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%non évolutif  
    function BObutton_Callback(source,eventdata)
   %Strejc bo  
   global K s   
K=input('K gain de système real='); 
Tum=input('Tum mesurée à partire du graphe=');
Ta=input('Ta à partire du graphe=');
L=Tum/Ta
tab1=xlsread('strejboNE')
for m=1:10
    if(L>=tab1(m,4))& (L<tab1(m+1,4))
        n=tab1(m,1)
        T=Ta/tab1(m,2)
        Tu=tab1(m,3)*T
        r=Tum-Tu
    end
end
s=tf('s')
Hsbon=(K*exp(-r*s))/((1+T*s)^n)
step(Hsbon,'red')
grid on
    end
  function BFbutton_Callback(source,eventdata)
    %strejc bf 
 global sys Gr s tosc
Gr=input('Gr gain proportionnel critique=')
dy=input('dy le gain du système boucle fermé=')
dx=input('dx variation d''échelon d''entré=')
K1=dy/(Gr*(dx-dy))
sys1=Gr*sys;
sys2=feedback(sys1,1);
step(sys2)
tosc=input('tosc le temp d''oscillation=')
N=Gr*K1;
tab2=xlsread('strejbfNE')
for m=11:-1:1
    if(N>tab2(m,2))& (N<tab2(m-1,2))
        n=tab2(m,1)  
   else if N==tab2(m,2)
        n=tab2(m,1)
        end 
    end
end
Tsbfn=(tosc/2*pi)*sqrt((Gr*K1)^(2/n)-1)
rf=(tosc/2)*(1-((n/pi)*atan(sqrt((Gr*K1)^(2/n))-1)))
Hsbfn=(K1*exp(-rf*s))/((1+Tsbfn*s)^n)
step(Hsbfn,'green')
grid on
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % evolutif 
  function BO1button_Callback(source,eventdata)
     %strejc bo
   global K sys s    
sys3=(1/s)*sys
step(sys3)
AB=input('AB=')
AC=input('AC=') 
M=AB/AC
Tu=input('Tu=')
tab3=xlsread('strejboE')
for m=5:-1:1
    if(M>=tab3(2,m))& (M<tab3(2,m-1))
        n=tab3(1,m)
    end   
end
Tsboe=Tu/n
r=0.507;
Hsboe=(K*exp(-r*s))/(1+Tsboe*s)
step(Hsboe,'black')
grid on
  end
  function BF1button_Callback(source,eventdata)
    %strej bf
    global K Gr tosc  s 
wosc=(2*pi)/tosc
D=(Gr*K)/wosc
tab4=xlsread('strejbfE')
for m= 5:-1:1
    if(D>tab4(m,2))& (D<tab4(m-1,2))
       n=tab4(m,1)
    end   
end
Te=(tosc/2*pi)*sqrt(((Gr*K)/wosc)^(2/n)-1)
re=(tosc/4)*(1-(2*n/pi)*atan(Te*wosc))
H2=(K*exp(-re*s))/((1+Te*s)^n) 
step(H2,'magenta')
grid on
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Broida Non évolutif
    function bobutton_Callback(source,eventdata)
% Broida bo
global K s sys
t=0:0.005:10;
y=step(sys,t);
plot(t,y);
ym=max(y)
yr2=0.4*ym;
max_idx=min(find(y>=yr2));
t2=t(max_idx)
yr1=0.28*ym;
max_idx=min(find(y>=yr1))
t1=t(max_idx)
Tbbo=5.5*(t2-t1)
r=(2.8*t1)-(1.8*t2)
Hbbo=(K*exp(-r*s))/(1+Tbbo*s)
step(Hbbo,'yellow')
grid  on
    end
    function bfbutton_Callback(source,eventdata)
   % Broida bf
   global K s Gr tosc
r=(tosc/2*pi)*(1-((1/pi)*atan(sqrt(((Gr*K)^2)-1))))
Tbbf=(tosc/2*pi)*sqrt(((Gr*K)^2)-1)
Hbbf=(K*exp(-r*s))/(1+Tbbf*s)
step(Hbbf,'blue')
grid on
 end
    function rebutton_Callback(source,eventdata)
fprintf('1-on trace la tangente à la réponse passant par le point d''inflexion.')
fprintf('2-déterminer les valeur de Ta et Tu  et K à partire de plot.')
fprintf('3-déterminer la valeur de Gr à partir de système en boucle fermée et tosc.')
fprintf('4-déterminer la valeur dx et dy.')
fprintf('5-déterminer la valeur de AB,AC et Tu.')
fprintf('6-pour plus des information pour déterminer les valeurs utiliser notre exemples.')
    end
  end
