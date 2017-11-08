function deinterleaved_bits = deinterleave (bits, width, depth)

    Nb = width * depth;
    deinterleaved_bits = [];
    for k = 1:Nb:length(bits)
        ind = k:1:k+Nb-1;
        store = reshape(bits(ind),depth,width)';
        deinterleaved_bits = [deinterleaved_bits store(:)'];
    end
    

end
