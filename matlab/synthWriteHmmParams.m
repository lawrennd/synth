function synthWriteHmmParams(name, params);

% SYNTHWRITEHMMPARAMS Write the HMM parameters to a file.
% FORMAT
% DESC writes the HMM parameters to a file for input into HTK by the perl
% script.
% ARG name : the file name.
% ARG params : the parameters to write.
%
% SEEALSO : synthEigenvoiceSetup, synthProjectionCallback
%
% COPYRIGHT : Jon Barker, 2009
  
% SYNTH
  
  fid = fopen(name,'wt');
  fprintf(fid,'%f ',params);
  fprintf(fid,'\n');
  fclose(fid);
end