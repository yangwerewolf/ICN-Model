%generate indigo encounter prob matrix p_s^c = indigo_p
%indigo_enc = enc_sample_mean'+enc_sample_mean;
indigo_enc = 1./enc_sample_mean;
indigo_enc(indigo_enc == inf) = 0;
indigo_p = indigo_enc./sum(sum(indigo_enc));
indigo_p(indigo_p == inf) = 0;

maxRuns = 1000000; %# of total trials 
maxTrial = 1000; %# of total encounters
m = 1; %# of producers
n = 6; %# of consumers 
d_all = zeros(m,n); %D is a n by m matrix represent the bool which repesent whether 
f = n; %final states/ total number of nodes without content

startState = 0;
stopState = f;
t_upper = 0;

while startState < stopState
    %t_run = zeros(m, n);
    t_run = [];
    nextState = startState + 1;
    for run = 1: maxRuns
        p = startState;
        if (p>0)
            ran_select = rand(m, n);
            ran_sort = sort(ran_select);
            d_all = ran_select <= ran_sort(p);
        else
            d_all = zeros(m,n);
        end
        
        maxTime = getMaxTimeStatic(startState, nextState, d_all, indigo_p, maxRuns);
        %if (t_run < maxTime)
        t_run = [t_run maxTime];
        %end
        %t_run = t_run(t_run >= maxTime) + maxTime(maxTimeMapper > t_run);
        
        if (maxTime == 0)
            nextState = nextState + 1;
        else 
            startState = nextState;
            nextState = nextState + 1;
        end
        
        if (nextState > stopState)
            break;
        end
    end
    %disp(t_run);
    t_upper = t_upper + max(t_run);
end

disp(t_upper);
