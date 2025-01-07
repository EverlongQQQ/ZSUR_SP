% Rozdělení bodů pomocí Bayesova klasifikátoru
function [ ] = bayes( tridy2, stredy )
% tridy = rozdělení bodů do shluků
% stredy = středy shluků


data_size = size(tridy2);
[pocet_shluku,~] = size(stredy); % počet shluků
velikost_shluku = zeros(1, pocet_shluku); % počet bodů v jednotlivých shlucích

% zjištění počtu bodů ve shlucích
for i = 1:data_size(1)
    velikost_shluku(tridy2(i,3)) = velikost_shluku(tridy2(i,3)) + 1;
end

% % vypočtení apriorních pravděpodobností shluků
% P_omega = zeros(1,pocet_shluku);
% for i = 1:pocet_shluku
%     P_omega(i) = velikost_shluku(i) / data_size(1);
% end

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

% výpočet kovarianční matice Gaussovského (normálního) rozdělení
sigma = cell(1,pocet_shluku);
sigma(:) = {zeros(size(stredy,2))};
for i = 1:pocet_shluku
    tmp_sigma = zeros(size(stredy,2));
    for j = 1:data_size(1)
        if tridy2(j,3) == i
            tmp(1) = tridy2(j,1) - mi(i,1);
            tmp(2) = tridy2(j,2) - mi(i,2);
            tmp_sigma = tmp_sigma + (tmp' * tmp);
        end
    end
    tmp_sigma = tmp_sigma / velikost_shluku(i);
    sigma{i} = tmp_sigma;
end

% mřížka bodů pro výpočet Gaussova (normálního) rozdělení
rastr = 0.5;
x = (min(tridy2(:,1))-0.1):rastr:(max(tridy2(:,1))+0.1);
y = (min(tridy2(:,2))-0.1):rastr:(max(tridy2(:,2))+0.1);
[X,Y] = meshgrid(x,y);

% výpočet Gaussovo rozdělení
for i = 1:pocet_shluku
    tmp_gauss = mvnpdf([X(:) Y(:)],mi(i,:),sigma{i});
    tmp_gauss = reshape(tmp_gauss,length(y),length(x));
    gauss{i} = tmp_gauss;
end



%% vykreslení
colors = [0 0 1; 0 0.5 0; 1 0 0; 0.75 0 0.75; 0 0.75 0.75; 0.75 0.75 0; 0 0 0];

% vykreslení pravděpodobnostní mřížky
figure('Name','4a_bayes');
y_in_gauss = 1;
for i = x
    x_in_gauss = 1;
    for j = y
        nejvetsi_pravdepodobnost = 0;
        nejvetsi_pravdepodobnost_k = 0;
        for k = 1:pocet_shluku
            if gauss{k}(x_in_gauss,y_in_gauss) > nejvetsi_pravdepodobnost
                nejvetsi_pravdepodobnost = gauss{k}(x_in_gauss,y_in_gauss);
                nejvetsi_pravdepodobnost_k = k;
            end
            %scatter(i, j,gauss{1}(x_in_gauss, y_in_gauss), colors(tridy(i,3),:),'x')
            %surf(i,j,gauss{1}(x_in_gauss,y_in_gauss));
            
        end
        scatter(i, j,[], colors(nejvetsi_pravdepodobnost_k,:),'h')
        hold on
        x_in_gauss = x_in_gauss + 1;
    end
    y_in_gauss = y_in_gauss + 1;
end

% vykreslení bodů
for i = 1:data_size(1)   
    scatter(tridy2(i,1), tridy2(i,2),[], colors(tridy2(i,3),:),'x')
    hold on
end

% vykreslení středů
for i = 1:size(stredy)
    scatter(stredy(i,1), stredy(i,2),[], colors(7,:),'filled')
end
title('Bayesův klasifikátor')
xlabel('x_1')
ylabel('x_2')

% vykreslení 3D grafu normálních rozdělení
figure('Name','4a_bayes_gauss');
for i = 1:pocet_shluku
    surf(x,y,gauss{i})
    hold on
end
clim([0 0.1])
title('Gaussovo rozdělení')
end