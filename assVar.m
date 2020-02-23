function [ transSto, transitSize, transitPos, absorbPos, req_n, cont_n ] = assVar( s, x, y, z  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    transitSize = 0;
    transitPos = 0;
    
    rowN = (s-x-y-z + 1); %# of rows  of transition diagram
    for i = 1 : rowN
        transitSize = transitSize + i*(s-1-i); 
        transitPos = [transitPos transitSize]; %start position in transition matrix of each row, end with size of N matrix
    end

    absorbPos =[0 cumsum(2 : (2+rowN-1))]; %start pos of each absorb part, end with size of absorb matrix
    tSize = absorbPos(size(absorbPos,2)) + transitPos(rowN+1);
    transSto = zeros( tSize);
    req_n = zeros(1, tSize);
    cont_n = zeros(2, tSize);

end

