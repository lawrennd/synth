function synthEigenvoiceSetup(dtype, m, v, d1, d2, space2plot, spec1plot, spec2plot)

% SYNTHEIGENVOICESETUP Sets up the demo or the eigenvoices.
% FORMAT
% DESC sets up the demonstration for the eigenvoices.
% ARG dtype : either 'dur' for duration modeling otherwise mfccs are
% modelled.
% ARG Y : the data.
% ARG d1 : dimension to plot on X axis.
% ARG d2 : dimension to plot on Y axis.
% ARG axSpec1 : axis for first spectrogram.
% ARG axSpec2 : axis for second spectrogram.
% ARG axScatter : axis for scatter plot.
%
% COPYRIGHT : Jon Barker, 2009
%  
% MODIFICATIONS : Neil D. Lawrence, 2009

%
% SEEALSO demEigenvoiceLatent

% SYNTH
  global visualiseInfo
  np = size(m,2);
  
  subplot(visualiseInfo.spec1plot); cla;
  subplot(visualiseInfo.spec2plot); cla;
  subplot(visualiseInfo.plotAxes); cla;
  
  [l, evoices, meanvoice] = synthScatterSpeakers(m, d1, d2);

  [s, w] = system([synthDirectory 'eigenvoice_interactive.sh mean ' ...
                   synthDirectory]);
  if s
    error(w);
  end

  ncolumns = synthDisplaySpectrogram(visualiseInfo.spec1plot, [synthDirectory 'data/demo/demo.wav']);
  
  if (dtype=='dur')
    synth_command=[synthDirectory 'eigenvoice_interactive.sh dur ' synthDirectory ...
                   ' tmp/eigenproj.mean.click tmp/eigenproj.var.click'];
  else
    synth_command=[synthDirectory 'eigenvoice_interactive.sh cmp ' synthDirectory ...
                   ' tmp/eigenproj.mean.click tmp/eigenproj.var.click'];
  end
  
  [p1 p2 button] = ginput(1);
  
  while (inbounds(p1,p2) && button==1)
    
    voice = meanvoice + evoices(d1,:)*p1 + evoices(d2,:)*p2;
    
    name = sprintf([synthDirectory 'tmp/eigenproj.mean.click']);
    synthWriteHmmParams(name, voice(1:np));
    
    name = sprintf([synthDirectory 'tmp/eigenproj.var.click']);
    synthWriteHmmParams(name, mean(v));
    
    [s, w] = system(synth_command);
    if s
      error(w);
    end

    synthDisplaySpectrogram(visualiseInfo.spec2plot, [synthDirectory 'data/demo/demo.wav'], ncolumns);
    [s, w] = system(['play ' synthDirectory 'data/demo/demo.wav']);
    if s
      error(w);
    end
    
    subplot(visualiseInfo.plotAxes)
    
    [p1 p2 button] = ginput(1);
    
    
  end
end

function isin = inbounds(p1,p2)
  
  xlim = get(gca,'XLim');
  ylim = get(gca,'YLim');  
  isin = (p1>xlim(1) && p1<xlim(2) && p2>ylim(1) && p2<ylim(2));
  
end