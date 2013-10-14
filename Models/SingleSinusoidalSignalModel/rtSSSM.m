function [ A, phase, theta, resNorm, fNorm ] = rtSSSM( I, N, filterType, filterParams )
%rtSSSM  Single sinusoidal signal model
%
%   Models local signal structure with a sinusoid and variable number of
%   Riesz transforms (RT)
%
%   Inputs:
%   I               Image to process
%   N               Maximum order RT to use (must be odd)
%   filterType      Base filter type:
%                       'lognormal' - log-normal filter
%   filterParams    Vector of filter parameters:
%                       log-normal:  [wavelength, sigma]
%
%   Outputs:
%   A               Amplitude of sinusoid
%   phase           Phase of sinusoid
%   theta           Orientation of sinusoid
%   resNorm         Norm of the residual component RT vector
%   fNorm           Norm of the signal RT vector
%
%
%   Example:
%   
%   [A, phase, theta, rN, fN] = rtSSSM(I,9,'lognormal',[32, 0.65]);
%
%   Written by:
%
%   Ross Marchant
%   James Cook University
%   ross.marchant@my.jcu.edu.au
%
%   Please see our ICIP2013 paper for more details:
%   
%

% Check number of orders
if mod(N,2) == 0
    error('Maximum order (N) must be odd');
end

% Calculate RT vector
fVector = rtVector(I, N, filterType, filterParams);

% We only need the positive orders (0 to N)
fVector = fVector(:,:,N+1:end);

% The RT vector response is
% cos(phase) * A * exp(i*n*theta)       for even n 
% i * sin(phase) * A * exp(i*n*theta)   for odd n
%
% This is using RT(u) = (ux + i*uy) / |u| which is different
% from the paper, but makes no difference to the final result
%

% Divide the odd orders by i
for k=0:N
    if mod(k,2) == 1
        fVector(:,:,k+1) = fVector(:,:,k+1)./1i;
    end
end

% Size of image
[r,c] = size(fVector(:,:,1));

% Pre-calculate some values
fVector_abs = abs(fVector);
fVector_angle = angle(fVector);

%
% Calculate the polynomial coefficients (beta)
%
beta = zeros(r,c,2*N+1);    % Polynomial coefficents
dbeta = zeros(r,c,2*N+1);   % Derivative polynomial coefficients
    
% Even terms
for j = -N+1:2:N-1
    for k=-N+1:2:N-1
        indx = (j + k)/2;
        if j == 0
            val = fVector(:,:,abs(j)+1);
        else
            val = 1/2 .* fVector_abs(:,:,abs(j)+1) .* exp(-1i * sign(j) * fVector_angle(:,:,abs(j)+1));
        end
        if k == 0
            val = val .* fVector(:,:,abs(k)+1);
        else
            val = val .* 1/2 .* fVector_abs(:,:,abs(k)+1) .* exp(-1i * sign(k) * fVector_angle(:,:,abs(k)+1));
        end
        beta(:,:,indx+N+1) = beta(:,:,indx+N+1) + val;
        dbeta(:,:,indx+N+1) = dbeta(:,:,indx+N+1) + 1i * (j+k) * val;
    end
end
% Odd terms
for j = -N:2:N
    for k=-N:2:N
        indx = (j + k)/2;
        if j == 0
            val = fVector(:,:,abs(j)+1);
        else
            val = 1/2 .* fVector_abs(:,:,abs(j)+1) .* exp(-1i * sign(j) * fVector_angle(:,:,abs(j)+1));
        end
        if k == 0
            val = val .* fVector(:,:,abs(k)+1);
        else
            val = val .* 1/2 .* fVector_abs(:,:,abs(k)+1) .* exp(-1i * sign(k) * fVector_angle(:,:,abs(k)+1));
        end
        beta(:,:,indx+N+1) = beta(:,:,indx+N+1) + val;
        dbeta(:,:,indx+N+1) = dbeta(:,:,indx+N+1) + 1i * (j+k) * val;
    end
end


%
% Find the roots of the derivative polynomial
%
ro = zeros(r,c,2*N);                % Roots matrix
vo = 1:1:2*N+1;                     % Coefficient indices
for y = 1:r
    for x = 1:c
        fd = dbeta(y,x,vo);         % Pixel coefficients
        fd = fd(:);                 % Make flat
        rt = roots(fd);             % Find roots
        tmp = zeros(1,2*N);         % Store in uniform size variable
        tmp(1:numel(rt)) = rt;
        ro(y,x,:) = tmp;            % Store result
    end
end
% Convert result into an angle
roa = mod(-angle(ro),2*pi)./2;


%
% Find root corresponding to maximum
%
% Values at roots
I_roots = zeros(r,c,2*N);
for k = 1:2*N
    for j = -N:1:N
        I_roots(:,:,k) = I_roots(:,:,k) + ...
            beta(:,:,j+N+1).*exp(1i * 2*j * roa(:,:,k));
    end
end
I_roots = real(I_roots);

% I_dot is maximum (same as dot product)
[I_dot, ii] = max(I_roots,[],3);
I_dot = sqrt(I_dot);

% I_orient is corresponding angle at maximum
[ri,ci] = ndgrid(1:r,1:c);
iidx = sub2ind([r,c,2*N],ri,ci,ii);
theta = roa(iidx);


%
% Even and odd components
%
f_k = zeros(r,c,N+1);
f_o = zeros(r,c,2*N);
f_e = zeros(r,c,2*N);
for j = 1:2*N
    for k=0:N
        f_k(:,:,k+1) = fVector_abs(:,:,k+1) .* ...
            cos(fVector_angle(:,:,k+1) - k*roa(:,:,j));
    end
    for k =0:2:N
        f_e(:,:,j) = f_e(:,:,j) + f_k(:,:,k+1);
    end
    for k =1:2:N
        f_o(:,:,j) = f_o(:,:,j) + f_k(:,:,k+1);
    end
end
f_ind = iidx;
f_even = f_e(f_ind);
f_odd = f_o(f_ind);


%
% Amplitude
%
A = 2 * I_dot ./ (N + 1);

%
% Phase
%
phase = atan2(f_odd, f_even);

% 
% Residual
%
modelVector = zeros(r,c,N+1);
for k=0:2:N
    modelVector(:,:,k+1) = A .* cos(phase) .* exp(1i * k * theta);
end
for k=1:2:N
    modelVector(:,:,k+1) = A .* sin(phase) .* exp(1i * k * theta);
end
resVector = zeros(r,c,N+1);
resNorm = 0;
for k=0:N
    resVector(:,:,k+1) = fVector(:,:,k+1) - modelVector(:,:,k+1);
    resNorm = resNorm + abs(resVector(:,:,k+1)) .^2;
end
resNorm = sqrt(resNorm);

% Re-multiply by i
for k=0:N
    if mod(k,2) == 1
        resVector(:,:,k+1) = resVector(:,:,k+1).*1i;
        modelVector(:,:,k+1) = modelVector(:,:,k+1).*1i;
    end
end

fNorm = sqrt(sum(abs(fVector).^2,3));

end