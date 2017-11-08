function decoded_bits = ldpc_decoder (encoded_bits, H, n_iterations)

    decoded_bits = [];
    [m,n] = size (H);
    k = n - m;
        
    N_connections = zeros(1,n);
    for i = 1:n
        N_connections(1,i) = sum(H(:,i));
    end
    max_connections = max(N_connections);
    
    for it = 1:n:length(encoded_bits)
        ind = it:1:it+n-1;
        current_c = encoded_bits(ind);
        prev_c = zeros(1,length(encoded_bits(ind)));
        for iter = 1:n_iterations
            if (sum(prev_c - current_c) == 0)
                break;
            else
                prev_c = current_c;
            end
            vote_matrix = -1*ones(max_connections+1,n);
            count = zeros(1,n);
            for i = 1:m
                var_nodes = find(H(i,:) == 1);
                for check = 1:length(var_nodes)
                    count(var_nodes(check)) = count(var_nodes(check)) + 1;
                    if (mod(sum(current_c(var_nodes)),2))
                        vote_matrix (count(var_nodes(check)),var_nodes(check)) = ~current_c(1,var_nodes(check));
                    else
                        vote_matrix (count(var_nodes(check)),var_nodes(check)) = current_c(1,var_nodes(check));
                    end
                end     
            end
            vote_matrix (end,:) = current_c;
            for i = 1:n
                t = vote_matrix (:,i);
                [~,result] = max([length(find(t == 0)) length(find(t == 1))]);
                current_c(1,i) = result - 1;
            end
        end
        decoded_bits = [decoded_bits current_c(1:k)];
    end
    
end
