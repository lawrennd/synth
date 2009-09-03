function dir = synthDirectory

% SYNTHDIRECTORY Returns directory where data is stored.
% FORMAT
% DESC returns the directory where this file is located, it is
% assumed that any data sets downloaded have this directory as
% their base directory.
% RETURN dir : the directory where this m-file is stored.
%
% SEEALSO : lvmLoadData, mapLoadData, datasetsDirectory
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006, 2009


% SYNTH

% by default return the directory where this file is.
fullSpec = which('synthDirectory');
ind = max(find(fullSpec == filesep));
dir = fullSpec(1:ind);
