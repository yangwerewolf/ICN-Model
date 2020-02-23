%s: total # of nodes
%x: # of r_i
%y: # of c_{i+1}
%z: # of c_i
%trans: transition matrix
%transitSize: # of transition states
%transitPos: start position of transition states
%absorbPos: start position of absorb states
%twoContent: generate transition matrix 

function [trans, req_n, cont_n] = twoContent(s,x,y,z, trans, transitSize, transitPos, absorbPos, req_n, cont_n)
    
    sumP = 0;% sum of probability except ST
    row = twoContentTrPos(x,y,z, transitPos, absorbPos);
    %(2,1,1)
    cont_n(:,row) = [y; z];
    req_n(row) = x;
    
    if x ~= 0
        %req ++;
        if  (s  - sum([x,y,z]) > 0)    
            col = twoContentTrPos(x+1,y,z, transitPos, absorbPos);
            trans(row,col) = x*(s  - sum([x,y,z]))*2/(s*s-s);
            sumP = sumP + trans(row,col);
            [trans, req_n, cont_n] = twoContent(s, x+1, y, z, trans, transitSize, transitPos, absorbPos, req_n, cont_n); 
            %(3,1,1)
        end

        %req --; content ++;
    
        %con_i
        col = twoContentTrPos(x-1,y,z+1, transitPos, absorbPos);
        trans(row,col) = x*z*2/(s*s-s);
        sumP = sumP + trans(row,col);
        [trans, req_n, cont_n] = twoContent(s, x-1, y, z+1, trans, transitSize, transitPos, absorbPos, req_n, cont_n);
        %(1,1,2)
        
        %con_{i+1}
        col = twoContentTrPos(x-1,y+1,z, transitPos, absorbPos);
        trans(row,col) = x*y*2/(s*s-s);
        sumP = sumP + trans(row,col);
        [trans, req_n, cont_n] = twoContent(s, x-1, y+1, z, trans, transitSize, transitPos, absorbPos, req_n, cont_n);
        %(1,2,1)
        
        %self
        trans(row,row) = 1 - sumP;
    else
        %ST probability 
        trans(row,row) = 1 ;
    end

end