function [bits,s_hat] = demodulate (symbols, modulation)

n_symbols = length(symbols);
if (strcmp (modulation, 'bpsk'))
    bits = (symbols > 0);
    s_hat = 2*bits-1;
elseif (strcmp (modulation, 'qpsk'))
    bits = zeros (1, n_symbols * 2);
    s = [1 + 1i, -1 + 1i, -1 - 1i, 1 - 1i];
    s = s/sqrt(mean(abs(s).^2)); % Normalize to unit power
    distances = zeros(4,n_symbols);
    for k = 1:n_symbols
        for l = 1:4
            distances(l,k) = abs(symbols(1,k) - s(l));
        end
    end
    [~,sym] = min(distances);
    s_hat = s(sym);
    for i = 1:length(symbols)
        decoded_symbol = find (s == s_hat(i));
        if (decoded_symbol == 1)
            bits(2*i - 1) = 0;
            bits(2*i) = 0;
        elseif (decoded_symbol == 2)
            bits(2*i - 1) = 0;
            bits (2*i) = 1;
        elseif (decoded_symbol == 3)
            bits (2*i - 1) = 1;
            bits (2*i) = 1;
        elseif (decoded_symbol == 4)
            bits (2*i - 1) = 1;
            bits (2*i) = 0;
        end
    end
elseif (strcmp (modulation, '8psk'))
    bits = zeros (1, n_symbols*3);
    s = [1 + 1i * 0, 1/sqrt(2) + 1i * 1/sqrt(2), 0 + 1i, - 1/sqrt(2) + 1i * 1/sqrt(2), -1 + 1i * 0, -1/sqrt(2) - 1i * 1/sqrt(2), 0 - 1i, 1/sqrt(2) - 1i * 1/sqrt(2) ];
    s = s/sqrt(mean(abs(s).^2)); % Normalize to unit power
    distances = zeros(8,n_symbols);
    for k = 1:n_symbols
        for l = 1:8
            distances(l,k) = abs(symbols(1,k) - s(l));
        end
    end
    [~,sym] = min(distances);
    s_hat = s(sym);
    for i = 1:n_symbols
        decoded_symbol = find (s == s_hat(i));
        if (decoded_symbol == 1)
            bits (3*i - 2) = 0;
            bits (3*i - 1) = 0;
            bits (3*i) = 0;
        elseif (decoded_symbol == 2)
            bits (3*i - 2) = 0;
            bits (3*i - 1) = 0;
            bits (3*i) = 1;
        elseif (decoded_symbol == 3)
            bits (3*i - 2) = 0;
            bits (3*i - 1) = 1;
            bits (3*i) = 1;
        elseif (decoded_symbol == 4)
            bits (3*i - 2) = 0;
            bits (3*i - 1) = 1;
            bits (3*i) = 0;
        elseif (decoded_symbol == 5)
            bits (3*i - 2) = 1;
            bits (3*i - 1) = 1;
            bits (3*i) = 0;
        elseif (decoded_symbol == 6)
            bits (3*i - 2) = 1;
            bits (3*i - 1) = 1;
            bits (3*i) = 1;
        elseif (decoded_symbol == 7)
            bits (3*i - 2) = 1;
            bits (3*i - 1) = 0;
            bits (3*i) = 1;
        elseif (decoded_symbol == 8)
            bits (3*i - 2) = 1;
            bits (3*i - 1) = 0;
            bits (3*i) = 0;
        end
    end
elseif (strcmp (modulation, '16qam'))
    bits = zeros (1, n_symbols * 4);
    s = [-3+1i*3, -3+1i, -3-1i, -3-1i*3, -1 + 1i*3, -1 + 1i, -1 - 1i, -1 - 1i*3, 1 + 1i * 3, 1 + 1i, 1 - 1i, 1 - 1i*3, 3 + 1i*3, 3 + 1i, 3 - 1i, 3 - 1i*3];
    s = s/sqrt(mean(abs(s).^2)); % Normalize to unit power
    distances = zeros(16,n_symbols);
    for k = 1:n_symbols
        for l = 1:16
            distances(l,k) = abs(symbols(1,k) - s(l));
        end
    end
    [~,sym] = min(distances);
    s_hat = s(sym);

    for i = 1:n_symbols
        decoded_symbol = find (s == s_hat(i));
        if (decoded_symbol == 1)
            bits(4*i-3) = 0;
            bits(4*i-2) = 0;
            bits(4*i-1) = 0;
            bits(4*i) = 0;
        elseif (decoded_symbol == 2)
            bits(4*i-3) = 0;
            bits(4*i-2) = 0;
            bits(4*i-1) = 0;
            bits(4*i) = 1;
        elseif (decoded_symbol == 3)
            bits(4*i-3) = 0;
            bits(4*i-2) = 0;
            bits(4*i-1) = 1;
            bits(4*i) = 1;
        elseif (decoded_symbol == 4)
            bits(4*i-3) = 0;
            bits(4*i-2) = 0;
            bits(4*i-1) = 1;
            bits(4*i) = 0;
        elseif (decoded_symbol == 5)
            bits(4*i-3) = 0;
            bits(4*i-2) = 1;
            bits(4*i-1) = 0;
            bits(4*i) = 0;
        elseif (decoded_symbol == 6)
            bits(4*i-3) = 0;
            bits(4*i-2) = 1;
            bits(4*i-1) = 0;
            bits(4*i) = 1;
        elseif (decoded_symbol == 7)
            bits(4*i-3) = 0;
            bits(4*i-2) = 1;
            bits(4*i-1) = 1;
            bits(4*i) = 1;
        elseif (decoded_symbol == 8)
            bits(4*i-3) = 0;
            bits(4*i-2) = 1;
            bits(4*i-1) = 1;
            bits(4*i) = 0;
        elseif (decoded_symbol == 9)
            bits(4*i-3) = 1;
            bits(4*i-2) = 1;
            bits(4*i-1) = 0;
            bits(4*i) = 0;
        elseif (decoded_symbol == 10)
            bits(4*i-3) = 1;
            bits(4*i-2) = 1;
            bits(4*i-1) = 0;
            bits(4*i) = 1;
        elseif (decoded_symbol == 11)
            bits(4*i-3) = 1;
            bits(4*i-2) = 1;
            bits(4*i-1) = 1;
            bits(4*i) = 1;
        elseif (decoded_symbol == 12)
            bits(4*i-3) = 1;
            bits(4*i-2) = 1;
            bits(4*i-1) = 1;
            bits(4*i) = 0;
        elseif (decoded_symbol == 13)
            bits(4*i-3) = 1;
            bits(4*i-2) = 0;
            bits(4*i-1) = 0;
            bits(4*i) = 0;
        elseif (decoded_symbol == 14)
            bits(4*i-3) = 1;
            bits(4*i-2) = 0;
            bits(4*i-1) = 0;
            bits(4*i) = 1;
        elseif (decoded_symbol == 15)
            bits(4*i-3) = 1;
            bits(4*i-2) = 0;
            bits(4*i-1) = 1;
            bits(4*i) = 1;
        elseif (decoded_symbol == 16)
            bits(4*i-3) = 1;
            bits(4*i-2) = 0;
            bits(4*i-1) = 1;
            bits(4*i) = 0;
        end
    end
end
end
