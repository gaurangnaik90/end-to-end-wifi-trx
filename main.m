% clc;
% close all;
% clear all;

%% Component Switches
ldpc_on = 1; % bool for LDPC on/off
interleaver_on = 1; % bool for Interleaver on/off
ofdm_on = 1;
rayleigh_on = 1;
%% Parameters
n_bits = 100000;
simulation_runs = 1;
% Modulation
modulation = 'bpsk'; % Modulation options - bpsk, qpsk, 8psk, 16qam
M = 2;
% Coding
rate = 1/2;
Z = 27; % Number of sub-blocks for LDPC as defined in Wi-Fi standard
n_iter = 10; % Number of iterations for LDPC decoding
% Interleaver
width = 100; % Width of the interleaver
depth = 500; % Depth of the interleaver
% Noise
Eb = 1;
EbNo_dB = [0:3:35];
% OFDM 
N = 64;
N_data = 48;
N_pilot = 4;
N_used = N_data + N_pilot;
BW = 20 * 10^6;
delta_f = BW / N;
T_fft = 1/delta_f;
T_gi = T_fft/4;
T_signal = T_fft + T_gi;
N_cp = N * T_gi / T_fft;
bits_per_symbol = N_used;
ofdm_EsNo_dB = EbNo_dB + 10 * log10 (N_used/N) + 10 * log10(N/(N_cp + N));

errors = zeros(1,length(EbNo_dB));
symbol_errors = zeros(1,length(EbNo_dB));

for snr = 1:length(EbNo_dB)
    EbNo_dB(snr)
    for run = 1:simulation_runs
        % Transmitter side
        bits = randi([0 1], 1, n_bits);
        if (ldpc_on)
            [matrix,n,k] = get_ldpc_params (rate, Z);
            N_encode = length(bits); % Number of bits that went into the encoder
            [encoded_bits,H] = ldpc_encoder (bits, Z, matrix);
            if (interleaver_on)
                width = n;
                N_interleave = length(encoded_bits); % Number of bits that went into the interleaver
                interleaved_bits = interleave (encoded_bits, width, depth);
                N_modulation = length(interleaved_bits); % Number of bits that went into the modulator
                symbols = modulate (interleaved_bits, modulation);
            else
                N_modulation = length(encoded_bits);
                symbols = modulate (encoded_bits, modulation);
            end
        else
            N_modulation = length(bits);
            symbols = modulate (bits, modulation);
        end
        N_symbols = length(symbols);
        % Channel side
        if (ofdm_on)
            if (strcmp(modulation,'16qam'))
                error('Current OFDM support only for BPSK/QPSK/8-PSK');
                break;
            end
            if (rayleigh_on)
                recv_symbols = ofdm_rayleigh_channel(symbols, modulation, M, ofdm_EsNo_dB(snr));% Use OFDM before passing through channel
            else
                recv_symbols = ofdm_channel(symbols, modulation, M, ofdm_EsNo_dB(snr));% Use OFDM before passing through channel
            end
        else
            if (rayleigh_on)
                [recv_symbols,h] = rayleigh_channel(symbols, modulation, M, EbNo_dB(snr));
            else
                recv_symbols = awgn_channel(symbols, modulation, M, EbNo_dB(snr));
            end
        end
        % Receiver side
        if (rayleigh_on)
            if (~ofdm_on)
                recv_symbols = recv_symbols./h; % Single tap equalization, assuming channel is perfectly known at the receiver
            end
        end
        [received_bits,decoded_symbols] = demodulate (recv_symbols, modulation);
        received_bits = received_bits (1:N_modulation);
        if (ldpc_on)
            if (interleaver_on)
                deinterleaved_bits = deinterleave (received_bits, width, depth);
                deinterleaved_bits = deinterleaved_bits(1:N_interleave);
                decoded_bits = ldpc_decoder (deinterleaved_bits, H, n_iter);
            else
                decoded_bits = ldpc_decoder (received_bits, H, n_iter);
            end
            bits_hat = decoded_bits;
        else
            bits_hat = received_bits(1:n_bits);
        end
        errors(snr) = errors(snr) + length(find(bits - bits_hat(1:n_bits)));
        symbol_errors(snr) = symbol_errors(snr) + length(find((abs(symbols - decoded_symbols)).^2 > 0.001));
    end
    errors(snr) = errors(snr)/(n_bits * simulation_runs);
    symbol_errors(snr) = symbol_errors(snr)/(N_symbols * simulation_runs);
end

semilogy(EbNo_dB,errors,'r');
hold on;
% save('bpsk_ldpc_on_interleaver_on_awgn');
save('bpsk_rayleigh_ofdm_ldpc_interleaver_depth_500');
axis([0 25 10^-7 10^0]);
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
% save('bpsk_awgn');

