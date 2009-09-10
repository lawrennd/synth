function [m, v, lbls] = synthLoadData(dataset, seedVal)

% SYNTHLOADDATA Load a latent variable model dataset.
% FORMAT
% DESC loads a data set for a latent variable modelling problem.
% ARG dataset : the name of the data set to be loaded, either 'cmp' or 'dur'.
% RETURN m : the HMM means.
% RETURN v : the HMM variances.
% RETURN lbls : the labels.
%
% SEEALSO : mapLoadData, lvmLoadData
%
% COPYRIGHT : Neil D. Lawrence, 2004, 2005, 2006, 2008, 2009

% SYNTH

  if nargin > 1
    randn('seed', seedVal)
    rand('seed', seedVal)
  end

  lbls = [1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, ...
          0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0]';
  lbls = [lbls ~lbls];

  
  % get directory
  baseDir = synthDirectory;
  dirSep = filesep;
  switch dataset
   case 'cmp'
    try 
      load([baseDir 'data' filesep dataset '.mat']);
    catch
      [void, errid] = lasterr;
      if strcmp(errid, 'MATLAB:load:couldNotReadFile');
        disp('Loading mfcc means...');
        m=load([synthDirectory 'data/cmp.mean']);
        disp('Loading mfcc variances...');
        v=load([synthDirectory 'data/cmp.var']);        
        
        save([baseDir 'data' filesep dataset '.mat'], 'm', 'v', 'lbls');
      else
        error(lasterr);
      end
    end
      
   case 'dur'
    try 
      load([baseDir 'data' filesep dataset '.mat']);
    catch
      [void, errid] = lasterr;
      if strcmp(errid, 'MATLAB:load:couldNotReadFile');
        disp('Loading duration means...');
        m = load([synthDirectory 'data/dur.mean']);
        disp('Loading duration variances...');
        v = load([synthDirectory 'data/dur.var']);
        save([baseDir 'data' filesep dataset '.mat'], 'm', 'v', 'lbls');
      else
        error(lasterr);
      end
    end
    
   otherwise
    error('Unknown data set requested.')
    
  end

  retLbls = cell(2, 1);
  retLbls{1} = lbls;
                  retLbls{2} = {'JB', 'MPC', 'Stuart Cunningham', 'Sue Harding', ...
                                'Jonny Laidler', 'Stuart Wriggley', 'South Yorkshire G', 'MS', ...
                                'JK', 'UG 1', 'South Yorkshire A', 'UG 2', ...
                                'UG 3', 'UG 4', 'UG 5', 'UG 6', ...
                                'UG 7', 'UG 8',  'UG 9', 'UG 10', ...
                                'UG 11', 'UG 12', 'UG 13', 'UG14', ...
                                'UG', 'West Indies', 'Rob Mill', 'Scottish', ...
                                'Sarah Simpson', 'Vinny Wan', 'South Yorkshire L', 'NDL', ...
                                'UG 15', 'UG 16'};
%/~  retLbls{2} = {'JB', 'Martin Cooke', 'Stuart Cunningham', 'Sue Harding', ...
%                 'Jonny Laidler', 'Stuart Wriggley', 'Gillian', 'Mike Stannett', ...
%                 'John Karn', 'UG', 'Anna', 'UG', ...
%                 'UG', 'UG', 'Female', 'UG', ...
%                 'UG', 'UG',  'UG', 'UG', ...
%                 'UG', 'UG', 'UG', 'UG', ...
%                 'UG', 'James Carmichael', 'Rob Mill', 'Matt Gibson', ...
%                 'Sarah Simpson', 'Vinny Wan', 'Lucy', 'NDL', ...
%                 'UG', 'UG'};
%~/
lbls = retLbls;
  
end
