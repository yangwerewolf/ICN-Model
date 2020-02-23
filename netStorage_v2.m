function [ conv_sto, estm_sto ] = netStorage_v2( test_size, estm_state_n, estm_init, trans, e, cont_n )

%     test_size = 200;
conv_sto = zeros(1,test_size);
estm_sto = zeros(1,test_size);

% for k = 1:(size(estm_state_n,2)-1)
%         binVal = zeros(1,test_size-1);
conv_p = [estm_state_n (1-sum(estm_state_n))];
estm_p = [estm_init (1-sum(estm_init))];

es = 1;
cs = 1;


cpsum = cumsum(conv_p);
epsum = cumsum(estm_p);

for i = 1:50000

    p = rand;
    
    for j = 1:e+1
       if p<cpsum(j)
           cs = j;
           break;
       end
    end
    
    for j = 1:e+1
       if p<epsum(j)
           es = j;
           break;
       end
    end
    
    ci = 0;
    last = 0;
    while cs < e+1
        %       disp(s);
        ci = ci +1;
        conv_sto(ci)=conv_sto(ci)+cont_n(cs);
        last = cont_n(cs);
        
        p = rand;
        psum = 0;
        for j = cs:e+1
            psum = psum+trans(cs,j);
            if p<psum
                cs = j;
                break;
            end 
        end       
    end
    
    if (ci ~= 0)
        ci = ci +1;
        conv_sto(ci:test_size)=conv_sto(ci:test_size)+last;
    end

    
    ei = 0;
    last = 0;
    while es < e+1
        %       disp(s);
        ei = ei +1;
        estm_sto(ei)=estm_sto(ei)+cont_n(es);
        last = cont_n(es);
        
        p = rand;
        psum = 0;
        for j = es:e+1
            psum = psum+trans(es,j);
            if p<psum
                es = j;
                break;
            end 
        end
        
    end
    if (ei ~=0 )
        ei = ei +1;
        estm_sto(ei:test_size)=estm_sto(ei:test_size)+last;
    end

end 

estm_sto = estm_sto/50000;
conv_sto = conv_sto/50000;

end

