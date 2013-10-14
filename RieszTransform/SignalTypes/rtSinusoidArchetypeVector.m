function [ featureV ] = rtSinusoidArchetypeVector( ampV, phaseV, orientV, num_orders, normalise )
%
% Returns line feature based upon angles
%
%   Given the angles of all the lines in a feature, returns the ideal GHT
%   responses for feature matching. RT = ux + i*uy
%
%   Inputs:
%
%   orientV      vector containing all the angles in radians
%   ampV        vector containing line amplitudes
%   numOrders   maximum order to use
%   normalise   (optional) normalise response
%
%   Outputs:
%
%   featureV    vector containing the (complex) feature response

if nargin < 4
    normalise = 1;
end

featureV = zeros(1, 2*num_orders+1);


for j = -num_orders:num_orders
    idx = j+num_orders+1;
    for k = 1:numel(ampV);
        % Even order
        if mod(j,2) == 0
            featureV(idx) = featureV(idx) + ...
                ampV(k) * exp(1i*j*orientV(k)) * cos(phaseV(k));
        % Odd order
        else
            featureV(idx) = featureV(idx) + ...
                ampV(k) * exp(1i*j*orientV(k)) * 1i*sin(phaseV(k));
        end
    end
end


if normalise == 1;
    featureV = featureV ./ norm(featureV);
end


