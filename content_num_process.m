%this script is used to process the 'time, con_num, con_name' matrix a and
%produce the total number of contents over each time slots/total number of
%sample serious. 
function [con_m] = content_num_process(raw,smplIntrv,varargin)
%     smplIntrv=60;
%     maxs = 0;
%     con_n = zeros(500,2);
    con_n = zeros(500,1);
%     ab=[];
    % figure;hold on;
    %a(time, num, name)
    sample_num = 0;
    if nargin == 1
        pref_f = varargin{1};
    else
        pref_f = 0:max(raw(:,3));
    end
    for i = pref_f
        b = raw(raw(:,3)==i,:);

        bsize = size(b);
        if sum(b(:,2)) == 0
%             disp(['req not reach prod ' num2str(i)]);
            continue;
        end
        sample_num = sample_num+1;
        b(:,1)=b(:,1)-b(1,1);
        if (bsize(1)==1 )
            disp(b(1,3));
        end
%         plot(b(:,2));

        for j = 1:bsize(1)
            %disp(['k= ', num2str(k)]);
            %disp(['j= ', num2str(j)]);
            k = b(j,1)/smplIntrv+1;
            if (k > size(con_n, 1))
               con_n = [con_n; zeros(100,1)];
            end

            con_n(k,1) = con_n(k,1)+b(j,2);
%             con_n(k,2) = con_n(k,2)+1;
        end

%         if 60<= bsize(1)
%            ab = [ab i];
%         end
    %     plot(b(:,1),b(:,2));
    %     hold on;
    end
    %%
    % con_m = con_n(:,1)./con_n(:,2);
%     con_m = con_n(:,1)/( max(con_n));
    con_m = con_n(:,1)/ sample_num ;
    % % yyaxis left;
    % % hist(delay);
    % % hold on;
    % % yyaxis right;
    % plot(  ((0:size(con_m,1))*20)  ,con_m);
    % plot((0:116)*20+min(a(:,1)),con_m(1:117,:));
end
