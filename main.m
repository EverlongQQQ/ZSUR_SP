tic
inicializace;
%% 1
%a)
tridy(1) = shlukove_hladiny(data);
% b)
tridy(2) = retezove_mapy(data, 5);
% c)
tridy(3) = maximin(data, 0.3);
%%
pocet_trid = (tridy(1) + tridy(2) + tridy(3)) / 3;
pocet_trid = round(pocet_trid);   
%% 2
[tridy_k, stredy_k, J_k] = k_means(data, pocet_trid);
%%
[tridy, stredy, J] = nerovnomerne_binarni_deleni(data, pocet_trid);
%% 3
iterativni_optimalizace(tridy_k, stredy_k, J_k);
iterativni_optimalizace(tridy, stredy, J);   
%% 4
% a)
bayes(tridy, stredy);
% b)
minimalni_vzdalenost(tridy, stredy);
%% c)
nejblizsi_soused(tridy, stredy);
%% d)
rosenblattuv_algoritmus(tridy, stredy);
konstantni_prirustky(tridy, stredy, 1, 0.2);
konstantni_prirustky(tridy, stredy, 1, 1);
konstantni_prirustky(tridy, stredy, 1, 3);
upravene_konstantni_prirustky(tridy, stredy, 1, 0.2);
upravene_konstantni_prirustky(tridy, stredy, 1, 1);
upravene_konstantni_prirustky(tridy, stredy, 1, 3);
%ulozeni_figur
toc
