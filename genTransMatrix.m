%% genenrate transition matrix
function [trans, N, VStep, MStep, req_n, cont_n] = genTransMatrix(s, a, b, c, lambda)
    d = s -a-b-c;
    e = s*(s-1)/2;
    %tm = zeros(s-1);
    trans = zeros(e+1);
    indexsum = cumsum(0:(s-2));
    x = 0;
    y = 0;
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
            cont_n(x) = c-1;

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
    N = (eye(e)-trans(1:(e),1:(e)))^-1;
    MStep = N*ones(e,1);
    VStep = (2*N-eye(e))*MStep-MStep.^2;
end