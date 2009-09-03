function [estimated, lambda]=synthProject(voices, target)

% SYNTHPROJECT Project from latent points to voices.
% FORMAT
% DESC projects from latent positions back to voices.
%
% COPYRIGHT : Jon Barker, 2009
%

% SYNTH
  
  N=size(voices,1);

  u=voices*voices';

  invu = pdinv(u);


  lambda = invu * voices * target';
  estimated = lambda' * voices;
end
