SYNTH Toolbox 
-------------

Version 0.1
-----------

This is the first release of the toolbox for giving demos at the Interspeech 2009 tutorial. 

The toolbox is designed for running on a Linux system. As well as the given MATLAB dependencies you will need the HTK, the SPTK, the linux sox package and perl installed on your system. You need to compile the program f2s.c found in the src directory using gcc.

gcc -o f2s f2s.c

Ensure the binaries for the following files are in the path: HMGenS (from HTK), excite, mglsadf (from SPTK).
