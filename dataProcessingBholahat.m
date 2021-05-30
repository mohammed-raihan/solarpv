%% Importing CoolProp
pyversion

%% Loading Data

hour = [0:1:23]';

h = 24;
d = 31;
m = 12;

time = zeros (h, d, m);
tAmb = zeros  (h, d, m);
irr = zeros (h, d, m);
rh = zeros (d, m);

disp('Loading data...')

tempData = load ('weather-data\tempDataBholahat.txt');
irrData = load ('weather-data\irrDataBholahat.txt');
rhData = load ('weather-data\rhDataBholahat.txt'); 


for j = 1:12    
    for i=1:31
        time(:,i,j) = hour;
    end
end

time (:, 29:31, 2) = -1 ; 
time (:, 31 , 4) = -1 ;
time (:, 31 , 6) = -1 ;
time (:, 31 , 9) = -1 ;
time (:, 31 , 11) = -1 ;


n = 1;
r = 1;
for k = 1:m 
    for j =  1:d
        if time (1,j,k) ~= -1
            for i= 1:h
                tAmb(i,j,k) = tempData(n);
                irr(i,j,k) = irrData(n);
                n  = n +  1;
                
            end
           rh(j,k) = rhData (r);
           r = r + 1; 
        else
            break          
        end
    end
    
end

tAmb = tAmb + 273.15;
rh = rh/100;

disp ('Data load completed.')

%% Refriferation Cycle
[coolingLoad, wCompR134a,qCondR134a, copR134a] = refR134a (time, tAmb, irr, rh);

[wCompR152a,qCondR152a, copR152a] = refR152a (time, tAmb, irr, rh);

[wCompR1234yf,qCondR1234yf, copR1234yf] = refR1234yf (time, tAmb, irr, rh);

[wCompR1234ze,qCondR1234ze, copR1234ze] = refR1234ze (time, tAmb, irr, rh);

for k = 1:m 
    for j =  1:d
        for i= 1:h
            if time (i,j,k) == -1
                tAmb(i,j,k) = -1;
                irr(i,j,k) = -1;
                rh(j,k) = -1;
                coolingLoad(i,j,k) = -1;
                wCompR134a(i,j,k) = -1;
                qCondR134a(i,j,k) = -1;
                copR134a(i,j,k) = -1;
                wCompR152a(i,j,k) = -1;
                qCondR152a(i,j,k) = -1;
                copR152a(i,j,k) = -1;
                wCompR1234yf(i,j,k) = -1;
                qCondR1234yf(i,j,k) = -1;
                copR1234yf(i,j,k) = -1;
                wCompR1234ze(i,j,k) = -1;
                qCondR1234ze(i,j,k) = -1;
                copR1234ze(i,j,k) = -1;
            end      
        end
    end
    
end

disp('Calculation Completed for Bholahat.')

%% Processing output
% 's' stands for series data (8760 hours.)
% 'dm' for daily mean

sTemp= tAmb(time~=-1); %The extra dates are eliminated (29th February)
sTemp = sTemp - 273.15; % in C


sIrr= irr(time~=-1); %Converted to series after eliminating
dailyIrr = sum(reshape(sIrr,[24,365]),1)'; %Series data converted to daily data % in Wh/m2/day - mean

sCL= coolingLoad(time~=-1);%in W 

sCOPR134a = copR134a(time~=-1);
dmCOPR134a= mean(reshape(sCOPR134a,[24,365]),1)'; % Daily mean COPS
sCOPR152a = copR152a(time~=-1);
dmCOPR152a= mean(reshape(sCOPR152a,[24,365]),1)';
sCOPR1234yf = copR1234yf(time~=-1);
dmCOPR1234yf = mean(reshape(sCOPR1234yf,[24,365]),1)';
sCOPR1234ze = copR1234ze(time~=-1);
dmCOPR1234ze = mean(reshape(sCOPR1234ze,[24,365]),1)';

swCompR134a= wCompR134a(time~=-1);
dmCompWR134a= mean(reshape(swCompR134a,[24,365]),1)';
swCompR152a= wCompR152a(time~=-1);
dmCompWR152a= mean(reshape(swCompR152a,[24,365]),1)';
swCompR1234yf = wCompR1234yf(time~=-1);
dmCompWR1234yf= mean(reshape(swCompR1234yf,[24,365]),1)';
swCompR1234ze = wCompR1234ze(time~=-1);
dmCompWR1234ze= mean(reshape(swCompR1234ze,[24,365]),1)';

% load('resultBholahat.mat');
disp('Saving Files...')
save('results\B-Temperature-hourly.txt', 'sTemp', '-ASCII'); % in C
save('results\B-Irradiance-daily.txt', 'dailyIrr', '-ASCII');  % in Wh/m2/day
save('results\B-CoolingLoad-hourly.txt', 'sCL', '-ASCII'); %in W
save('results\B-COP-R134a-dailymean.txt', 'dmCOPR134a', '-ASCII');  % Daily mean COPS
save('results\B-COP-R152a-dailymean.txt', 'dmCOPR152a', '-ASCII');
save('results\B-COP-R1234yf-dailymean.txt', 'dmCOPR1234yf', '-ASCII');
save('results\B-COP-R1234ze-dailymean.txt', 'dmCOPR1234ze', '-ASCII');

save('results\B-wComp-R134a-dailymean.txt', 'dmCompWR134a', '-ASCII'); %in W
save('results\B-wComp-R152a-dailymean.txt', 'dmCompWR152a', '-ASCII');
save('results\B-wComp-R1234yf-dailymean.txt', 'dmCompWR1234yf', '-ASCII');
save('results\B-wComp-R1234ze-dailymean.txt', 'dmCompWR1234ze', '-ASCII');

disp('Files saved.')