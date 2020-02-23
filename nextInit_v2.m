function [ preInit, conInit, state01 ] = nextInit_v2(s, preTrans, preFin, ...
    preCont, transitPos, absorbPos, conTrans, conFin, conCont, indexsum, preState01)

    function [cont] = tryNext(x, temp, y, transitPos, absorbPos )
        
        cont = twoContentTrPos(x, temp, y, transitPos, absorbPos );
               
    end

%conTrPos
%     disp(sum(preFin)+sum(conFin)+sum(preState01));
    conInit = zeros(size(conTrans, 1),1);%should be a full size array
    preInit = zeros(size(preTrans, 1),1);
    preCont = preCont';
    state01 = 0;
    %pre part
    for i = 1:size(preTrans, 1)
        
        %consumer might be one of the nodes with contents
        %absorb case
        preI = tryNext(0, preCont(i,2)-1, 1, transitPos, absorbPos );
        conI = conTrPos(0, preCont(i,2), s, indexsum);
        temp = ((preCont(i,2)-1) / (s-1) );
        %(cont_n(i,2)-1) / (s-1) is c/(s-1)
        if (preI ~= -1) % >= 021
            preInit(preI) = preInit(preI) + preFin(i)*temp;
            preFin(i) = preFin(i)*(1-temp);
        elseif (conI ~= -1) % 011
            conInit(conI) = conInit(conI) +  preFin(i)*temp;
            preFin(i) = preFin(i)*(1-temp);
        else %01
            preState01 = preState01 +  preFin(i)*temp;
            preFin(i) = preFin(i)*(1-temp);
        end
        
        %rest
        preI = tryNext(1, preCont(i,2)-1, 1, transitPos, absorbPos );
        conI = conTrPos(1, preCont(i,2), s, indexsum);
        if preI ~= -1 %>= 111
            preInit(preI) = preInit(preI) + preFin(i);
        else %101 cannot be handled
            conInit(conI) = conInit(conI) + preFin(i);
        end
    end

    %con part
    conI = conTrPos(1, 1, s, indexsum);
    conInit(conI) = conInit(conI) + preState01;
    
    for i = 1:size(conTrans, 1)
%         consumer might be one of the nodes with contents
%         absorb case, consumer get c_i+1, no req_i+1
        conI = conTrPos(0, conCont(i), s, indexsum);
        temp = ((conCont(i)-1) / (s-1) );
%         (cont_n(i,2)-1) / (s-1) is c/(s-1)
        if conI ~= -1 % >= 02
            state01 = state01 + conFin(i)*temp;
            conFin(i) = conFin(i)*(1-temp);
        end

        %rest 
        conI = conTrPos(1, 1, s, indexsum);
        preI = tryNext(1, conCont(i)-1, 1, transitPos, absorbPos );        
        if preI ~= -1
            preInit(preI) = preInit(preI) + conFin(i);
        else %101 cannot be handled
            conInit(conI) = conInit(conI) + conFin(i);
        end
        
    end
%     disp(sum(preInit)+sum(conInit)+ state01);

end

