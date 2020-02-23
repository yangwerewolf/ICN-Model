function [ estm_init ] = PreInitDist( s, estm_state_n, indexsum )
    %% estimated gain
    estm_init = [];
    for i=(s-1):-1:2
        %for j = 1:(s-1)
        for j = i:-1:2
%             b = i-j;
%             c = j;

            x = indexsum(i)+j;
            y = indexsum(i-1) + j-1;
            if i == (s-1)
                estm_init(x) = estm_state_n(x) + estm_state_n(y);
            else
                estm_init(x) = estm_state_n(y);
            end
        end
    end
    estm_init(indexsum(s-1)+1) = estm_state_n(indexsum(s-1)+1);
end

