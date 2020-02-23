%generate delay pdf with trans matrix
%test size is number of encounters
%use matix ini instead of int tar
%collect average content number vs time

function [t, binVal, fin ] = delayPDFsto( trans, ini, test_size, cont_n, lambda,...
    transitPos, absorbPos)
    binVal = zeros(1,test_size-1);
    
    p = ini*trans;
%     disp (sum(p));
%     figure; hold on;
%     plot(p);
    for binNum = 1 : (test_size-1)
        
        binVal(binNum) = p*cont_n;
        
        p=p*trans;
%         plot(p);
    end 
    
    t = (1:(test_size-1))*lambda;
    
    fin = p;

end