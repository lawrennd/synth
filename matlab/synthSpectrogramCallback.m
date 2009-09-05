function synthSpectrogramCallback
  
% SYNTHSPECTROGRAMCALLBACK Callback for plot of spectrogram.
  
% SYNTH
  
  global visualiseInfo

  % What is the label?
  utti = get(visualiseInfo.utt_popup,'Value');
  utts = get(visualiseInfo.utt_popup,'String');
  utt=strtrim(utts{utti});
  command = ['cp ' synthDirectory 'data/' utt '.lab ' synthDirectory 'data/demo.lab'];  
  [s, w] = system(command);
  if s
    error(w)
  end

  % This generates the average response
  % Generates the wav file from the mean.
  [s, w] = system([synthDirectory 'eigenvoice_interactive.sh mean ' synthDirectory]);
  if s
    error(w);
  end
  
  
  % Display the spectrogram for the mean.
  [ncolumns, void] = synthDisplaySpectrogram(visualiseInfo.visualiseAxes2, [synthDirectory 'data/demo/demo.wav']);
  set(visualiseInfo.visualiseAxes, 'xlim', get(visualiseInfo.visualiseAxes2, ...
                                               'xlim'));
  set(visualiseInfo.visualiseAxes, 'UserData', ncolumns);

end