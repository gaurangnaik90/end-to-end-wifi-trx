function recv_symbols = ofdm_rayleigh_channel (symbols, modulation, M, snr)

    N = 64;
    N_data = 48;
    N_pilot = 4;
    N_used = N_data + N_pilot;
    BW = 20 * 10^6;
    delta_f = BW / N;
    T_fft = 1/delta_f;
    T_gi = T_fft/4;
    N_cp = N * T_gi / T_fft;
    
    N_symbols = length(symbols);
    if (mod(N_symbols,N_used) ~= 0)
        padding_bits = zeros(1,log2(M) * (N_used - mod(N_symbols,N_used)));
        padding_symbols = modulate(padding_bits, modulation);
        symbols = [symbols padding_symbols];
    end
    
    recv_symbols = zeros(size(symbols));
    
    for i = 1:N_used:length(symbols) % This includes padding bits
        ind = i:1:i+N_used-1;
        sym = symbols(ind);
        X_Freq=[zeros(1,1) sym(1:N_used/2) zeros(1,11) sym(N_used/2+1:end)];
        x_Time=N/sqrt(N_used)*ifft(X_Freq); % Convert to 'time domain', normalize to unit power
        ofdm_signal=[x_Time(N-N_cp+1:N) x_Time]; % Add cyclic prefix to generate an ofdm symbol
        h=1/sqrt(2)*(randn(1,1)+1i*randn(1,1)); % Channel gain, single tap
        H = fft(h);
        noise = 10^(-snr/20)/sqrt(2)*(randn(1,length(ofdm_signal))+1i*randn(1,length(ofdm_signal)));
        
        r = sqrt((N+N_cp)/N)*h.*ofdm_signal + noise; % Same as convolution

        r_Parallel=r(N_cp+1:(N+N_cp)); % Remove cyclic prefix
        r_Time=(fft(r_Parallel));
        r_Time = r_Time./H;
        recv_sym=r_Time([(2:N_used/2+1) (N_used/2+13:N_used+12)]);
        recv_symbols(ind) = recv_sym;
    end
    
    recv_symbols = recv_symbols(1:N_symbols);
end