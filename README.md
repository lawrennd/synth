
Speech Synthesis Software
=========================

This page describes examples of how to use the simple MATLAB interface to the eigenvoice software for generating speech based on the Grid corpus.

This software has been tested on Linux only, it requires the presence of Perl, the HTK, and the SPTK as well as the SoX package.

The SYNTH software can be downloaded [here](http://ml.sheffield.ac.uk/~neil/cgi-bin/software/downloadForm.cgi?toolbox=synth).

Release Information
-------------------

**Current release is 0.1**.

As well as downloading the SYNTH software you need to obtain the toolboxes specified below. **These can be downloaded using the *same* password you get from registering for the SYNTH software.**

| **Toolbox**                                                                | **Version** |
|----------------------------------------------------------------------------|-------------|
| [VOICEBOX](http://ml.sheffield.ac.uk/~neil/voicebox/downloadFiles/vrs1p12) | 1.12        |
| [NDLUTIL](http://ml.sheffield.ac.uk/~neil/ndlutil/downloadFiles/vrs0p161)  | 0.161       |

This is the first release for the Interspeech tutorial.

### Installation

Ensure the following binary files are in the path: HMGenS (from HTK), excite, mglsadf (from SPTK). Compile the file f2s.c using gcc (gcc -o f2s f2s.c) and ensure it is in the path.

### Examples

There are two main demonstration files,

```matlab
>> demEigenvoiceLatent 
```

for visualizing the latent space of the eigenvoices and

```matlab
>> demProjectVoices 
```

for reacreating individual speaker voices by projecting them onto the principal components defined by the other speakers.

The [dimensionality reduction toolbox](../dimred/) also makes use of the SYNTH toolbox for some examples of dimensionality reduction.

Page updated on Sun Sep 6 06:14:25 2009


