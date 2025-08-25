% EXAMPLE Simple demo of the MFCC function usage.
%
%   This script is a step by step walk-through of computation of the
%   mel frequency cepstral coefficients (MFCCs) from a speech signal
%   using the MFCC routine.
%
%   See also MFCC, COMPARE.

%   Author: Kamil Wojcicki, September 2011
% Edited by Minah Kim 2/27/21 to generate MFCC csv

    % Add path
    addpath('C:\Users\mk7kc\Desktop\mfcc\audio');
    
    % Clean-up MATLAB's environment
    clear all; close all; clc;  

    
    % Define variables
    Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels 
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
    files = dir('C:\Users\mk7kc\Desktop\mfcc\audio\*.wav');
    files = string({files.name});
  for i=1:length(files)
    wav_file = files(i);  % input audio filename 
    wav_file_short = string(extractBetween(wav_file,1,strlength(wav_file)-4));


    % Read speech samples, sampling rate and precision from file
    [ speech, fs] = audioread(wav_file); % if you do size(speech) and there's a 2 that means there are two channels of audio each with x number of samples (the first number)
    % speech = speech(:); %if you have two channels uncomment this line to
    % concatenate the samples for the two channels (i.e. samples from
    % second channel are appended after the last sample of the first
    % channel

    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );


    % Generate data needed for plotting 
    [ Nw, NF ] = size( frames );                % frame length and number of frames
    time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames 
    time = [ 0:length(speech)-1 ]/fs;           % time vector (s) for signal samples 
    logFBEs = 20*log10( FBEs );                 % compute log FBEs for plotting
    logFBEs_floor = max(logFBEs(:))-50;         % get logFBE floor 50 dB below max
    logFBEs( logFBEs<logFBEs_floor ) = logFBEs_floor; % limit logFBE dynamic range


    % Generate plots
    figure('Position', [30 30 800 600], 'PaperPositionMode', 'auto', ... 
              'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' ); 

    subplot( 311 );
    plot( time, speech, 'k' );
    xlim( [ min(time_frames) max(time_frames) ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Amplitude' ); 
    title( 'Speech waveform'); 

    subplot( 312 );
    imagesc( time_frames, [1:M], logFBEs ); 
    axis( 'xy' );
    xlim( [ min(time_frames) max(time_frames) ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Channel index' ); 
    title( 'Log (mel) filterbank energies'); 

    subplot( 313 );
    imagesc( time_frames, [1:C], MFCCs(2:end,:) ); % HTK's TARGETKIND: MFCC
    %imagesc( time_frames, [1:C+1], MFCCs );       % HTK's TARGETKIND: MFCC_0
    axis( 'xy' );
    xlim( [ min(time_frames) max(time_frames) ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Cepstrum index' );
    title( 'Mel frequency cepstrum' );

    % Set color map to grayscale
    colormap( 1-colormap('gray') ); 

    % Print figure to pdf and png files
  %  print('-dpdf', sprintf('%s.pdf', mfilename)); 
    print('-dpng', sprintf('%s.png', mfilename)); 
    
     % Write table of MFCCs to csv
     filename = sprintf('%s_all.csv',wav_file_short);
     filepath = 'C:\Users\mk7kc\Desktop\mfcc\output\MFCC_all';
     writematrix(MFCCs,fullfile(filepath,filename))
     
%     % Generate matrix of row means and SD and SEM
     MFCC_means = mean(MFCCs')';
     MFCC_sd = std(MFCCs,0,2);
     MFCC_sem = MFCC_sd/sqrt(size(MFCCs,2));
     MFCC_stats = [MFCC_means, MFCC_sd, MFCC_sem];
    filename_2 = sprintf('%s_summary.csv',wav_file_short);
     filepath_2 = 'C:\Users\mk7kc\Desktop\mfcc\output\MFCC_summary';
     writematrix(MFCC_stats,fullfile(filepath_2,filename_2))
  end
% EOF
