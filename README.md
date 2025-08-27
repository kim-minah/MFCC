# MFCC Audio Feature Extraction and Visualization

## Overview
This repository provides a workflow for extracting and visualizing Mel-Frequency Cepstral Coefficients (MFCCs) from audio recordings.  
It combines **MATLAB scripts** (for feature extraction) with an **R script** (for plotting results), producing clean CSV outputs and summary visualizations of MFCC feature vectors.  

---

## Workflow
1. **Convert audio files to mono**  
   - Use [Audacity](https://www.audacityteam.org/) or batch convert in terminal.  
   - Create an `audio/` folder in the repository and save mono files there using the format `filename_mono.wav`.  
   - *(Note: the `audio/` folder is not included in this repository due to file size constraints.)*

2. **Run MATLAB script**  
   - Execute `example_MK.mat` (in the `mfcc/` folder).  
   - This script processes all `.wav` files in `audio/` and generates CSV feature summaries in the `output/MFCC_summary/` folder.  
   - Note: `example_MK.mat` is a **modified version** of pre-existing MFCC MATLAB code (see attribution below).  

3. **Generate plots in R**  
   - Run `extract_mfcc_feature_vectors.R` (in the `output/` folder).  
   - This script reads the CSV outputs and produces line plots with error bars for each audio file, saved in `output/MFCC_plots/`.  

---


---

## Example Output
The R plotting script produces **line plots with error bars** (± SEM) for MFCC features 1–12.  

*(Example: see files in `output/MFCC_plots/` after running the workflow.)*  

---

## Attribution & License
- The MFCC MATLAB scripts are derived from code by **Kamil Wojcicki (2011)**, distributed under a BSD-style license (see `mfcc/LICENSE.txt`).  
- `example_MK.mat` is a **modified version** of this original code to allow batch processing of multiple `.wav` files.  
- The R script `extract_mfcc_feature_vectors.R` was written by **Minah Kim** to generate statistical summaries and plots from MATLAB outputs.  



