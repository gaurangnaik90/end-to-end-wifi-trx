function [encoded_bits,H] = ldpc_encoder (bits, Z, matrix)

H = zeros(size(matrix)*Z);
Zh = diag(ones(1,Z),0);

[n_row, n_col] = size(matrix);
for r=1:n_row
    for c=1:n_col
        idx = matrix(r,c);
        if (idx > -1)            
            Zt = circshift(Zh,[0 idx]);
        else
            Zt = zeros(Z);
        end
        limR = (r-1)*Z+1:r*Z;
        limC = (c-1)*Z+1:c*Z;
        H(limR,limC) = Zt;
    end
end


[m,n] = size(H);
k = n - m;

if (mod(length(bits),k) ~= 0)
    padding_bits = k - mod(length(bits),k);
    bits = [bits zeros(1,padding_bits)];
end

encoded_bits = [];

for i = 1:k:length(bits)
    ind = i:1:i+k-1;
    msg = bits(ind);
    Hrow1 = H(:,end);
    for i=1:n
        if Hrow1(i) == 1
            g = i;
            break;
        end
    end
    g = m - g;
    wA = n-m;
    wB = g;
    eA = wA;
    eB = wA + wB;
    A = H(1:m-g,1:eA);
    B = H(1:m-g,eA+1:eB);
    T = H(1:m-g,eB+1:end);
    C = H(m-g+1:end,1:eA);
    D = H(m-g+1:end,eA+1:eB);
    E = H(m-g+1:end,eB+1:end);
    invT = (inv(T)); 
    ET1 = -(E*invT);
    Iup = diag(ones(1,size(ET1,2)),0);
    Idn = diag(ones(1,size(ET1,1)),0);
    X = [Iup zeros(size(Iup,1),size(Idn,2)); ET1 Idn];
    Y = X*H;
    phi = ET1*B + D;
    xtra = ET1*A + C;
    p1 = mod(phi*xtra*(msg'),2)';
    p2 = mod(invT*(A*(msg') + B*(p1')),2)';
    encoded_bits = [encoded_bits msg p1 p2];
end

end