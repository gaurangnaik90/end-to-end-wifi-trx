function [recv_symbols,h] = rayleigh_channel (symbols, modulation, M, snr) 
    h=1/sqrt(2)*(randn(1,length(symbols))+1i*randn(1,length(symbols))); 
    noise = 1/sqrt(2)*(randn(1,length(symbols))+1i*randn(1,length(symbols)));
    recv_symbols = h.*symbols + 10^(-snr/20)*noise;
end
