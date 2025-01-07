% Rozdělení dat metodou k-means do určeného počtu tříd
function [ tridy, mi, zkresleni ] = k_means( data, R )
% data = mnozina obrazu
% R = počet tříd
% vrací [data ve třídách, středy, kriteriální funkce J]

data_size = size(data);
tridy = data;
c = 0; %zastavovací counter

% náhodná volba počátečních středů
mi = zeros(R,2);
tmp = zeros(R,1);
while true
    for i = 1:R
        r = 1 + (data_size(1)-1)*rand(1); % náhodné číslo počátečního bodu
        r = round(r);
        tmp(i) = r;
    end
    if size(unique(tmp),1) == R
        break;
    end
end
%tmp = [1 2 3 4];
figure('Name','start_b_k-means')
hold on
for i = 1:R
    mi(i,:) = data(tmp(i),:);
    scatter(mi(i,1), mi(i,2),'filled')
end
title('Počáteční body pro k-means')

   

% algoritmus
while true
    % vzdálenosti mi a ostatních bodů
    matice = zeros(R,data_size(1));
    for i = 1:size(mi,1)
        for j = 1:data_size(1)
            matice(i,j) = sum((mi(i,:) - data(j,:)).^2);
        end
    end
    
    % rozdělení dat do tříd
    zkresleni = zeros(R,1);
    for i = 1:data_size(1)
        [M,I] = min(matice(:,i));
        tridy(i,3) = I;
        zkresleni(I) = zkresleni(I) + M;
    end
    
    % přepočtení středů shluků
    mi_new = mi;
    for i = 1:R
        suma = zeros(1,data_size(2));
        counter = 0;
        for j = 1:data_size(1)
            if tridy(j,3) == i
                for k = 1:data_size(2)
                    suma(k) = suma(k) + tridy(j,k);
                end
                counter = counter + 1;
            end
        end
        suma = suma / counter;
        mi_new(i,:) = suma;
    end
    
    if mi_new == mi % kontrola ukončovací podmínky
        break;
    else
        mi = mi_new;
        if c > 5000
            disp('Něco se pokazilo v k-means, metoda včas nedokonvergovala');
            break;
        end
    end
    c = c + 1; %zastavovaci counter
end


%% test data
% data = [0 1; 2 1; 1 3; 1 -1; 1 5; 1 9; -1 7; 3 7];

%% vykreslení
figure('Name','2_k-means');
colors = [0 0 1; 0 0.5 0; 1 0 0; 0.75 0 0.75; 0 0.75 0.75; 0.75 0.75 0; 0 0 0];
% vykreslení bodů
for i = 1:data_size(1)   
    scatter(tridy(i,1), tridy(i,2),[], colors(tridy(i,3),:),'x')
    hold on
end

% vykreslení středů
for i = 1:size(mi)
    scatter(mi(i,1), mi(i,2),[], colors(7,:),'filled')
end
title('Metoda k-means - rozdělení dat do shluků')
xlabel('x_1')
ylabel('x_2')
end