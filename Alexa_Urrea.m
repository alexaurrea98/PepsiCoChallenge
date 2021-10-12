close all

%%
filename = 'nyas_challenge_2021data-2.xlsx';
pathname = 'C:\Users\alexa\Downloads/';
%data = dlmread([pathname,filename],'\t',1,0);

sheets = sheetnames(filename);
sales = xlsread(filename,sheets(1));
tradeActivities = xlsread(filename,sheets(2));
tradeMask = xlsread(filename,sheets(3));
media = xlsread(filename,sheets(4));

weeks = size(sales);
priceChange = tradeMask(:,1);
tv = media(:,1);
facebook = media(:,2);
twitter = media(:,3);
amazon = media(:,4);
audio = media(:,5);
print = media(:,6);
digital = media(:,7);

% This plot shows the trend in sales for all 148 weeks
figure(1)
x = [1:148];
plot(x,sales);
xlabel('Week number');
ylabel('Sales in US$');
title('Sales in 148 Weeks')

% Base sales = total sales - display - endcap - all media
% weekBase = sales - tradeActivities(:,2) - tradeActivities(:,3) - tv - facebook - twitter - amazon - audio - print - digital;


%% Relative correlations of trade and media on total sales

% Here I am converting media execution in form of impressions into GRP by
% dividning the values in each cell by the conversion factor of 1.28e6
mediaGRP = media ./1.28e6;

% Here I convert the mediaGRP matrix into an array of the sum of all the
% channels of media GRP for each week
totalMediaGRP = sum(mediaGRP,2);

% Figure 2 is the plot of total sales, media GRP of all the channels, and
% all the trade activities ploted versus the number of weeks.

% Sales is in US$ - total sales/10^4 in order to fit the plot
figure(2)
plot([1:148],sales./10^4);
xlabel('Week number');
hold on
% Media GRP summation of all channels for given week
figure(2)
plot([1:148],totalMediaGRP);
hold on
% Percentage ummation of trade activites for given week 
figure(2)
plot([1:148],sum(tradeActivities,2));
legend('Sales (x10^4)','Media GRP','Trade Activity');

% Figure 2 shows that media has a greater influence on total sales. It
% seems that it's usually when Media GRP decreases, so do the total sales.
% Trade activity does not make as much of an impact.
%
% This is further proven by the next two correlation plots.
% Figure 3 shows a postive linear correlation between sales and media GRP
figure(3)
plot(sales./10^4,totalMediaGRP,'*');
xlabel('Sales (x10^4)');
ylabel('Media GRP');
title('Sales and Media Correlation');

% Figure 4 shows that slaes and trade activities have no obvious
% correlation
figure(4)
plot(sales./10^4,sum(tradeActivities,2),'*');
xlabel('Sales (x10^4)');
ylabel('Trade Activity');
title('Sales and Trade Activities Correlation');
corrSalesTrade = corrcoef(sales,sum(tradeActivities,2));  % correlation 
                                                          % coefficient of 0.0269 
                                                          % further illustrates how little 
                                                          % trade activities drive sales

% From these two figures above (3 and 4), we can also conclude that Base
% and unexplained sales makeup anywhere from ~$350,000 to $400,000 of total
% sales. This was determined based on the correlations graphs--trade
% activities contributes very little change, but every time there was no
% media impressions (GRP = 0), sales for those weeks were still from
% ~$350,000 to $400,000. 

%% Which channel is most effective in terms of GRP?
% Using a correlation matrix, the channel with the highest correlation
% shows which is most influential to more sales. 

% Correlation matrix
salesMediaMat = [[sales],[media]];
cor = corrcoef(salesMediaMat);
values = {'Sales','TV','Facebook','Twitter','Amazon','Audio','Print','Digital-AO'};
figure(6)
h = heatmap(values,values,cor);
h.Title = 'Sales and Media Correlations';

% Figure 6 determines that TV is the most effective media in driving sales. This
% correlation graph helps identify that TV is most influetial by the high
% correlation coefficient of 0.85. Here is the order from most to least
% influetial media channels based on correlation coeffiecients:
% 1. TV   <- most effecitve at driving sales
% 2. Facebook
% 3. Twitter
% 4. Amazon
% 5. Print
% 6. Digital_AO
% 7. Audio <- least effective at driving sales

%% What effect did price change have on sales?
% Price change had less of an effect than media, however, it still had an
% effect. When there was no price change, this was better at driving sales
% than when there was a change in Price. There is a greater number of weeks
% that have sales over $40e4 when there was no price change. 
figure(8)
plot(sales./10^4,priceChange,'*');
xlabel('Sales in US$ x10^4');
ylabel('Price change (1 = yes, 0 = no)');
title('Sales and Price Change Correlation');

% num of weeks greater than $40e4 when price was changed
numOfWeeks = sum(sales.*priceChange>40e4);

% num of weeks greater than $40e4 when price was NOT changed
% Here I switch the numbers on the price change mask in order to indicate
% the weeks where the price does not change
priceChange(priceChange==0) = -1;
priceChange(priceChange==1) = 0;
priceChange(priceChange==-1) = 1;
numOfWeeksNot = sum(sales.*priceChange>40e4);

% The end result:
% Only 15 weeks where the price was changed was the number of sales greater
% than $40e4. In comparison, 40 weeks were greater than $40e4 in sales in
% weeks where the price did not change
figure(9)
X = [numOfWeeks numOfWeeksNot];
bar(X);
xticklabels({'Price Change','No Price Change'})
ylabel('Number of weeks with sales greater than $40e4');
title('How Price Change Affects Sales');

