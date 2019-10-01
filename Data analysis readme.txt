README

1. System requirements

Nanobright Analyser software was designed and tested using Windows 7

Use of Nanobright Analyser requires installation of Matlab Runtime 
https://au.mathworks.com/products/compiler/matlab-runtime.html

And Ghostscript
https://www.ghostscript.com/download/gsdnld.html

2. Installation guide

Follow Mathworks instructions for installation of Matlab runtime and Ghostscript instructions for installation of Ghostscript.

"NBAnalyserInstaller" is an executable file.

~5-10 minute installation time

3. Instructions for use

NB Analyser is a GUI that performs basic FCS fitting, peak picking and calculation of statistical parameters.

Files or folders (for batch analysis) are chosen for analysis using a modal dialog box file finder, and some parameters can be adjusted manually (bin width for photon counting histogram, manual threshold for peak picking)

Results of analysis are saved in a separate folder with the name of the analysis performed. Each file is saved as the original filename + analysis type.

Time units are related to acquisition frequency, except for FCS fitting, which assumes a 10us integration time and multiplies lags by 10, to give units of us for diffusion time.


e.g. Expected output of brightness function on test data "568 dye"

Average Signal		StDev			Mode	B Parameter		Brightness
3.14227572427572	2.03412506497165	2	1.31677330158531	0.316773301585311

units here are photons/10us based on a 10us integration time (100kHz acquisition frequency)