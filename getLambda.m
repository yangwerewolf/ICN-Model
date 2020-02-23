function [lambda_p1, enc_sample_mean] = getLambda(path, len)
% path = 'C:\Users\jzyan\Dropbox\PhDwork\opnet\data\mar2019\lambda\7n_';
% pre = 'con_cs10_';
% path = 'C:\Users\jzyan\Dropbox\PhDwork\opnet\data\mar2019\lambda\n7-hete22-con-cs30-pit6k-cl6k-rr400-';
pre = '';
%-------------------------link last time--------------------------------
% file1 = 'link_time_neighbor_addr.txt';
% file2 = 'link_time_self_addr.txt';
% rawdata = importdata([path, pre, file1]);
% link_t = rawdata.data;
% rawdata = importdata([path, pre, file2]);
% link_t = [link_t rawdata.data(:,2)];

%------------------------encounter time-------------------------------- 
file3 = 'occur_neighbor_addr.txt';
file4 = 'occur_self_addr.txt';
rawdata = importdata([path, pre, file4]);
enc = rawdata.data;
enc = [enc(:,2) enc(:,1)];
rawdata = importdata([path, pre, file3]);
enc = [rawdata.data(:,2) enc];

% len = 7; %num of nodes
enc_num = 10000;
f = enc(:,1)<enc(:,2); %reduce duplicate
enc = enc(f>0,:) ;
encounter_pair = zeros(len,len,enc_num ); %data of each pair of nodes
y = [];
enc_sample_num =  zeros(len,len); %encounter time point of all nodes
enc_sample_mean = zeros(len,len);

%seperate data regarding to host addr
for i=1:length(enc)
    for k = 1:enc_num 
        if (encounter_pair(enc(i,1),enc(i,2),k)==0)
            encounter_pair(enc(i,1),enc(i,2),k)= enc(i,3);
            break;
        end
    end
end

%collect time gap
for i=1:len
    for j=(i+1):len
        a = squeeze(encounter_pair(i,j,:));
        a = a(a>0);
        enc_sample_num(i,j) = length(a);
        a = sort(a);
        a = a( 2:length(a) ) - a(1:(length(a)-1));
        enc_sample_mean (i,j) = mean(a);
        y = [y, a'];
    end
end

enc_all = enc(:,3);
enc_diff = enc_all(2:length(enc_all)) - enc_all(1:length(enc_all)-1);
enc_diff = sort(enc_diff);

lambda_p1 = mean(enc_diff);
lambda_p2 = 1/sum(1./enc_sample_mean(enc_sample_mean>1));
disp(['lambda_p1 ' num2str(lambda_p1) ' lambda p2 ' num2str(lambda_p2)]);

end %end function