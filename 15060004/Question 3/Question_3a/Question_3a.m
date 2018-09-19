clc
clear all
load dat1.mat

    
data=dist1;
[r,c]=size(data);
K=2;  %Known


hiddenVariables=zeros(r,1);  %Cluster Labels

%Mean and Covariance Initialization 
means=zeros(K,c);  % Rows --> Clusters % Coulmns --> Features
random=randi(r,K,1);
mean(1:2,:)=data(random(1:2),:);
meanC1=mean(1,:); % Mew(c1,j,k)
meanC2=mean(2,:); % Mew(c2,j,k)
covC1=zeros(2,2);
covC2=zeros(2,2);
for i=1:r
    covC1(1,1)=covC1(1,1)+((data(i,1)-meanC1(1,1))^2);
    covC1(1,2)=covC1(1,2)+((data(i,1)-meanC1(1,1))*(data(i,1)-meanC1(1,2)));
    covC1(2,1)=covC1(2,1)+((data(i,2)-meanC1(1,2))*(data(i,1)-meanC1(1,1)));
    covC1(2,2)=covC1(2,2)+((data(i,2)-meanC1(1,2))^2);
    
    covC2(1,1)=covC2(1,1)+((data(i,1)-meanC2(1,1))^2);
    covC2(1,2)=covC2(1,2)+((data(i,1)-meanC2(1,1))*(data(i,1)-meanC1(1,2)));
    covC2(2,1)=covC2(2,1)+((data(i,2)-meanC2(1,2))*(data(i,1)-meanC1(1,1)));
    covC2(2,2)=covC2(2,2)+((data(i,2)-meanC2(1,2))^2);   
end
covC1=covC1/(r-1);
covC2=covC2/(r-1);

%Expectation Maximization Algorithm 

%As These are initial calculations, we choose to ignore the weights
%associated with each calculation 
%Calculating Initial Probabilites for each data point for each cluster

%meanDiff1 = bsxfun(@minus, data, meanC1);
%tempexpsum=0;

phi = ones(1, K) * (1 / K);
prob_b_given_X=zeros(r,K);
labels=zeros(r,2);
W = zeros(r, K);

for i=1:r
%     for j=1:2
%         for k=1:2
%             tempexpsum= tempexpsum + (transpose((data(i,j)-mean(1,j)))*inv(covC1)*(data(i,k)-mean(1,k)));
%         end
%     end
    prob_b_given_X(i,1) = 1 / (sqrt((2*pi)^2 * sqrt(det(covC2)))) * exp(-1/2 * ((data(i,:)-mean(1,:))*inv(covC2))*transpose(data(i,:)- mean(2,:)));
    prob_b_given_X(i,2) = 1 / (sqrt((2*pi)^2 * sqrt(det(covC2)))) * exp(-1/2 * ((data(i,:)-mean(2,:))*inv(covC2))*transpose(data(i,:)- mean(2,:)));
%
end

for i=1:r
    if (prob_b_given_X(i,1)>prob_b_given_X(i,2))
    labels(i,1)=1;
    else
        labels(i,2)=1;
    end
end

dataCluster1=[];
dataCluster2=[];
for i=1:r
    if(labels(i,1)==1)
        dataCluster1=vertcat(dataCluster1,i);
    else
        dataCluster2=vertcat(dataCluster2,i);
    end
end

z1=[];
z2=[];
for i=1:length(dataCluster1)
    z1=vertcat(z1,data(dataCluster1(i,1),:));
end

for i=1:length(dataCluster2)
    z2=vertcat(z2,data(dataCluster2(i,1),:));
end

pdf_w = bsxfun(@times, prob_b_given_X, phi);
W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));


%while  %Convergence Conditon
flag = true;
iterations=1;

% while flag
%     
%New Mean 

%     
%     oldmean=mean;
%     oldcovC1=covC1;
%     oldcovC2=covC2;
%     
%     if (difference <0.005)
%         flag = false;
%     end
% end
%Probability






