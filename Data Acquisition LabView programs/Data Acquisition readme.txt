README

1. System requirements

Nanobright acquisition software was designed and tested using Windows 7

Use of Nanobright acquisition files requires installation of LabVIEW Run-Time Engine 2015
http://www.ni.com/download/labview-run-time-engine-2015/5507/en/

2. Installation guide

Follow National Instruments instructions for installation of LabVIEW Run-Time Engine

"NanoBright Acquisition preview" and "NanoBright Acquisition self-aligning" are executable files

NI LabVIEW driver may need to be installed for data acquisition card, for Measurement Computing DAQ the link is provided here:
https://www.mccdaq.com/daq-software/universal-library-extensions-lv.aspx

~30 minute installation time

3. Instructions for use

"NanoBright Acquisition preview" has two adjustable parameters, acquisition frequency and the length of data acquisition. Data are not saved.

"NanoBright Acquisition self-aligning" has additional adjustible parameters:
Period of measurement
Number of files
Number of files before re-alignment.

Data are saved and filename must be chosen upon prompt. For multiple files, names include timestamp (day of year_hour_minute_seconds)

Run time depends on measurement period