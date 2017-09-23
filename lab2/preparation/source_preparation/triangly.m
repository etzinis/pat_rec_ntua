function [ triangle ] = triangly( starty, midy, endy)
%TRIANGLY Summary of this function goes here
%   Detailed explanation goes here
line1 = linspace(0,1,(midy-starty+1));
line2 = linspace(1,0,(endy-midy+1));

triangle = horzcat(line1,line2(2:length(line2)));

end

