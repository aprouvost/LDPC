% c est un vecteur colonne binaire de taille [N,1];
% H est une matrice de taille [M,N] constitu�e de true et false;
% p est un vecteur colonne de taille [N,1] tel que p(i) est la probabilit� que c(i)==1;
% MAX_ITER est un entier strictement positif sp�cifiant le nombre maximal d�it�rations que peut effectuer le
%d�codeur.


% ---- Return
% c_cor le vecteur colonne binaire de taille [N,1] issu du d�codage.



function c_cor = soft_decoder(c, H, p, MAX_ITER) 

    %---- 
    % VERIFICATION DES CONDITIONS pour appliquer un soft decoder 
    % ----
    
    % TO DO parity check 
    % Check des dims de H et que ce soit bien une matrice binaire avec ne
    % num de 1 inf aux nums de 0 je sais pas si c'est obligatoire j'ai pas
    % compris cette partie du cours
    
    
    [c_rows, c_cols] = size(c);
    [H_rows, H_cols] = size(H);
    iterations = c;
    
     % verifier que la somme soit <= 1 avant l'attribution des valeurs 
     % (on travaille sur des probas, p(i) est la probabilit� que c(i)==1 ) 
     
    amount_of_v_nodes = c_cols;
    amount_of_v_nodes = c_rows;
    
    %---- 
    % INITIALISATION
    % ----
    
    %mat_tempo_in contient la valeur fournit aux noeuds pour une it�ration
    %d'op�rations logiques 
    %mat_tempo_out contient les valeurs au fure et � mesure des it�rations
    %modifi� par les op�rations logiques des noeufs
    mat_tempo_in =  -1 * ones(amount_of_c_nodes, amount_of_v_nodes);
    mat_tempo_out = -1 * ones(amount_of_c_nodes, amount_of_v_nodes);
    
    %init de mat_tempo_in avant la premi�re it�ration 
    for row = 1:H_rows
        for col = 1:H_cols
            if H(row, col) == 1
                mat_tempo_in(row, col) = p(col);
            end
        end
    end
    
    
    % ----
    % ITERATION et calcul des op�rations logiques (r�ponses des noeuds) 
    % ----
    
for iter = 1:MAX_ITER                      
        % Les c-nodes vont calculer les reponses
        for row = 1:amount_of_c_nodes
            for col = 1:amount_of_v_nodes
                
             % do some good stuff
             
            end
        end
end 

    % ----
    % MISE A JOUR des valeurs suite aux op�rations logiques  
    % ----
    
    