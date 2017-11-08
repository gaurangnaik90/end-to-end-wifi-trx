function recv_symbols = awgn_channel (symbols, modulation, M, snr)
    gamma = 10^(snr/10);
    if (strcmp(modulation,'bpsk'))
        sigma2 = sqrt(1/(2*gamma));
        noise = sigma2 * randn(size(symbols));
    else
        sigma2 = sqrt(1/(2*log2(M)*gamma));
        noise = sigma2*randn(size(symbols)) + 1i*sigma2*randn(size(symbols)); 
    end
    recv_symbols = symbols + noise;
end
