function [ init, toCon ] = nextInit(s, trans, fin, cont_n, transitPos, absorbPos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%     function [cont] = tryNext(x, temp, y, transitPos, absorbPos )
%         while (true)
%             cont = twoContentTrPos(x, temp, y, transitPos, absorbPos );
%             if cont == -1
%                 temp = temp+1;
%                 cont = twoContentTrPos(x, temp, y, transitPos, absorbPos );
%             else
%                 break;
%             end
%         end
%     end

    function [cont] = tryNext(x, temp, y, transitPos, absorbPos )
        
        cont = twoContentTrPos(x, temp, y, transitPos, absorbPos );
               
    end
    toCon = [0 0];%should be a full size array
    init = zeros(size(trans, 1),1);
    cont_n = cont_n';
    for i = 1:size(trans, 1)
%         if (cont_n(i,2) < (s-1))
            %consumer might be one of the nodes with contents
            %absorb case
           
        cont_i = tryNext(0, cont_n(i,2)-1, 1, transitPos, absorbPos );

        %(cont_n(i,2)-1) / (s-1) is c/(s-1)
        if cont_i ~= -1
            init(cont_i) = init(cont_i) + fin(i)*((cont_n(i,2)-1) / (s-1) );
            fin(i) = fin(i)*(1-( (cont_n(i,2)-1) / (s-1) ));
        else % 011
            toCon(1) = toCon(1) +  fin(i)*((cont_n(i,2)-1) / (s-1) );
            fin(i) = fin(i)*(1-( (cont_n(i,2)-1) / (s-1) ));
        end
        %rest
        cont_i = tryNext(1, cont_n(i,2)-1, 1, transitPos, absorbPos );
            
%         else
            %001,011 cannot be handled
%             cont_i = tryNext(0, cont_n(i,2)-1, 1, transitPos, absorbPos );
%         end
        
        if cont_i ~= -1
            init(cont_i) = init(cont_i) + fin(i);
        else %101
            toCon(2) = toCon(2) +  fin(i);
        end
    end

end

