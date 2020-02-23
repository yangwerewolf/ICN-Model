%this version is used to extract FAP-only data instead of mix of FAP and
%normal data. FAP data will have long 1 content time because of no req in
%the network 
%this script is used to process the 'time, con_num, con_name' matrix a and
%produce the total number of contents over each time slots/total number of
%sample serious. 


maxs = [];
con_n = zeros(500,2);
ab=[];
% figure;hold on;
%a(time, num, name)
sample_num = 0;
for i=1:size(pref_f)
    b = a(a(:,3)==pref_f(i),:);
    
    bsize = size(b);
    if bsize(1) == 0
        continue;
    end
    sample_num = sample_num+1;
    b(:,1)=b(:,1)-b(1,1);
%     plot(b(:,2));
    
    for j = 1:bsize(1)
        %disp(['k= ', num2str(k)]);
        %disp(['j= ', num2str(j)]);
        k = b(j,1)/20+1;
        if (k > size(con_n, 1))
           con_n = [con_n; zeros(100,2)];
        end
        
        con_n(k,1) = con_n(k,1)+b(j,2);
        con_n(k,2) = con_n(k,2)+1;
    end
    
    if 60<= bsize(1)
       ab = [ab i];
    end
%     plot(b(:,1),b(:,2));
%     hold on;
end
%%
% con_m = con_n(:,1)./con_n(:,2);
con_m = con_n(:,1)/( (max(a(:,3))+1) );
% con_m = con_n(:,1)/ sample_num ;
% % yyaxis left;
% % hist(delay);
% % hold on;
% % yyaxis right;
% plot(  ((0:size(con_m,1))*20)  ,con_m);
% plot((0:116)*20+min(a(:,1)),con_m(1:117,:));

%%
