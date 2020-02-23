%% 
% storage part

% clear;
path = 'C:\Users\jzyan\Dropbox\PhDwork\opnet\data\feb2018\n7-AAP-cs4k-pit6k-cl3k-rr';
% pre = '1k';
file1 = '-con-time-name.txt';
file2 = '-con-time-num.txt';
file3 = '-recv-name-delay.txt';

s = 7; %total # of nodes
x = 1; %# of r_i
y = 1; %# of c_i
z = 1; %# of c_{i+1}
lambda = 2453.7*2/s/(s-1);
Lambda = 1500;
tempRatio = 1;

% AAP trans storage matrix initialization
[preTransSto, transitSize, transitPos, absorbPos, req_n, cont_n ] = assVar( s, x, y, z  );
[preTransSto, req_n, cont_n]= twoContent(s,x,y,z, preTransSto, transitSize, transitPos, absorbPos, req_n, cont_n);

% conventional trans storage matrix initialization
[conTransSto, N, VStep, MStep, conReq_n, conCont_n] = genTransMatrixSto(s, x, y, z, lambda);
conCont_n = conCont_n +1;
toCont = [2, 1];
indexsum = cumsum(0:(s-2));
testSize = ceil(Lambda/lambda);

% conventional initial dist initialization
conInit = zeros(1,size(conTransSto,1));
conInit(1) = 1;

% AAP initial dist initialization
preInit = zeros(1,size(preTransSto,1));
% init(twoContentTrPos(1,1,1, transitPos, absorbPos )) = 1;

state01 = 0;

for k = 1:5
    %simulation
    [~, conBinVal,   conFin]  = delayPDFsto(conTransSto,    conInit, testSize, conCont_n,  lambda);
    [~, binVal2,     preFin]  = delayPDFsto(preTransSto,    preInit, testSize, cont_n(2,:)', lambda);
    [t, binVal1 ]             = delayPDFsto(preTransSto,    preInit, testSize, cont_n(1,:)', lambda);

%     f = figure();
%     plot(preInit,'Displayname','init');
%     hold on;
%     plot(preFin,'Displayname', 'fin');
%     plot(state01,'Displayname', 'state01');
% 
%     plot(cont_n(2,:)/10, 'Displayname', 'b_i+1');
%     plot( (cont_n(2,:)+cont_n(1,:)) /10, 'Displayname', 'c_i');
%     legend('show');

    temp = preFin*cont_n(2,:)' + conFin*(conCont_n);
    [preInit, conInit, state01] = nextInit_v2(s, preTransSto, preFin, cont_n, transitPos, ...
        absorbPos, conTransSto, conFin, conCont_n, indexsum, state01);
    temp = temp - preInit'*(cont_n(2,:) + cont_n(2,:) )' - conFin*(conCont_n);
        
    preInit = preInit'; 
    conInit = conInit'; 
end

testSize = ceil( 6000/lambda);
[~, finConBinVal]  = delayPDFsto(conTransSto,   conInit, testSize, conCont_n,  lambda);
[~, finBinVal2]    = delayPDFsto(preTransSto,   preInit, testSize, cont_n(2,:)', lambda);
[fint, finBinVal1]= delayPDFsto(preTransSto,    preInit, testSize, cont_n(1,:)', lambda);

figure;
% plot(t, binVal1/(s-1), 'DisplayName', 'ci');
hold on; 
% plot(t, binVal2/(s-1), 'DisplayName', 'bi+1');
% plot(t, conBinVal/(s-1), 'DisplayName', 'con_i');

% hold off;

% figure;
% 
combindedBin = [(binVal2+conBinVal) (finBinVal1 + finBinVal2 + finConBinVal)];
plot([t fint+max(t)], ...
    (combindedBin-1)/(s-1),...
    'DisplayName', 'add');
% plot([t t+t(size(t,2))], [binVal2 binVal1]/(s-1), 'DisplayName', 'add');


% CON storage ratio 
conInit = zeros(1,size(conTransSto,1));conInit(1) = 1;
[t, conBinVal ] = delayPDFsto( conTransSto, conInit, testSize, conCont_n, lambda);
plot(t+Lambda,conBinVal/(s-1),'DisplayName', 'CON');
legend('show');

pre = '1.5k';
% [path, pre, file2]
rawdat = importdata([path, pre, file2]);

esto = rawdat.data;
rawdat = importdata([path, pre, file1]);
esto = [esto rawdat.data(:,2)];
% esto=[];
csto=[];
psto=[];
pref_f = [];
a=esto;
content_num_process;
econ = con_m/(s-1);

plot( ( (0:size(econ,1)-1)*20 ) ,econ, 'DisplayName', ['simulation' pre]);
legend('off');
legend('show');

a=csto;
content_num_process;
ccon = con_m/(s-1);

%con_m = con_n(:,1)/max(a(:,3))/(s-1);
hold on;
plot( ( (0:size(ccon,1)-1)*20 ) ,ccon, 'DisplayName', 'cs2k');
legend('show');
hold off;
% cost = econ - ccon;

% for i = 2:17
% ut(i)=gain(1)*(1-cost((i*100-180)/20) ) ;
% end
%%
a=psto;
pref_f = unique(pref_f);
content_num_processOCP;
econ = con_m/(s-1);
hold on;    
plot( ( (0:size(econ,1)-1)*20 ) ,econ, 'DisplayName', 'OCP');
legend('off');
legend('show');
hold off;
%% 
% delay part

pre = '1k';
rawdat = importdata([path, pre, file3]);
cdelay = rawdat.data;

% edelay =[];
% cdelay =[];
a = 1;b = 1; c = 1;  e = s*(s-1)/2;;
test_size = 200;
% ini = zeros(,1);ini(1) = 1;
[trans,~] = genTransMatrix(s, a, b, c, lambda);
ini = zeros(1,size(trans,1));ini(1) = 1;
[ggpdf, binVal ] = delayPDF_v3( trans, ini, test_size, e, lambda );
figure;
plot(0:60:6000,ggpdf, 'DisplayName', 'CON'); 
hold on;
ccdf = histogram(cdelay,'BinWidth',200,'Normalization','pdf');


pref_f = unique(pref_f);
pref_delay = edelay(:,1)==pref_f(1);
for i=2:size(pref_f)
    pref_delay = pref_delay | edelay(:,1)==pref_f(i);
end
pref_delay=edelay(pref_delay,2);
hold on;
ecdf = histogram(pref_delay,'BinWidth',200,'Normalization','cdf');

[ggpdf, ~ ] = delayPDF_v3( trans,estm_state_delay, 200, e, lambda ); 
figure; 
plot(0:60:6000,ggpdf, 'DisplayName', 'FAP'); 
ini = zeros(1,e+1);ini(1) = 1; 
[ggpdf, binVal ] = delayPDF_v3( trans,ini(1:(e+1)), 200, e, lambda ); 
hold on;
plot(0:60:6000,ggpdf, 'DisplayName', 'CON'); 
hold on;
ecdf = histogram(pref_delay,'BinWidth',200,'Normalization','pdf');

[ggpdf, binVal ] = delayCDF_v3( trans,estm_state_delay, 200, e, lambda ); 
cdfBinVal = cumsum(binVal);
figure; 
plot(lambda*(1:25),cdfBinVal(1:2), 'DisplayName', 'FAP'); 
hold on; 
plot(0:60:6000,ggpdf, 'DisplayName', 'FAP'); 

gain = ggpdf-conggpdf;
cost = (binVal - conBinVal)/(s-1);
utility = gain.*(1-cost);
figure;
plot((1:(encounterN-1))*lambda, utility);