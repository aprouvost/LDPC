% Authors HBA CLA


function c_cor = HARD_DECODER_GROUPE2(c, H, MAX_ITER)
    % c matrice de taille (N,1) - Flux de bits 
    % M matrice binaire de taille (M,N) - Matrice d association 
    % MAX_ITER int - Maximum d iteration

    [c_rows, c_cols] = size(c); %On recupere le nombre de colonne et le nombre de ligne de c 
    [H_rows, H_cols] = size(H); %On recupere le nombre de colonne et le nombre de ligne de H

    % TODO :: check input confomity 

    number_of_Vnodes = c_cols;
    number_of_Cnodes = c_rows;

    iteration_c = c;

    % main loop 
    for iteration = 1:MAX_ITER
        % initlize messages and Responses
        Messages = -1 * ones(number_of_Cnodes,number_of_Vnodes);
        Responses = -1 * ones(number_of_Cnodes,number_of_Vnodes);

        %First step : each node send the bit their received
        %Craft message to send from c_i to f_j
        for ligne = 1:H_rows
            for colonne = 1:H_cols
                if H(ligne, colonne) == 1
                    Messages(ligne, colonne) = iteration_c(colonne);
                end
            end
        end

        %Second step : each check node calculate and respond
        % Response block 
        for ligne = 1:number_of_Vnodes
            for colonne = 1:number_of_Cnodes
                if Messages(ligne, colonne) ~= -1
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
        
        %check if algorithm terminates
        is_vector_even = zeros(number_of_Cnodes, 1);
        for ligne = 1:number_of_Vnodes
            parity = 0;
            for colonne = 1:number_of_Cnodes
                if H(ligne, colonne) ~= 0
                    parity = parity + c(colonne);
                end
            end
            is_vector_even(ligne) = mod(parity, 2);
        end
        if isequal(Messages, Responses)
            %Algorithm ends
            c_cor = iteration_c;
            return
        end

        %Thid step : use additional information
        %Majority vote
        majority_vote = ones(number_of_Vnodes,number_of_Cnodes);
        majority_index = 1;
        for colonne = 1:number_of_Vnodes
            for c_node_index = 1:number_of_Vnodes
                if Responses(c_node_index, colonne) ~= -1
                    majority_vote(colonne, majority_index) = responses(c_node_index, colonne);
                    majority_index = majority_index + 1;
                end
            end
        end

        for ligne = 1:number_of_Vnodes
            [most_frequent, frequency] = mode(majority_vote(ligne, :));
            if (mod(number_of_Cnodes+1, 2)) == 0 && (frequency == (number_of_Cnodes+1/2))
                iteration_c(ligne, 1) = randi([0, 1], [1, 1]);
            else
                iteration_c(ligne, 1) = most_frequent;
            end
        end

        is_vector_even = zeros(number_of_Cnodes, 1);
        for ligne = 1:number_of_Vnodes
            parity = 0;
            for colonne = 1:number_of_Cnodes
                if H(ligne, colonne) ~= 0
                    parity = parity + c(colonne);
                end
            end
            is_vector_even(ligne) = mod(parity, 2);
        end
        if sum(is_vector_even) == 0
            c_cor = iteration_c;
            return
        end
    end
    c_cor = iteration_c;
end
