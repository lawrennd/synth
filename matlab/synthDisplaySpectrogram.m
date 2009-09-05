function [columns, h, spec_im] = synthDisplaySpectrogram(ax, filename, desired_ncolumns)  

% SYNTHDISPLAYSPECTROGRAM Display the synthesized spectrogram.
% FORMAT
% DESC displays the spectrogram of the given file name in the given axis.
% ARG ax : the axis to disply on.
% ARG filename : the file to display.
% ARG ncols : the desired number of columns to display.
% RETURN cols : the columns size of the spectrogram.
% RETURN h : handle to the image data from the spectrogram.
%
% SEEALSO : demEigenvoiceLatent, demProjectvoices
%
% COPYRIGHT : Jon Barker, 2009
%
% MODIFICATIONS : Neil D. Lawrence, 2009
  
% SYNTH

  if nargout < 3
    axes(ax);
  end
  x = wavread(filename); 
  sp = myspectrogram(x, 2048, 8000); 
  spec_im = flipud(log(abs(sp(1:700,:))));
  ncolumns = size(spec_im, 2);
  if (nargin==3) 
    if (desired_ncolumns<ncolumns)
      % Truncate spectrogram to desired width
      spec_im = spec_im(:, 1:desired_ncolumns);
    elseif (desired_ncolumns>ncolumns)
      % Pad spectrogram to desired width
      pad=zeros(700,desired_ncolumns-ncolumns);
      spec_im = [spec_im pad];
    end
  end
  if nargout < 3
    h = imagesc(spec_im);
    drawnow;
  else
    h = [];
  end
  columns=size(spec_im,2);
end
