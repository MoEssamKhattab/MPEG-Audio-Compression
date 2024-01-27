%% Encoder

function [max, min, quantized_signal, bit_allocation_vector] = Encoder(filterbank_subbands, LKs, BPS_signal, N)
    fft_full = fft(filterbank_subbands, N, 2);
    right_fft = abs(fft_full(:, 513:end));
    fft_subbands = zeros(32,16);
%     plot(abs(fft_full(1,:)));
    for i = 0:31
        fft_subbands(i+1,:) = right_fft(i+1, i*16 + 1: i*16 + 16);
    end
    fft_subbands = 20 * log2(fft_subbands);
    % Calculate information content within each subband
    sum_spl = sum(fft_subbands .* LKs, 2);
    
    bit_allocation_vector = bit_allocate(sum_spl, BPS_signal);  % BPS = 16

    % quantize the output of filter bank and downsampler
    quantized_signal = zeros(32,size(filterbank_subbands,2));
    max=zeros(32,625);
    min=zeros(32,625);
    for i = 1:32
        for j = 1:12:size(filterbank_subbands,2)
            [max(i,((j-1)/12 +1)), min(i,((j-1)/12 +1)), quantized_signal(i,j:j+11)] = Quan(filterbank_subbands(i, j:j+11), bit_allocation_vector(i));
        end
    end
end