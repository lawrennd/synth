function synthModify(handle, values, type)

% SYNTHMODIFY Helper code for synthesis of voices.
% FORMAT
% DESC updates spectral visualization and synthesizes the voice.
% ARG handle : a vector of handles to the structure to be updated.
% ARG vals : the HMM values to synthesize the voice with.
% ARG type : either 'cmp' for MFCC synthesis or 'dur' for duration synthesis.
%
% SEEALSO : synthVisualise
%
% COPYRIGHT : Neil D. Lawrence, 2009


% SYNTH

  global visualiseInfo
  if nargin < 3
    type = 'cmp';
  end

  % Display the spectrogram for the projected point
  % Write the values. 
  name = sprintf([synthDirectory 'tmp/eigenproj.mean.click']);
  synthWriteHmmParams(name, values);
  
  
  synth_command=[synthDirectory 'eigenvoice_interactive.sh ' type ' ' synthDirectory ...
                 ' tmp/eigenproj.mean.click tmp/eigenproj.var.click'];

  [s, w] = system(synth_command);
  if s
    error(w);
  end
  %cla(visualiseInfo.visualiseAxes);
  ncolumns = get(visualiseInfo.visualiseAxes, 'userdata');
  [void, void, vals] = synthDisplaySpectrogram(visualiseInfo.visualiseAxes, [synthDirectory ...
                      'data/demo/demo.wav'], ncolumns);
  set(handle, 'CData', vals);
  [s, w] = system(['play ' synthDirectory 'data/demo/demo.wav']);
  if s
    error(w);
  end

    
end