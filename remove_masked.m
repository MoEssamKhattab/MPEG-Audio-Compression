function LK = remove_masked(masker_index, LK, Fs, k)

    masker_freq = masker_index * Fs/1024;
    right_most_freq = masking_threshold(LK(1,masker_index), masker_freq);
    right_most_thre_of_quite = threshold_of_quite(right_most_freq);

    right_most_index = floor(right_most_freq * (1024/Fs));
    if right_most_index > (k+1) * 16
        right_most_index = (k+1) * 16; 
    end

    xx = [masker_freq right_most_freq];
    yy = [LK(1,masker_index) right_most_thre_of_quite];
    p = polyfit(xx, yy, 1);
    
    for n=masker_index+1 :right_most_index
        if LK(1,n) < 1.5 * polyval(p, n * (Fs/1024))
            LK(1, n) = 0;
        end 
    end
end