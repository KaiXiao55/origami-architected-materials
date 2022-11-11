function [A,jb] = frref(A,tol,type)
%FRREF   Fast reduced row echelon form.
%   R = FRREF(A) produces the reduced row echelon form of A.
%   [R,jb] = FRREF(A,TOL) uses the given tolerance in the rank tests.
%   [R,jb] = FRREF(A,TOL,TYPE) forces frref calculation using the algorithm
%   for full (TYPE='f') or sparse (TYPE='s') matrices.
%   
% 
%   Description: 
%   For full matrices, the algorithm is based on the vectorization of MATLAB's
%   RREF function. A typical speed-up range is about 2-4 times of 
%   the MATLAB's RREF function. However, the actual speed-up depends on the 
%   size of A. The speed-up is quite considerable if the number of columns in
%   A is considerably larger than the number of its rows or when A is not dense.
%
%   For sparse matrices, the algorithm ignores the tol value and uses sparse
%   QR to compute the rref form, improving the speed by a few orders of 
%   magnitude.
%
%   Authors: Armin Ataei-Esfahani (2008)
%            Ashish Myles (2012)
%
%   Revisions:
%   25-Sep-2008   Created Function
%   21-Nov-2012   Added faster algorithm for sparse matrices
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2008, Armin Ataei, Ashish Myles
% All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n] = size(A);

switch nargin
  case 1,
    % Compute the default tolerance if none was provided.
    tol = max(m,n)*eps(class(A))*norm(A,'inf');
    if issparse(A)
      type = 's';
    else
      type = 'f';
    end
  case 2,
  if issparse(A)
    type = 's';
  else
    type = 'f';
  end
  case 3,
    if ~ischar(type)
      error('Unknown matrix TYPE! Use ''f'' for full and ''s'' for sparse matrices.')
    end
    type = lower(type);
    if ~strcmp(type,'f') && ~strcmp(type,'s')
      error('Unknown matrix TYPE! Use ''f'' for full and ''s'' for sparse matrices.')
    end
end


do_full = ~issparse(A) || strcmp(type,'f');

if do_full
    % Loop over the entire matrix.
    i = 1;
    j = 1;
    jb = [];
    % t1 = clock;
    while (i <= m) && (j <= n)
       % Find value and index of largest element in the remainder of column j.
       [p,k] = max(abs(A(i:m,j))); k = k+i-1;
       if (p <= tol)
          % The column is negligible, zero it out.
          A(i:m,j) = 0; %(faster for sparse) %zeros(m-i+1,1);
          j = j + 1;
       else
          % Remember column index
          jb = [jb j];
          % Swap i-th and k-th rows.
          A([i k],j:n) = A([k i],j:n);
          % Divide the pivot row by the pivot element.
          Ai = A(i,j:n)/A(i,j);    
          % Subtract multiples of the pivot row from all the other rows.
          A(:,j:n) = A(:,j:n) - A(:,j)*Ai;
          A(i,j:n) = Ai;
          i = i + 1;
          j = j + 1;
       end
    end
else
    % Non-pivoted Q-less QR decomposition computed by Matlab actually
    % produces the right structure (similar to rref) to identify independent
    % columns.
    R = qr(A);

    % i_dep = pivot columns = dependent variables
    %       = left-most non-zero column (if any) in each row
    % indep_rows (binary vector) = non-zero rows of R
    [indep_rows, i_dep] = max(R ~= 0, [], 2);
    indep_rows = full(indep_rows); % probably more efficient
    i_dep = i_dep(indep_rows);
    i_indep = setdiff(1:n, i_dep);

    % solve R(indep_rows, i_dep) x = R(indep_rows, i_indep)
    %   to eliminate all the i_dep columns
    %   (i.e. we want F(indep_rows, i_dep) = Identity)
    F = sparse([],[],[], m, n);
    F(indep_rows, i_indep) = R(indep_rows, i_dep) \ R(indep_rows, i_indep);
    F(indep_rows, i_dep) = speye(length(i_dep));

    % result
    A = F;
    jb = i_dep;
end

