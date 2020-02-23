%% genenrate transition matrix
s = 10; %5, 10, 20, 40
a = 1;
b = 0;
c = 1;
d = s -a-b-c;
e = s*(s-1)/2;
%tm = zeros(s-1);
trans = zeros(e+1);
indexsum = cumsum(0:(s-2));
x = 0;
y = 0;
% sampleNum = 50000;
lambda = 2453.7/e; %encounter rate
% lambda= 54.5271;
req_n = zeros(e+1,1);
cont_n = zeros(e+1,1);

for i=1:(s-1)
    %for j = 1:(s-1)
    for j = 1:i
        
        b = i-j;
        c = j;
        d = s -a-b-c;
                    
        x = indexsum(i)+j;
        %self
        y = x; 
        trans(x,y) = (e-(a+b)*(c+d))/e;
        req_n(x) = b;
        cont_n(x) = c;
        
        if i ~= (s-1)
            %b+1
            y = indexsum(i+1)+j;
            trans(x,y) = (a+b)*d/e;
        end

        if i ~= j
            %b-1
            y = indexsum(i)+j+1;
            trans(x,y) = b*c/e;
        end 
        %absorb state
        y = e+1; 
        trans(x,y) = a*c/e;

    end
end

trans(e+1,e+1) = 1;  %absorbing state self transition

% calulation of fundamental matrix and E(step) and V(step)
N = (eye(e)-trans(1:e,1:e))^-1;
MStep = N*ones(e,1);
VStep = (2*N-eye(e))*MStep-MStep.^2;

%% probability of start in each state after transition of stepN steps

stepN = 20; %encounter 
Lambda = 1000; %int rate
init_state = 1;

[ estm_state_n ] = initDist_v2 ( stepN, Lambda, lambda, init_state, s, a, b, c );

%% estimated gain

estm_init = [];
for i=(s-1):-1:2
    %for j = 1:(s-1)
    for j = i:-1:2
        b = i-j;
        c = j;
        
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

% display(sum(estm_state_n));
% display(sum(estm_init));

%% analytical original preformance

test_size = 101;
estm_curve = zeros(1,test_size);
estm_gain = zeros(1,test_size);
%get rid of the absorbing state


for k = 1:(size(estm_state_n,2)-1)
    binVal = zeros(1,test_size-1);
    p = trans;
    tar = k; %intial state
    
   for binNum = 1 : (test_size-1)
    
        if binNum > 1
            binVal(binNum) = p(tar,e+1) - sum(binVal);
        else
            binVal(binNum) = p(tar,e+1);
        end
        p=p*trans;
    end 
  
    gpdf = [];
    
    for i = 1:binNum
        gpdf = [gpdf; gampdf(0:60:6000,i,lambda)];
%     gpdf = gampdf(1:1000,h.BinEdges(i)+h.BinWidth/2,29.3527);
%     plot(1:1000,gpdf);
    end
    ggpdf = binVal*gpdf;
    
    estm_curve = estm_curve + ggpdf*estm_state_n(k);
    estm_gain = estm_gain + ggpdf*estm_init(k);
end

figure;
hold on;
plot(0:60:6000,estm_curve);
hold on;
plot(0:60:6000,estm_gain);
%display(enc_t);
%%

test_size = 200;
conv_sto = zeros(1,test_size);
estm_sto = zeros(1,test_size);

% for k = 1:(size(estm_state_n,2)-1)
    binVal = zeros(1,test_size-1);
    conv_p = [estm_state_n (1-sum(estm_state_n))];
    estm_p = [estm_init (1-sum(estm_init))];
%     tar = k; %intial state
    
   for binNum = 1 : test_size
    
%         if binNum > 1
%             binVal(binNum) = p(tar,e+1) - sum(binVal);
%         else
%             binVal(binNum) = p(tar,e+1);
%         end
        if (1-estm_p(e+1) <= 1e-15)
            break;
        end
        conv_sto(binNum) = conv_p*cont_n/(1-conv_p(e+1));
        estm_sto(binNum) = estm_p*cont_n/(1-estm_p(e+1));
        conv_p = conv_p*trans;
        estm_p = estm_p*trans;
   end 

figure;
plot(conv_sto);
hold on;
plot(estm_sto);