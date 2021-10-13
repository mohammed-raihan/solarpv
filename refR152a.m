%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Author:
%
%   Mohammed Raihan Uddin
%
% Paper:
%
%  https://doi.org/10.1016/j.ecmx.2021.100095

function [wComp,qCond, cop] = refR152a (time, tAmb, irr ,rh)

import py.CoolProp.CoolProp.PropsSI
%% INPUT
tEvap = 273.15;
tCond = tAmb + 10;

h = 24;
d = 31;
m = 12;

month = {'January', 'February','March','April','May','June','July', 'August', 'September', 'October', 'November', 'December'};
disp('Calculating loads for refrigerant R152a...[2/4]')


wComp = zeros (h, d, m);
cop = zeros (h, d, m);
coolingLoad = zeros (h, d, m);
qEvap = zeros (h, d, m);
qCond = zeros (h, d, m);

ref = 'R152a';

for k = 1:m
    fprintf('Month: ')
    disp(month(k))
    fprintf('\t\tDay: ')
    for j =  1:d
        if time (1,j,k) ~= -1
            %% Disply
            if j>1
                for l=0:log10(j-1)
                    fprintf('\b'); % delete previous counter display
                end
            end
            fprintf('%d', j);
         %% 
           
            for i= 1:h
                 %% Lower Cycle
                    %Point 1
                    tEvapTemp = tEvap;
                    tCondTemp = tCond(i,j,k);

                    p1 =PropsSI('P','T',tEvapTemp,'Q',1,ref);
                    h1 =PropsSI('H','T',tEvapTemp+5,'P',p1,ref); %Superheating
                    s1 =PropsSI('S','T',tEvapTemp+5,'P',p1,ref);
                    t1 = tEvapTemp+5;
                    %Point 3
                    p3 = PropsSI('P','T',tCondTemp,'Q',0,ref);
                    t3 = tCondTemp - 5; %Subcooling
                    h3 = PropsSI('H','T',t3,'P',p3,ref);
                    %Point 2
                    p2 = p3;
                    s2 = s1;

            %       etaIsenLow = 1 - (0.04 * (p2/p1) );

                    h2s = PropsSI('H','S',s2,'P', p2 ,ref);
                    h2 = h1 + ((h2s - h1)/0.6); %60% Overall Efficiency
                    t2 = PropsSI('T','H',h2,'P', p2 ,ref);

                    %Point 4
                    h4 = h3 ;
                    t4 = PropsSI('T','H',h4,'P', p1 ,ref);

                     %% Cooling Load Calculation
                    coolingLoad(i,j,k) = funcCoolingLoad (tAmb(i,j,k), irr(i,j,k), rh(j,k));
                    qEvap(i,j,k) = coolingLoad(i,j,k);

                    %%

                    mLow = (qEvap(i,j,k)) / (h1 - h4);

                    qCond(i,j,k) = mLow * (h2 - h3);
                    wComp(i,j,k) = (mLow*(h2 - h1));


             end
                      
          else
             break            
          end
    end
    fprintf('\n'); 
    cop = (qEvap ./ wComp);
    
end
