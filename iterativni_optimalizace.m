% Iterativní optimalizace rozdělení dat 
function [ ] = iterativni_optimalizace( tridy2, stredy, zkresleni )
% tridy = rozdělení bodů do shluků
% stredy = středy shluků
% zkresleni = kriteriální funkce J

data_size = size(tridy2);
[pocet_shluku,~] = size(stredy); % počet shluků
velikost_shluku = zeros(1, pocet_shluku); % počet bodů v jednotlivých shlucích

% zjištění počtu bodů ve shlucích
for i = 1:data_size(1)
    velikost_shluku(tridy2(i,3)) = velikost_shluku(tridy2(i,3)) + 1;
end


while true
   zkresleni_new = zkresleni;
   for i = 1:data_size(1)
       a = tridy2(i,3); % do kolikátého shluku patří bod x
      if  velikost_shluku(a) == 1
          break
      else
          % vzdálenosti mi a bodu x
          matice = zeros(1,pocet_shluku);
         
          for j = 1:pocet_shluku
              matice(j) = sum(((stredy(j,1) - tridy2(i,1))^2 + (stredy(j,2) - tridy2(i,2))^2));
          end
          
          % výpočet A_i, A_j
          A = zeros(1,pocet_shluku);
          for j = 1:pocet_shluku
              if a == j
                  A(a) = (velikost_shluku(a) / (velikost_shluku(a) - 1)) * matice(a);
              else
                  A(j) = (velikost_shluku(j) / (velikost_shluku(j) + 1)) * matice(j);
              end
          end
          
          % přesun prvku?
          tmp = A(a);
          A(A == A(a)) = 2*max(A); % "odstranění" prvku A_i z pole
          [~,I] = min(A);
          if tmp > A(I)
              tridy2(i,3) = I;
              zkresleni_new(I) =  zkresleni_new(I) + ((velikost_shluku(I)/(velikost_shluku(I) + 1)) * matice(I));
              zkresleni_new(a) =  zkresleni_new(a) - ((velikost_shluku(a)/(velikost_shluku(a) - 1)) * matice(a));
              stredy(I,1) = stredy(I,1) + (tridy2(a,1) - stredy(I,1)) / (velikost_shluku(I) + 1);
              stredy(I,2) = stredy(I,2) + (tridy2(a,2) - stredy(I,2)) / (velikost_shluku(I) + 1);
              stredy(a,1) = stredy(a,1) - (tridy2(a,1) - stredy(a,1)) / (velikost_shluku(a) - 1);
              stredy(a,2) = stredy(a,2) - (tridy2(a,2) - stredy(a,2)) / (velikost_shluku(a) - 1);
              velikost_shluku(I) = velikost_shluku(I) + 1;
              velikost_shluku(a) = velikost_shluku(a) - 1;
          end
      end
   end
   if zkresleni_new == zkresleni % ukončovací podmínka při nezměněném zkreslení
       break
   else
       zkresleni = zkresleni_new;
   end
end


%% vykreslení
figure('Name','3_iterativni_optimalizace');
colors = [0 0 1; 0 0.5 0; 1 0 0; 0.75 0 0.75; 0 0.75 0.75; 0.75 0.75 0; 0 0 0];
% vykreslení bodů
for i = 1:data_size(1)   
    scatter(tridy2(i,1), tridy2(i,2),[], colors(tridy2(i,3),:),'x')
    hold on
end

% vykreslení středů
for i = 1:size(stredy)
    scatter(stredy(i,1), stredy(i,2),[], colors(7,:),'filled')
end

title('Iterativní optimalizace')
xlabel('x_1')
ylabel('x_2')
end