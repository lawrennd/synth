function synthEigenvoiceCallback
  
% SYNTHEIGENVOICECALLBACK Callback function for the eigenvoice demo.
% FORMAT
% DESC handles call backs from the user interface for the eigenvoice
% demonstration.
% 
% SEEALSO : demEigenvoiceLatent
%  
% COPYRIGHT : Jon Barker, 2009
%  
% MODIFICATIONS : Neil D. Lawrence, 2009
  
% SYNTH
  
  global visualiseInfo
    
  dtypes={'dur','cmp'};
  dtypei=get(visualiseInfo.datatype_popup,'Value');
  dtype=char(dtypes(dtypei));
  
  
  utti = get(visualiseInfo.utt_popup,'Value');
  utts = get(visualiseInfo.utt_popup,'String');
  utt=strtrim(utts{utti});
  command = ['cp ' synthDirectory 'data/' utt '.lab ' synthDirectory 'data/demo.lab'];  
  [s, w] = system(command);
  if s
    error(w)
  end
  
  if (dtype=='dur')
    m=visualiseInfo.durm;
    v=visualiseInfo.durv;
  else
    m=visualiseInfo.cmpm;
    v=visualiseInfo.cmpv;
  end
  
  d1=get(visualiseInfo.d1_popup, 'Value');
  d2=get(visualiseInfo.d2_popup, 'Value');
  
  synthEigenvoiceSetup(dtype, m, v, d1, d2);
end
