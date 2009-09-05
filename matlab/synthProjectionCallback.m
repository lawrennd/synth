function [projection, mse] = synthProjectionCallback(mode)
  
% SYNTHPROJECTIONCALLBACK Callback function for the projection interface.
% FORMAT
% DESC handles the interface for the projection of the grid corpus
% speakers.
% ARG mode : either 'orig' or 'reduced' for original or reduced space.
% RETURN projection : the data projection.
% RETURN err : the mean squared error.
%
% COPYRIGHT : Jon Barker, 2009
%  
% MODIFICATIONS : Neil D. Lawrence, 2009
%
% SEEALSO : demProjectVoices
  
% SYNTH
  
  ud = get(gcf,'UserData');

  % Load label sequence to be synthesised
  utti = get(ud.utt_popup,'Value');
  utts = get(ud.utt_popup,'String');
  utt = strtrim(utts{utti});
%  utt=strtrim(utts(utti,:));
  command = ['cp ' synthDirectory 'data/' utt '.lab ' synthDirectory 'data/demo.lab'];
  [s, w] = system(command);
  if s
    error(w);
  end
  
  m=ud.cmpm;
  v=ud.cmpv;
  
  % Get id
  target_id=str2num(get(ud.id_edit,'String'));
  
  % Get ndims
  ndims=str2num(get(ud.ndims_edit,'String'));

  %
  cheat=get(ud.mode_checkbox,'Value');

  
  target = m(target_id, :);
  if (cheat==0)
    m=m([1:34]~=target_id,:);
  end
  
  if (strcmp(mode,'orig')==1)
    n=size(m,1);
    [projection, mse]=project(target, m, n);
    plotpane=ud.spec1plot;
  elseif (strcmp(mode,'reduced')==1)
    [projection, mse]=project(target, m, ndims);
      
    plotpane=ud.spec2plot;
    set(ud.error_text,'String',num2str(mse));
  end
  
  synthWriteHmmParams([synthDirectory 'tmp/projection'],projection);
  
  % (note, synthesised with variance equal to mean of variances over all speakers)
  synth_command=[synthDirectory 'eigenvoice_interactive.sh cmp ' synthDirectory ' tmp/projection data/mean_cmp.var'];
  [s, w] = system(synth_command);
  if s
    error(w);
  end

  synthDisplaySpectrogram(plotpane, [synthDirectory 'data/demo/demo.wav']);

  [s, w] = system(['play ' synthDirectory 'data/demo/demo.wav']);
  if s
    error(w);
  end

end
  
  
  
function [projection, mse] = project(target, voices, ndims)

  % PROJECT The test voice onto other voices.
  [deltavoices, meanvoice] = synthNormaliseData(voices);
  
  % Calculate the eigen voices using the efficient Turk and Pentland technique
  
  evoices = synthPca(deltavoices);
  if ndims>0
    [projection, lambda] = synthProject(evoices(1:ndims,:), target- ...
                                        meanvoice);
  else
    projection = zeros(size(meanvoice));
  end
  projection = projection + meanvoice;  
  mse = mean((projection-target).^2);
  
end


