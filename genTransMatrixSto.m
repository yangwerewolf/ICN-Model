%% genenrate storage transition matrix for Conventional ICDTN
function [trans, N, VStep, MStep, req_n, cont_n] = genTransMatrixSto(s, a, b, c, lambda)
    %s: total # of nodes
    %a: # of consumer
    %b: # of r_i-1
    %c: # of c_i
    
    b = a+b;
    %d = s -b-c;
    e = s*(s-1)/2;
    %tm = zeros(s-1);
    trans = zeros( e+(s-1) );
    indexsum = cumsum(0:(s-2));
    x = 0;
    y = 0;
    req_n = zeros(e+(s-1) ,1);
    cont_n = zeros(e+(s-1) ,1);

    for i=1:(s-1)  %row
        %for j = 1:(s-1)
        for j = 1:i  %column

            b = i-j+1;
            c = j;
            d = s -b-c;
            
            x = indexsum(i)+j;
            %self
            y = x; 
            trans(x,y) = 1-(b*c+b*d)/e;

            req_n(x) = b;
            cont_n(x) = c-1;

            if i ~= (s-1) 
                %b+1
                y = indexsum(i+1)+j;
                trans(x,y) = b*d/e;
            end

            if i ~= j
                %b-1
                y = x+1;
            else 
                %absorb state
                y = e+i; 
            end 
            trans(x,y) = b*c/e;
           

        end
    end
    
    cont_n(e+1:(e+(s-1)),1) = (2:s)-1; 
    trans(e+1:(e+(s-1)),e+1:(e+(s-1))) = eye(s-1);  %absorbing state self transition

    % calulation of fundamental matrix and E(step) and V(step)
    N = (eye(e)-trans(1:(e),1:(e)))^-1;
    MStep = N*ones(e,1);
    VStep = (2*N-eye(e))*MStep-MStep.^2;
end