%s: total # of nodes
%x: # of r_i
%y: # of c_{i+1}
%z: # of c_i
%transitPos: start position of transition states
%absorbPos: start position of absorb states
%twoContentTrPos: convert state to matrix position

function [pos] = twoContentTrPos(x,y,z, transitPos, absorbPos )
    %transitPos
    %absorbPos
%     if (x <0 || y < 1 || z < 1 )
    if (x+y+z <3 )
        pos = -1;
        return;
    end
    
    if x ~= 0
        pos = transitPos(y+z-1) + (y+z-1)*(x-1) + z;
    else
        pos = transitPos(size(transitPos,2)) + absorbPos(y+z-2) + z;
    end
end