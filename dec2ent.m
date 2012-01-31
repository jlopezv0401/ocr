function [x] = dec2ent (f,c,m,x,dec)

% close all; clear all; clc;
% X=csvread('ejem1.csv');
% x=X(:,1:4);
% 
% f=size(x,1);
% c=size(x,2);
% m=min(x,[ ],1);

for i=1:c
    x(:,i)=x(:,i)-m(1,i);
end

for i=1:c
    j= fix(x(1,i));
    if (x(1,i)-j<1 && x(1,i)-j>0)
        x=round(x/10^-dec);
        break
    end
end