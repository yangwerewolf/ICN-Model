function [ delayInit ] = combState(s, preTrans, preFin, ...
    preCont, conFin, indexsum, state01, dTrans)

%     cont = twoContentTrPos(x, temp, y, transitPos, absorbPos );

    disp(sum(preFin)+sum(conFin)+sum(state01));
    si = size(dTrans,1);
    delayInit = zeros(1,si);
    %should be a full size array
    preCont = preCont';
    
    %pre part
    for i = 1:size(preTrans, 1)
        
        conI = conTrPos(0, preCont(i,2)+preCont(i,1), s, indexsum);
        conFin(conI) = conFin(conI) + preFin(i);
        
    end
    conFin(1) = conFin(1) + state01;
    delayInit = [conFin(1, 1:(si-1)), sum(conFin(1, si:size(conFin,2)))];
end

