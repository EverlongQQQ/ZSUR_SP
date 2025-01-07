% jednoprůchodový heuristický algoritmus hledání shluků
function [ output_args ] = shlukove_hladiny( data, t )
% data = mnozina obrazu
% t = mira podobnosti t > 0
% vrací [ počet hladin    rozdělení dat do hladin ]

data_size = size(data);
my(1,:) = data(1,:); % střed prvního shluku
T = zeros(data_size(1),1); 
T(1) = 1; % představuje do kterého shluku patří data(i)

for i = 2:data_size(1)    
    for j = 1:my_size(1)
        d(j) = norm(data(i) - my(j)); %vzdálenost dvou bodů
        if d(j) <= t
            T(i) = j;
            break
        end
    end
    if T(i) == 0
        my(my_size(1) + 1,:) = data(i,:);
        T(i) = my_size(1) + 1;
    end
    my_size = size(my);
end

output_args = [ ];

end