function [ conv_sto, estm_sto ] = netStorage( test_size, estm_state_n, estm_init, trans, e, cont_n )

%     test_size = 200;
    conv_sto = zeros(1,test_size);
    estm_sto = zeros(1,test_size);


        conv_p = [estm_state_n (1-sum(estm_state_n))];
        estm_p = [estm_init (1-sum(estm_init))];

       for binNum = 1 : test_size

            if (1-estm_p(e+1) <= 1*10^-6)
%                 conv_sto(binNum) = conv_sto(binNum-1);
%                 estm_sto(binNum) = estm_sto(binNum-1);
                conv_sto(binNum) = 0;
                estm_sto(binNum) = 0;
            else
%                 conv_sto(binNum) = conv_p*cont_n/(1-conv_p(e+1));
%                 estm_sto(binNum) = estm_p*cont_n/(1-estm_p(e+1));
                conv_sto(binNum) = conv_p*cont_n;
                estm_sto(binNum) = estm_p*cont_n;
                conv_p = conv_p*trans;
                estm_p = estm_p*trans;
            end
            
            
       end 


end

