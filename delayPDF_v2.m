%generate delay pdf with trans matrix
%test size is number of time length. range of pdf is (1:test_size)*lambda
%number of encounters is fixed 200

function [ggpdf, binVal ] = delayPDF_v2( trans, tar, test_size, e, lambda )
    binVal = zeros(1,200-1);
    p = trans;
    gpdf = [];
    %tar = 1; %intial state

    %while p(tar,e+1) <= 0.999
     for binNum = 1 : 199
        if binNum > 1
            binVal(binNum) = p(tar,e+1) - sum(binVal);
        else
            binVal(binNum) = p(tar,e+1);
        end
        p=p*trans;
    end 

    for i = 1:binNum
        gpdf = [gpdf; gampdf((1:test_size)*lambda, i, lambda)];
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