function handle = synthVisualise(vals, type)

% SYNTHVISUALISE For synthesizing a voice.
% FORMAT
% DESC draws a synth man representation in a 3-D plot.
% ARG vals : the mean HMM values to use for synthesis.
% RETURN handle : a vector of handles to the plotted structure.
%
% SEEALSO : synthModify
%
% COPYRIGHT : Neil D. Lawrence, 2009

% SYNTH

  global visualiseInfo
  
  a = ver('matlab');
  if strcmp(a.Version, '7.0.1')
    menu = 'listbox';
  else
    menu = 'popupmenu';
  end
  fhandle = gcf;
  string = {'ay', 'place', 'bbaf3s', 'pbav3s'};
  visualiseInfo.utt_popup = uicontrol('Style', menu, ...
                                      'Parent',fhandle, ...
                                      'Units', 'normalized', ...
                                      'Position',[0.02 0.02 0.2 0.05], ...  
                                      'String', string, ...
                                      'Min', 1, 'Max', ...
                                      length(string), 'Value', 3, ...
                                      'callback', 'synthSpectrogramCallback' );

  h = visualiseInfo.utt_popup;
  if(strcmp(menu, 'listbox'))
    set(h, 'listboxtop', get(h, 'value'));
  end

  
  utti = get(visualiseInfo.utt_popup,'Value');
  utts = get(visualiseInfo.utt_popup,'String');
  utt=strtrim(utts{utti});
  command = ['cp ' synthDirectory 'data/' utt '.lab ' synthDirectory 'data/demo.lab'];  
  [s, w] = system(command);
  if s
    error(w)
  end


  
  figure(get(visualiseInfo.visualiseAxes, 'parent'));
  set(visualiseInfo.visualiseAxes, 'Position',[0.01, 0.17, 0.98, 0.3]);
  title('Y')
  visualiseInfo.visualiseAxes2 = axes('position', [0.01, 0.58, 0.98, 0.3]);
  title('Mean')
  
  % Generates the wav file from the mean.
  [s, w] = system([synthDirectory 'eigenvoice_interactive.sh mean ' synthDirectory]);
  if s
    error(w);
  end
  
  % Displays the spectrogram for the mean.
  [ncolumns] = synthDisplaySpectrogram(visualiseInfo.visualiseAxes2, [synthDirectory 'data/demo/demo.wav']);
  [ncolumns, handle] = synthDisplaySpectrogram(visualiseInfo.visualiseAxes, [synthDirectory 'data/demo/demo.wav']);
  set(visualiseInfo.visualiseAxes, 'UserData', ncolumns);
  
  name = sprintf([synthDirectory 'tmp/eigenproj.var.click']);
  [m, v] = synthLoadData('cmp');
  synthWriteHmmParams(name, mean(v));

end