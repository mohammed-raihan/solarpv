import py.CoolProp.CoolProp.PropsSI



%% INPUT
tEvapTemp = [-20; -10; 0; 10];
tEvapTemp = tEvapTemp + 273.15;

tCondTemp = 318.15;

n = numel (tEvapTemp);

cop152A = zeros (n, 1);
cop134A = zeros (n, 1);

for i = 1: n
    temp = tEvapTemp(i);
    
     %Point 1

        p1 =PropsSI('P','T',temp,'Q',1,'R152a');
        h1 =PropsSI('H','T',temp+5,'P',p1,'R152a');
        s1 =PropsSI('S','T',temp+5,'P',p1,'R152a');
        t1 = temp+5;
        %Point 3
        p3 = PropsSI('P','T',tCondTemp,'Q',0,'R152a');
        t3 = tCondTemp - 5;
        h3 = PropsSI('H','T',t3,'P',p3,'R152a');
        %Point 2
        p2 = p3;
        s2 = s1;
        
        h2s = PropsSI('H','S',s2,'P', p2 ,'R152a');
        h2 = h1 + ((h2s - h1)/0.75);
        t2 = PropsSI('T','H',h2,'P', p2 ,'R152a');
        
        %Point 4
        h4 = h3 ;
        t4 = PropsSI('T','H',h4,'P', p1 ,'R152a');
        cop152A(i) = (h1 - h4)/ (h2 - h1);
        
         if i==3
            aR152a= [p1/1000 h1; p2/1000 h2; p2/1000 h2s; p3/1000 h3; p1/1000 h4;];
            aR152a= aR152a/1000;
        end
end
for j = 1: n
    temp = tEvapTemp(j);
    
     %Point 1

        p1 =PropsSI('P','T',temp,'Q',1,'R134a');
        h1 =PropsSI('H','T',temp+5,'P',p1,'R134a');
        s1 =PropsSI('S','T',temp+5,'P',p1,'R134a');
        t1 = temp+5;
        %Point 3
        p3 = PropsSI('P','T',tCondTemp,'Q',0,'R134a');
        t3 = tCondTemp - 5;
        h3 = PropsSI('H','T',t3,'P',p3,'R134a');
        %Point 2
        p2 = p3;
        s2 = s1;
        
        h2s = PropsSI('H','S',s2,'P', p2 ,'R134a');
        h2 = h1 + ((h2s - h1)/0.75);
        t2 = PropsSI('T','H',h2,'P', p2 ,'R134a');
        
        %Point 4
        h4 = h3 ;
        t4 = PropsSI('T','H',h4,'P', p1 ,'R134a');
        cop134A(j) = (h1 - h4)/ (h2 - h1);
        
        if j==3
            aR134a= [p1/1000 h1; p2/1000 h2; p2/1000 h2s; p3/1000 h3; p1/1000 h4;];
            aR134a= aR134a/1000;
        end
        
       
end

        
        
    