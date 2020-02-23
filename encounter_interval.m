clear;clc;
s = 5;a = 1;b = 1; c = 1;  e = s*(s-1)/2;
lambda = 2453.7*2/s/(s-1);
test_size = ceil(6000/lambda);
[trans,~] = genTransMatrix(s, a, b, c, lambda);

figure; hold on;
ini = zeros(1,size(trans,1));ini(1) = 1;
[ggpdf, binVal ] = delayPDF_v3( trans, ini, test_size, e, lambda );
plot((1:test_size-1), binVal, 'DisplayName', 'CON-A','LineWidth',2, ...
    'LineStyle','none','Color', [0.85 0.33 0.1],'Marker','o'); 


path = 'C:\Users\jzyan\Dropbox\PhDwork\opnet\data\apr2018\CONVEN\n5-CON-cs4k-pit6k-cl';
pre = '6k-rr100';
file1 = '-occur-time-self.txt';
file2 = '-occur-time-neig.txt';
file3 = '-send.txt';
file4 = '-recv.txt';
rawdata = importdata([path, pre, file1]);
data = rawdata.data;
rawdata = importdata([path, pre, file2]);
data = [data rawdata.data(:,2)];
rawdata = importdata([path, pre, file4]);
recv = rawdata.data;
rawdata = importdata([path, pre, file3]);
send = rawdata.data;


x = data;
f = x(:,2)<x(:,3); %reduce duplicate
x = x(f>0,1) ;
x=sort(x);

s_r = size(recv);
s_s = size(send);
s_x = size(x);

lam = x(2:s_x(1))-x(1:s_x(1)-1);
lam = mean(lam);

count = zeros(s_r(1),1);
for j = 1:s_r(1)
    for i = 1:s_s(1)
%         if j == 2741
%             disp(1);
%         end
        if recv(j,1) == send(i,1)
            for k = 1:s_x(1)
                if x(k) >= send(i,2)
                    count(j)=k;
                    break;
                end
            end
            for k = count(j):s_x(1)
                if x(k) >= recv(j,2)
                    count(j) = k- count(j);
                    break;
                end
            end
            if x(s_x(1)) < recv(j,2)
                   count(j) = k+1- count(j);
            end
        end
    end
end

count = count + (count==0);
ccdf = histogram(count,'Normalization','pdf','DisplayName','CON-S',...
    'EdgeColor', 'k', 'FaceAlpha', 0, 'LineWidth',1);
xlabel('Encounter Number');
ylabel('Probability');
legend('show');
set(gca,'FontSize',16)