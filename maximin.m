% určení počtu tříd metodou MAXIMIN
function [ output_args ] = maximin( data, q )
% data = mnozina obrazu
% q = volitelná konstanta
% vrací [ počet tříd ]

data_size = size(data);
r = 1 + (data_size(1)-1)*rand(1); % náhodné číslo počátečního bodu
r = round(r);
startovni_bod = 7;

mi(1,:) = data(startovni_bod,:);

%matice = zeros(data_size(1), 1);
for i = 1:data_size(1)
    matice(i) = sum((data(startovni_bod,:) - data(i,:)).^2); %vzdálenost mi(1) a ostatních bodů
end
[~,I] = max(matice); % [hodnota, pozice]
mi(2,:) = data(I,:); % nejvzdálenější bod od mi(1)
data(startovni_bod,:) = 0;
data(I,:) = 0;

%tmp = zeros(size(mi,1), data_size(1));
while true
    for i = 1:size(mi,1)
       for j = 1:data_size(1)
           tmp(i,j) = sum((mi(i,:) - data(j,:)).^2); %vzdálenosti všech bodů od všech středů
       end
    end
    tmp(tmp == 0 ) = NaN;
    
    for i = 1:data_size(1)
        matice(i) = min(tmp(:,i)); % uchované minimální vzdálenosti
    end
    
    C = nchoosek(1:size(mi,1),2); % kombinace všech středů
    %C = combnk(1:size(mi,1),2); % kombinace všech středů
    avg_stred = 0;
    for i = 1:size(C,1)
        avg_stred = avg_stred + sum(mi(C(i,1),:) - mi(C(i,2),:)).^2;
    end
    avg_stred = avg_stred / size(C,1);
    
    if max(matice) > q*avg_stred 
        [~,I] = max(matice);
        mi(size(mi,1) + 1,:) = data(I,:);
        data(I,:) = 0;
    else
        break
    end
end

%% test data
% data = [2 -3; 3 3; 2 2; -3 1; -1 0; -3 -2; 1 -2; 3 2];

%%
output_args = size(mi,1);
end