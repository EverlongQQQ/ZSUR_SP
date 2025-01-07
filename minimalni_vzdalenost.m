% Rozdělení bodů pomocí klasifikátoru s minimální vzdáleností
function [ ] = minimalni_vzdalenost( tridy2, stredy )
% tridy = rozdělení bodů do shluků
% stredy = středy shluků

data_size = size(tridy2);
[pocet_shluku,~] = size(stredy); % počet shluků
velikost_shluku = zeros(1, pocet_shluku); % počet bodů v jednotlivých shlucích

% zjištění počtu bodů ve shlucích
for i = 1:data_size(1)
    velikost_shluku(tridy2(i,3)) = velikost_shluku(tridy2(i,3)) + 1;
end

% výpočet středních hodnot Gaussovského (normálního) rozdělení
mi = zeros(pocet_shluku,2);
for i = 1:pocet_shluku
    for j = 1:data_size(1)
        if tridy2(j,3) == i
            mi(i,1) = mi(i,1) + tridy2(j,1);
            mi(i,2) = mi(i,2) + tridy2(j,2);
        end
    end
    mi(i,:) = mi(i,:) / velikost_shluku(i);
end

% mřížka bodů
rastr = 0.5;
x = (min(tridy2(:,1))-0.1):rastr:(max(tridy2(:,1))+0.1);
y = (min(tridy2(:,2))-0.1):rastr:(max(tridy2(:,2))+0.1);

% výpočet diskriminační funkce, zařazení bodu a vykreslení mřížky
colors = [0 0 1; 0 0.5 0; 1 0 0; 0.75 0 0.75; 0 0.75 0.75; 0.75 0.75 0; 0 0 0];
figure('Name','4b_min_vzdalenost');
hold on
for i = x
    for j = y
        g = zeros(1,pocet_shluku);
        for k = 1:pocet_shluku
            g(k) = (i - mi(k,1))^2 + (j - mi(k,2))^2;
        end
        [~,I] = min(g);
        scatter(i, j,[], colors(I,:),'h')
    end
end

% vykreslení bodů
for i = 1:data_size(1)   
    scatter(tridy2(i,1), tridy2(i,2),[], colors(tridy2(i,3),:),'x')
end

% vykreslení středů
for i = 1:size(stredy)
    scatter(stredy(i,1), stredy(i,2),[], colors(7,:),'filled')
end
title('Klasifikátor podle minimální vzdálenosti')
xlabel('x_1')
ylabel('x_2')

end