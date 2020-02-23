    
lambda_r = lambda;
i = 0;
alpha = 4;
stdc = 0;
stdp = 0;

for i = 1:50
    ini = zeros(1,size(trans,1));ini(1) = 1;
    [ggpdf, binVal ] = delayCDF_v3( trans, ini, test_size, e, lambda_r );
    gggpdf = [];

    for j = ceil((ccdf.BinEdges+ccdf.BinWidth/2) /lambda_r)
        if (j > size(ggpdf,2))
            break;
        end
        gggpdf = [gggpdf ggpdf(j)];
            
    end
    
    array_size = min([size(ccdf.Values, 2) size(gggpdf, 2)]);
        
    stdc = mean( (gggpdf(1:array_size) - ccdf.Values(1:array_size) ).^2 );
%     stdc
%     stdp
    if stdc >= stdp
        alpha = alpha*-1;
    end
    lambda_r = lambda_r + alpha;
    stdp = stdc;
    
%     gggpdf
%     lambda_r
end