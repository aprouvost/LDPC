% c est un vecteur colonne binaire de taille [N,1];
% H est une matrice de taille [M,N] constitu�e de true et false;
% p est un vecteur colonne de taille [N,1] tel que p(i) est la probabilit� que c(i)==1;
% MAX_ITER est un entier strictement positif sp�cifiant le nombre maximal d�it�rations que peut effectuer le
%d�codeur.


% ---- Return
% c_cor le vecteur colonne binaire de taille [N,1] issu du d�codage.



function c_cor = SOFT_DECODER_GROUPE2(c, H, p, MAX_ITER)

  c_cor =c;

  %----
  % VERIFICATION DES CONDITIONS pour appliquer un soft decoder
  % ----

  % TODO parity check
  % Check des dims de H et que ce soit bien une matrice binaire avec ne
  % num de 1 inf aux nums de 0 je sais pas si c'est obligatoire j'ai pas
  % compris cette partie du cours


  [c_rows, c_cols] = size(c);
  [H_rows, H_cols] = size(H);
  iteration = c;


   %verifier que H est bien une matrice binaire
   for row = 1:H_rows
   for col = 1:H_cols
          if H(row,col) >  1 || H(row,col) <  0
            disp("ERREUR matrice H invalide car non binaire");
            return
          end
        end
    end

    if(c_cols>1)
      dim = c_cols;
    else
      dim = c_rows;
    end

   %verifier que H soit de taille cohérente avec c pour le décodage
   %attention au cas où c doit être transposée
  if dim  ~= H_cols
    disp("ERREUR mauvaise dimension pour c");
    return
  end

  %verifie que c soit de la bonne forme ( taille et éléments binaires )
  if (c_cols == 1 && c_rows == 1)
    disp("ERREUR c doit être un vecteur");
  end

  % verifier que c soit un vecteur binaire)
  cont = 0;
  for i=1: c_rows
    for j=1 : c_cols
      if c(i,j) >  1 || c(i,j) < 0
        disp("ERREUR c doit être un vecteur de probabilité");
      end
    end
  end

  %gère le cas où c doit être transposée, en verifiant que c est un vecteur
  %c est transposée si c_cols > 1

  if isvector(c) && (c_cols > 1)
    amount_of_v_nodes = c_cols;
  else
    amount_of_v_nodes = c_rows;
  end



    %----
    % INITIALISATION
    % ----

    %mat_tempo_in contient la valeur fournit aux noeuds pour une it�ration
    %d'op�rations de probabilité
    %mat_tempo_out contient les valeurs au fure et � mesure des it�rations
    %modifi� par les op�rations logiques des noeufs

    mat_tempo_in =  -1 * ones(H_rows, amount_of_v_nodes);
    mat_tempo_out = -1 * ones(H_rows, amount_of_v_nodes);


    % step 1
    %init de mat_tempo_in avant la premi�re it�ration
    for row = 1:H_rows
        for col = 1:H_cols
            if H(row, col) == 1
              % pour chaque noeud de la matrice connecté, on a un 1 dans H
              % et une proba dans dans mat_tempo_in
                mat_tempo_in(row, col) = p(col);
            end
        end
    end


    % ----
    % ITERATION et calcul des op�rations logiques (r�ponses des noeuds)
    % ----

  for iter = 1:MAX_ITER
    % step 2 calcul des messages réponses
    % Les c-nodes vont calculer les reponses
    for row = 1:H_rows
      for col = 1:amount_of_v_nodes
        rij = ones(1,2);
        num = abs(prod(1-2*mat_tempo_in,2));
        rij(1) = 0.5 + (0.5*(num(row)/(1-2*mat_tempo_in(row,col))));
        rij(2) = 1- rij(1);
        mat_tempo_out(row, col) = rij(1);
      end
    end

    %setp 3 les noeuds variables update leurs messages de réponse
    for col=1 : amount_of_v_nodes

      num = abs(prod(mat_tempo_in,1));
      num_2= prod(nonzeros(1-abs(mat_tempo_in)),1);

      tab=mat_tempo_in(:,col);
      tab_tempo=prod(abs(mat_tempo_in),1);
      tab_tempo_opposees=prod(nonzeros(1-abs(tab)),1);

      prod_col(1) = tab_tempo(col);
      prod_col(2) = tab_tempo_opposees;
      qinit = zeros(1,2);
      qinit(1) = (1-p(col))*prod_col(1);
      qinit(2) = p(col)*prod_col(2);

      Ki = 1/(qinit(1)+ qinit(2));
      qi = ones(1,2);
      qi(1) = Ki*qinit(1);
      qi(2) = Ki*qinit(2);

      %comparaison des Qi(1) et Qi(0)
      if qi(1) > qi(2)
        iteration(col)= 1;
      else
        iteration(col)= 0;
      end

      % ----
      % MISE A JOUR des valeurs suite aux op�rations
      % ----
      % mise à jour des messages des v_nodes de la matrice mat_tempo_out


      for row = 1 : H_rows
        % ne met pas à jour les cases n ayant pas eu d update (celles étant encore à -1)
        if(mat_tempo_out(row, col) ~= -1)
          qnum = zeros(1,2);
          qij = zeros(1,2);

          %recalcul du K pour chaque elem avant la mise à jour
          qnum(1)= qinit(1)/mat_tempo_in(row, col);
          qnum(2)= qinit(2)/ (1 - mat_tempo_in(row, col));
          kij = 1 / (qnum(1) + qnum(2));

          %maj des valeurs
          qij(1) = kij * qnum(1);
          qij(2) = kij * qnum(2);
          mat_tempo_out(row,col) = qij(1);
        end
      end

      % si le mot code estimé passe le test de parité
      % on s arrête
      % sinon, on reprend au STEP 2

      parite = parity_check(iteration, H ,H_rows, amount_of_v_nodes);
      if sum(parite) == 0
        %fprintf("Done\n NUM ITERATIONS : %i ", iteration);
        c_cor = iteration;
        return
      end
  end
 end
  %disp("Max iteration without success\n");
  c_cor = iteration;
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
