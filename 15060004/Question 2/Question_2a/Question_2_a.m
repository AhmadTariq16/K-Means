close all
clc
clear all
load dat1.mat


data=dist1;
[r,c]=size(data);
K=2;  %Known

%Centeroids Initialization 
centeroid=zeros(K,c);  % Rows --> Clusters % Coulmns --> Features
random=randi(r,K,1);
centeroid(1:2,:)=data(random(1:2),:)
% centeroid=[min(data);max(data)]

%K Means Algorithm 
distance=zeros(r,K);
dataPointLabels=zeros(r,1);

flag= true;
iterations=1;
while flag   %Convergence Condition

%Distance Calculation
for i=1:r   %Data Points
    for j=1:K    %Clusters
        for l=1:c   %features
            distance(i,j)=distance(i,j)+((data(i,l)- centeroid(j,l))^2);
        end
    end
end

%Assigning Data to Clusters
[a b]= min(distance,[],2);
dataPointLabels=b;

%Centeroid Movement
cluster1=[];
cluster2=[];
for i=1:r
    if dataPointLabels(i,1)==1
        cluster1=vertcat(cluster1,i);
    end
    if dataPointLabels(i,1)==2
        cluster2=vertcat(cluster2,i);
    end
end
tempsum1=zeros(1,2);
tempsum2=zeros(1,2);

for i=1:length(cluster1)
    for j=1:K
        tempsum1(1,j)=tempsum1(1,j)+data(cluster1(i),j);
    end
end
cluster1avg=tempsum1/length(cluster1);
for i=1:length(cluster2)
    for j=1:K
        tempsum2(1,j)=tempsum2(1,j)+data(cluster2(i),j);
    end
end
cluster2avg=tempsum2/length(cluster2);

oldCenteroid=centeroid;
centeroid=[cluster1avg;cluster2avg]

difference=centeroid-oldCenteroid

for i=1:2
    for j=1:2
        if (abs(difference(i,j))<0.005)
            flag = false;
        end
    end
end

iterations=iterations+1

z1=[];
z2=[];
for i=1:length(cluster1)
    z1=vertcat(z1,data(cluster1(i,1),:));
end
for i=1:length(cluster2)
    z2=vertcat(z2,data(cluster2(i,1),:));
end

figure;
hold on
plot(z1(:,1),z1(:,2),'r.'); %plotting cluster 1 pts
plot(z2(:,1),z2(:,2),'g+'); %plotting cluster 2 pts

end
