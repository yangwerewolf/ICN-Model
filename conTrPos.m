    function [index] = conTrPos(x, y, s, indexsum)
        if x+y < 2
            index = -1;
            return;
        end
        
        e = s*(s-1)/2;
        
        if x > 0
            index = indexsum(x+y-1)+y;
        else
            index = e+y-1;
        end
    end