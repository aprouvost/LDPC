% Authors HBA CLA


function c_cor = hard_decoder(c, H, MAX_ITER)
    % c matrice de taille (N,1)
    % M matrice binaire de taille (M,N)
    % MAX_ITER int 

    [c_rows, c_cols] = size(c);
    [H_rows, H_cols] = size(H);

    % TODO :: check input confomity 

    number_of_Vnodes = c_cols
    number_of_Cnodes = c_rows

    iteration_c = c

    % main loop 
    for iteration = 1:MAX_ITER
        % initlize messages and Responses
        Messages = -1 * ones(number_of_Cnodes,number_of_Vnodes);
        Responses = -1 * ones(number_of_Cnodes,number_of_Vnodes);

        for ligne = 1:H_rows
            for colonne = 1:H_cols
                if H(ligne, colonne) == 1
                    Messages(ligne, colonne) == iteration_c(colonne)
                end
            end
        end

        % Response block 
        for ligne = 1:number_of_Vnodes
            for colonne = 1:number_of_Cnodes
                if Messages(ligne, colonne) ~= 1
                    parity_total = 0;
                    for total_colomn_parity = 1:number_of_Vnodes
                        if (total_colomn_parity ~= colonne) && (Messages(ligne,total_colomn_parity) ~= -1)
                            parity_total = parity_total + Messages(ligne, total_colomn_parity);
                        end
                    end
                    if mod(parity_total, 2) == 0
                        Responses(ligne, colonne) = 0;
                    else
                        Responses(ligne, colonne) = 1;
                    end
                end
            end
        end
end


function is_vector_even = parity_check(c, H, c_nodes, v_nodes)
    % Do the parity check for the given c
    is_vector_even = zeros(c_nodes, 1);
    for row = 1:c_nodes
        parity = 0;
        for col = 1:v_nodes
            if H(row, col) ~= 0
                parity = parity + c(col);
            end
        end
        is_vector_even(row) = mod(parity, 2);
    end
end