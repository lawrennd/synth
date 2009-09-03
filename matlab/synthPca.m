function evectors = synthPca(data)

% SYNTHPCA Principal components in the dual space
% FORMAT
% DESC computes the principal components in the dual space.
% ARG Y : the data for the computation.
% RETURN : W the principal compoents.
%
% SEEALSO 
%
% COPYRIGHT : Jon Barker, 2009
  
% SYNTH
  
  u=data*data';
  
  [pc, d]=eig(u);
  pc=fliplr(pc);

  evectors = pc' * data;
end