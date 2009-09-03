function [normalised, meandata] = synthNormaliseData(data)

% NORMAISE_DATA Subtract the mean from the data.
% FORMAT
% DESC subtracts the mean from the data and performs any other
% normalization.
% ARG Y : the data.
% RETURN Y : the normalized data.
% REUTRN mu : the mean.
%
% COPYRIGHT : Jon Barker, 2009
 
% SYNTH
  
  meandata = mean(data);
  normalised = data - repmat(meandata, size(data,1), 1);
end