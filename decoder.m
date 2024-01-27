function y= decoder(max,min,quantized_signal,subband_bits,gk)
    y=zeros(1,240000);

    dequantized_signal=zeros(32,7500);
    for i = 1:32
        for j = 1:12:size(quantized_signal,2)
             [dequantized_signal(i,j:j+11)] = DeQuan(max(i,((j-1)/12 +1)),min(i,((j-1)/12 +1)),subband_bits(i),quantized_signal(i,j:j+11));
        end
    end

    inverse_filter_bank_outputs = zeros(32,240000);
    for i=1:32
        temp = upsample(dequantized_signal(i,:),32);
        inverse_filter_bank_outputs(i,:) = filter(gk(i,:), 1, temp);
    end 
    y = sum(inverse_filter_bank_outputs);
end