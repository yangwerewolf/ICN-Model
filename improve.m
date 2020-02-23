function [ estm_curve, estm_gain ] = improve( test_size, estm_state_n, estm_init, trans, lambda, e)
%% analytical original preformance
   
    estm_curve = zeros(1,test_size);
    estm_gain = zeros(1,test_size);
    %get rid of the absorbing state
    for k = 1:size(estm_state_n,2)
%         binVal = zeros(1,test_size-1);
%         p = trans;
%         tar = k; %intial state
% 
%        for binNum = 1 : (test_size-1)
% 
%             if binNum > 1
%                 binVal(binNum) = p(tar,e+1) - sum(binVal);
%             else
%                 binVal(binNum) = p(tar,e+1);
%             end
%             p=p*trans;
%         end 
% 
%         gpdf = [];
% 
%         for i = 1:binNum
%             gpdf = [gpdf; gampdf(0:60:6000,i,lambda)];
%     %     gpdf = gampdf(1:1000,h.BinEdges(i)+h.BinWidth/2,29.3527);
%     %     plot(1:1000,gpdf);
%         end
%         ggpdf = binVal*gpdf;
        [ggpdf, ~ ] = delayPDF_v2( trans, k, test_size, e, lambda );
        ggpdf = ggpdf/(sum(ggpdf)*lambda);
        estm_curve = estm_curve + ggpdf*estm_state_n(k);
        estm_gain = estm_gain + ggpdf*estm_init(k);
%         figure;
%         plot(1:test_size, estm_curve,1:test_size, estm_gain)
    end
end

