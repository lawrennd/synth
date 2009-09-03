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
  
  ud = get(gcf,'UserData');
  
  dtypes={'dur','cmp'};
  dtypei=get(ud.datatype_popup,'Value');
  dtype=char(dtypes(dtypei));
  
  
  utti = get(ud.utt_popup,'Value');
  utts = get(ud.utt_popup,'String');
  utt=strtrim(utts(utti,:));
  command = ['cp ' synthDirectory 'data/' utt '.lab ' synthDirectory 'data/demo.lab'];  
  [s, w] = system(command);
  if s
    error(w)
  end
  
  if (dtype=='dur')
    m=ud.durm;
    v=ud.durv;
  else
    m=ud.cmpm;
    v=ud.cmpv;
  end
  
  d1=get(ud.d1_popup, 'Value');
  d2=get(ud.d2_popup, 'Value');
  
  synthEigenvoiceSetup(dtype, m, v, d1, d2, ud.spaceplot, ud.spec1plot, ud.spec2plot);
end