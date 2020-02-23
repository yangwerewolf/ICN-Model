function [ estm_state_n , p] = initDist_v2 (thr, Lambda, lambda, init_state, transSto, e, s)
%% probability of start in each state after transition of stepN steps

    
    %stepN: encounter 
    %Lambda: int rate
    %init_state: start from
%% use threshold to control step number
%     stepN = 1;
%     while true
%         if expcdf(stepN*lambda,Lambda) > thr
%             break;
%         end
%         stepN = stepN+1;
%     end
%     p=stepN;

%%    use absorb matrix and content increase matrix to obtain initial 
%     indexsum = cumsum(0:(s-2));
%     sMat = zeros(1,size(transSto,1));
%     aMat = zeros(1,size(transSto,1));
% 
%     for i=1:(s-1)  %row
%         for j = 1:i  %column
%             if j == 1 % no content increase
%                 sMat(indexsum(i)+j) = 1;
%             end
%             if j == 2 % 1 content increase
%                 aMat(indexsum(i)+j) = 1/i;
%             end
%         end
%     end
  
%%
    a=1;b=0;c=1;
    transNew = zeros(s+1);
    for x=1:(s-1)
        b = x-1;
        d = s - a - b - c;
        
        y = x; %self t
        transNew(x,y) = 1 - (a+b)*(c+d)/e;
        
        y = x+1; %RI
        transNew(x,y) = (a+b)*d/e;
        
        y = s; %delivery
        transNew(x,y) = a*c/e;
        
        y = s+1; %CI
        transNew(x,y) = b*c/e;
    end
    transNew(s,s) = 1;
    transNew(s+1,s+1) = 1;
    
    stepN = ceil(Lambda/lambda)+1;
%     p = expcdf(stepN*lambda,Lambda);
    
    temp = init_state(1:s+1)*(transNew^stepN);
    estm_state_n = zeros(1,size(transSto,1));
    estm_state_n(1,3) = temp(1,s+1);
    estm_state_n(1,e+1) = temp(1,s);
    estm_state_n(1,1) = 1 - sum(estm_state_n);
    
    
%     estm_state_n(1,1) = temp*sMat';
%     estm_state_n(1,e+1) = temp*aMat'+temp(1,e+1);
%     estm_state_n(1,3) = 1 - sum(estm_state_n);
    p = estm_state_n(1,1);
%     estm_state_n(1,1) = temp(1,1);
%     estm_state_n(1,e+1) = temp(1,e+1);
%     estm_state_n(1,3) = 1-sum(estm_state_n);
%     
end

