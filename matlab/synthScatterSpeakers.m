function [l, evoices, meanvoice] = synthScatterSpeakers(m, d1, d2)
   
% SYNTHSCATTERSPEAKERS Do PCA and scatter plot the speakers.
% FORMAT 
% DESC Returns the latent positions and the directions of the
% eigenvectors.
% ARG Y : the data to be projected in the latent space.
% ARG d1 : the first dimension to project.
% ARG d2 : the second dimension to project.
% RETURN X : the latent positions.
% RETURN W : the loading matrix values.
% RETURN MU : the mean voice.
%
% SEEALSO : demEigenvoiceLatent
%
% COPYRIGHT : Jon Barker, 2009
  
% SYNTH
  
  if (nargin < 2)
    d1=1;
    d2=2;
  end
  
  nspeakers = size(m, 1);
  
  
  [deltavoices, meanvoice] = synthNormaliseData(m);

  % Calculate the "eigenvoices".
  evoices = synthPca(deltavoices);

  
  l=zeros(nspeakers,2);
  
  for i=1:nspeakers
    [estimated, lambda] = synthProject([evoices(d1,:); evoices(d2,:)], m(i,:)-meanvoice);
    % Add back in the mean.
    estimated = estimated + meanvoice;
    l(i,:)=lambda;
  end
 
  lbls = [1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, ...
          0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0]';
  lbls = [lbls ~lbls];
  
  retLbls = cell(2,1);
  retLbls{1} = lbls;
  retLbls{2} = {'JB', 'Martin Cooke', 'Stuart Cunningham', 'Sue Harding', ...
                'UG', 'Stuart Wriggley', 'Gillian', 'Mike Stannett', ...
                'John Karn', 'UG', 'Anna', 'UG', ...
                'UG', 'UG', 'Female', 'UG', ...
                'UG', 'UG',  'UG', 'UG', ...
                'UG', 'UG', 'UG', 'UG', ...
                'UG', 'James Carmichael', 'Rob Mill', 'Matt Gibson', ...
                'Sarah Simpson', 'Vinny Wan', 'Lucy', 'NDL', ...
                'UG', 'UG'};

  lbls = retLbls;
  lvmTwoDPlot(l, lbls);
  xlim =get(gca, 'xlim');
  ylim = get(gca, 'ylim');
  set(gca, 'xlim', xlim*1.5);
  set(gca, 'ylim', ylim*1.5);
end
