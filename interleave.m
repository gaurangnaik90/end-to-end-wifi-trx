function interleaved_bits = interleave (bits, width, depth)

    Nb = width * depth;
    if (mod(length(bits),Nb) ~= 0)
        padding_bits = Nb - mod(length(bits),Nb);
        bits = [bits zeros(1,padding_bits)];
    end
    
    interleaved_bits = [];
    for k = 1:Nb:length(bits)
        ind = k:1:k+Nb-1;
        store = reshape(bits(ind),width,depth)';
        interleaved_bits = [interleaved_bits store(:)'];
    end
    
    
end