% generate delay pdf with trans matrix
% delayPDF_v3 CDF version

function [ggpdf, binVal ] = delayCDF_v3( trans, tar, test_size, e, lambda )
    binVal = zeros(1,test_size-1);
    p = trans;
    gpdf = [];
    %tar = 1; %intial state

    %while p(tar,e+1) <= 0.999
     for binNum = 1 : (test_size-1)
        temp = tar*p;
        if binNum > 1
            binVal(binNum) = temp(e+1) - sum(binVal);
        else
            binVal(binNum) = temp(e+1);
        end
        p=p*trans;
    end 

    for i = 1:binNum
        gpdf = [gpdf; gamcdf((1:test_size-1)*lambda,i,lambda)];
    %     gpdf = gampdf(1:1000,h.BinEdges(i)+h.BinWidth/2,29.3527);
    %     plot(1:1000,gpdf);
    end
    ggpdf = binVal*gpdf;

    %     figure;
%     bar(binVal);
%     gpdf = [];
%     figure;
%     hold on;
%     plot(0:60:6000,ggpdf); 

end