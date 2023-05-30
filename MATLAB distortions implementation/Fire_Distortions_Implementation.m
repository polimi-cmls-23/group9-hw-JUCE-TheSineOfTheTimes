% HW2 CMLS 
% Group 9 : The Sine Of The Times
% In this script we implemented some of the distortion functions used in
% Fire, a multi-band distortion plug-in made with JUCE by Jerryuhoo.
%
% In particular we will refer to the file "ClippingFunctions.h" located in
% Fire/Source/DSP/ in the github repo https://github.com/jerryuhoo/Fire.
%
% Since the total number of distortion types are in total 12, we decided to
% focus only on 4, one for each sub-group in which they are divided (Soft
% Clipping, Hard Clipping, Foldback, Other).
%
% We will process a test audio "gp.wav" sample-by-sample with 4
% different distortion type that are Cubic Soft Clipping, Sausage Fattener,
% Linear Foldback and Logic Clipping
%
% Input signal is multiplicated by a factor in order to enhance the 
% distortion effect

close all
clearvars
clc
%% Load Audio
% Loading test audio
[audio,Fs] = audioread('gb.wav');
% sound(audio,Fs);

%% Compute output signals
% Prepare output vectors
cubicOutput = zeros(length(audio),1);
sausageOutput = zeros(length(audio),1);
linearOutput = zeros(length(audio),1);
logicOutput = zeros(length(audio),1);

for x=1:length(audio)
    sample = audio(x);

    sample = sample * 3; % enhancing distortion effect

    % Cubic Soft Clipping
    if(sample > 1)
        cubicSample = 2/3;
    elseif(sample < -1)
        cubicSample = -2/3;
    else
        cubicSample = sample - (sample^3)/3;
    end
    cubicSample = cubicSample * 3/2;

    % Sausage Fattener
    sausageSample = sample * 1.1;
    if (sausageSample >= 1.1)
        sausageSample = 1.0;
    elseif (sausageSample <= -1.1)
        sausageSample = -1.0;
    elseif (sausageSample > 0.9 && sausageSample < 1.1)
        sausageSample = -2.5 * sausageSample * sausageSample + 5.5 * sausageSample - 2.025;
    elseif (sausageSample < -0.9 && sausageSample > -1.1)
        sausageSample = 2.5 * sausageSample * sausageSample + 5.5 * sausageSample + 2.025;
    end

    % Linear Foldback
    if(sample > 1 || sample < -1)
        linearSample = abs(abs(fmod(sample - 1,4)) - 2) - 1;
    else
        linearSample = sample;
    end

    % Logic Clipping
    logicSample = 2/(1 + exp(-2*sample)) - 1;

    % Output 
    cubicOutput(x) = cubicSample;
    sausageOutput(x) = sausageSample;
    linearOutput(x) = linearSample;
    logicOutput(x) = logicSample;
end

%% Plot results
t = 0:1/Fs:(length(audio)-1)/Fs;

fig = figure;
%plot subplots
subplot(5,1,1); 
plot(t, audio);
title("Input Audio");

subplot(5,1,2); 
plot(t, cubicOutput);
title("Cubic Soft Clipping");

subplot(5,1,3); 
plot(t, sausageOutput);
title("Sausage Fattener");

subplot(5,1,4); 
plot(t, linearOutput);
title("Linear Foldback");

subplot(5,1,5); 
plot(t, logicOutput);
title("Logic Clipping");

%common labels
ax=axes(fig,'visible','off'); 
ax.Title.Visible='on';
ax.XLabel.Visible='on';
ax.YLabel.Visible='on';
ylabel(ax,'Amplitude');
xlabel(ax,'Time [s]');

%% Write output audio signals
audiowrite("cubicSoftClipping.wav",cubicOutput,Fs);
audiowrite("sausageFattener.wav",sausageOutput,Fs);
audiowrite("linearFoldback.wav",linearOutput,Fs);
audiowrite("logicClipping.wav",logicOutput,Fs);
