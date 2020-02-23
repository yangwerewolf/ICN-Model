function [ estm_state_n ] = initDist_v3 ( stepN, Lambda, lambda, init_state, s, a, b, c )
%% probability of start in each state after transition of stepN steps

    d = s -a-b-c;
    e = s*(s-1)/2;
    trans = zeros(e+1);
    indexsum = cumsum(0:(s-2));
    x = 0;
    y = 0;

    for i=1:(s-1)
        %for j = 1:(s-1)
        %for j = 1:i
        j = 1;
        
        b = i-j;
        c = j;
        d = s -a-b-c;

        x = indexsum(i)+j;
        %self
        y = x; 
        trans(x,y) = (e-(a+b)*(c+d))/e;

        if i ~= (s-1)
            %b+1
            y = indexsum(i+1)+j;
            trans(x,y) = (a+b)*d/e;
        else
            y = x; 
            trans(x,y) = 1;
        end
        %end
    end
    
    rowSum = sum(trans,2);
    rowFlag = rowSum>0;
    rowSum = 1./rowSum;
    rowSum(~rowFlag) = 0;
    trans = trans.*rowSum; 
    
    %stepN: encounter 
    %Lambda: int rate
    %init_state: start from 
    enc_t = (1:stepN)*lambda; %encounter time points
    sent_p = expcdf(enc_t,Lambda); 
    sent_p = sent_p-[0,sent_p(1:stepN-1)]; %req sent probability
    %plot(enc_t, sent_p);
    
    % mean_state = eye(e); % mean number of visited state
    trans_n = eye(1+e);        % Q^n
    estm_state_n = zeros(1,1+e); % start from state 1, after 10 transition with weight, the possibility of the network in each state 
   
    for i = 1:stepN
        trans_n = trans_n*trans;%(1:e,1:e) ;
        estm_state_n = estm_state_n + sent_p(i)*trans_n(init_state,:) ;
    end 
    % display(estm_state_n);
    estm_state_n = estm_state_n/(1-estm_state_n(1+e));
    estm_state_n = estm_state_n(1:e);
    % display(estm_state_n);
end

