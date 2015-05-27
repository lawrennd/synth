SYNTH software
Version 0.1		Sunday 06 Sep 2009 at 06:14

SYNTH Toolbox 
-------------

Version 0.1
-----------

This is the first release of the toolbox for giving demos at the Interspeech 2009 tutorial. 

The toolbox is designed for running on a Linux system. As well as the given MATLAB dependencies you will need the HTK, the SPTK, the linux sox package and perl installed on your system. You need to compile the program f2s.c found in the src directory using gcc.

gcc -o f2s f2s.c

Ensure the binaries for the following files are in the path: HMGenS (from HTK), excite, mglsadf (from SPTK).


MATLAB Files
------------

Matlab files associated with the toolbox are:

synthEigenvoiceSetup.m: Sets up the demo or the eigenvoices.
synthScatterSpeakers.m: Do PCA and scatter plot the speakers.
synthDisplaySpectrogram.m: Display the synthesized spectrogram.
synthVisualise.m: For synthesizing a voice.
synthNormaliseData.m: Subtract the mean from the data.
demEigenvoiceLatent.m: Show latent space of eigenvoices.
synthProjectionCallback.m: Callback function for the projection interface.
%MYSPECTROGRAM Calculate spectrogram from signal.
synthModify.m: Helper code for synthesis of voices.
synthPca.m: Principal components in the dual space
synthWriteHmmParams.m: Write the HMM parameters to a file.
synthEigenvoiceCallback.m: Callback function for the eigenvoice demo.
synthToolboxes.m: Toolboxes required for Synth demos.
demProjectVoices.m: Demonstrate projection of voices onto reduced dimension.
synthProject.m: Project from latent points to voices.
synthDirectory.m: Returns directory where data is stored.
synthSpectrogramCallback.m: Callback for plot of spectrogram.
synthLoadData.m: Load a latent variable model dataset.
