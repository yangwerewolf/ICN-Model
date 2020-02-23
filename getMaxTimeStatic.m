function [maxTime] = getMaxTimeStatic(startState, endState, d_all, p, maxTrial)
    maxTime = 0;
    t = [];
    for trial = 1:maxTrial
        tt = 0;
        while (true)
            %x = random('uniform', 0, 1);
            x = 0;
            tt = tt +1;
            if (x < 0.5)
                
                r = random('uniform', 0, 1);
                outer = false;
                for i = 1:size(p,1)
                    for j = i:size(p,1)
                        if p(i, j) >= r
                            if (i == 2)
                                d_all(j-1) = 1;
                            elseif (i == 1 && j == 2)
                                d_all(1) = 1;
                            end
                            
                            outer = true;
                            break ;
                        else
                            r = r - p(i, j);
                        end
                    end
                    
                    if (outer)
                        break;
                    end
                end
            %else
                %
            end
            
            d = sum(d_all);
            if d >= endState
                break;
            end
        end
        
        if (d == endState)
            t = [t tt];
        end
    end
    
    %if (maxTime < t)
        maxTime = max(t);
    %end
end 