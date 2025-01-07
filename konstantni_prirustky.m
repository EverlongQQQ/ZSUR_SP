% Rozdělení prostoru pomocí metody konstantních přírůstků
function [ ] = konstantni_prirustky( tridy, stredy, delta, beta )
% tridy = rozdělení bodů do shluků
% stredy = středy shluků
% delta = pásmo necitlivosti
% beta = konstanta učení

data_size = size(tridy);
[pocet_shluku,~] = size(stredy); % počet shluků


% inicializace přímek náhodnými hodnotami
q = cell(1,pocet_shluku);
for i = 1:pocet_shluku
    q{i} = rand(data_size(2),1);
end

% trénování
iterace = 0;
for i = 1:pocet_shluku
    while true
        error = 0;
        for j = 1:data_size(1)
            x = [1 tridy(j, 1) tridy(j,2)]';
            
            if tridy(j,3) == i
                omega = 1;
            else
                omega = -1;
            end
            
            c_k = beta / sum(x.^2);
            tmp = q{i}' * x * omega; % malé omega
            
            if tmp < delta
                q{i} = q{i} + c_k * (x * omega);
                error = error + 1;
            end
        end
        iterace = iterace + 1;
        if error == 0
            break
        end
    end
end
                





% mřížka bodů
rastr = 0.5;
x = (min(tridy(:,1))-0.1):rastr:(max(tridy(:,1))+0.1);
y = (min(tridy(:,2))-0.1):rastr:(max(tridy(:,2))+0.1);


% vykreslení
colors = [0 0 1; 0 0.5 0; 1 0 0; 0.75 0 0.75; 0 0.75 0.75; 0.75 0.75 0; 0 0 0];
name = strcat('4d_konst_prirustky_', num2str(beta)); 
figure('Name',name);
hold on
for i = x
    for j = y
        for k = 1:pocet_shluku
            tmp = q{k}(2)*i + q{k}(3)*j + q{k}(1);
            if tmp >= 0
                list(k) = 1;
            else 
                list(k) = 0;
            end
        end
        
        if sum(list) == 1
            [~,I] = max(list);
            scatter(i, j,[], colors(I,:),'h')
        else
            scatter(i, j,[], [0.8 0.8 0.8],'h')
        end
    end
end

%% vykreslení přímek
 lim_x = xlim;
 lim_y = ylim;
for i = 1:pocet_shluku
    y = (-q{i}(2)*x -q{i}(1))/q{i}(3);
    plot(x,y,'Color', colors(i,:))
end
xlim(lim_x)
ylim(lim_y)

%vykreslení bodů
for i = 1:data_size(1)   
    scatter(tridy(i,1), tridy(i,2),[], colors(tridy(i,3),:),'x')
end

% vykreslení středů
for i = 1:size(stredy)
    scatter(stredy(i,1), stredy(i,2),[], colors(7,:),'filled')
end
title('Metoda konstantních přírůstků')
xlabel('x_1')
ylabel('x_2')

txt = strcat('Počet iterací: ', num2str(iterace), ', \beta: ', num2str(beta), ' \delta: ', num2str(delta));
text(lim_x(1), lim_y(1)+2, txt)
end