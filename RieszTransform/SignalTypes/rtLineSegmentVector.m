function [ featureV ] = rtLineSegmentVector( num_orders, normalise )
%
% Returns line feature based upon angles
%
%   Given the angles of all the lines in a feature, returns the ideal GHT
%   responses for feature matching. RT = ux + i*uy
%
%   Inputs:
%
%   angleV      vector containing all the angles in radians
%   ampV        vector containing line amplitudes
%   numOrders   maximum order to use
%   normalise   (optional) normalise response
%
%   Outputs:
%
%   featureV    vector containing the (complex) feature response

if nargin < 2
    normalise = 1;
end

featureV = rtLineArchetypeVector(1,0,num_orders,normalise);



