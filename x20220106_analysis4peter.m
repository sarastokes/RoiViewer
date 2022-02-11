%% 20220106
% - Square analysis
% --



% First, load in the raw fluorescence traces for each ROI and create a 3D matrix [R x T x N] where R is the number of ROIs, T is time and N is the number of repeats
signals = [];  % your data here


% Remove the first frame that is blank, it messes up smoothing
signals(1,:,:) = []; 

% x-axis
xpts = getX(size(signals,2), 25);
xpts(1) = [];

% I attached an S-cone dataset to check out and test the code
load('scone_dataset')
signals = scone_dataset;
% FYI First actual response is ROI 13

% Baseline frame window, you could do anything between 1 and 500
bkgdWindow = [200 400]; 

% Check the ref excel sheet for the trial for more accurate #s
stim = 0.5 * ones(1, 3275);
stim(501:1000) = 1;
stim(1001:1500) = 0;
stim(1501:2000) = 1;
stim(2001:2500) = 0;
stim(2501:3000) = 1;
stim(1) = [];  % first blank stim


% View the responses. Arrow keys change the ROI shown. Try checking Z-score since that's what we'll do below. I usually smooth the responses quite a lot (50 or 100 in the Smooth box)
app = RoiViewer(si gnals, bkgdWindow, [500 3000], stim);

% Especially if you just want to know whether you have an ON or OFF cell, you can just compare the response to the stimulus and get your answer without any extra analysis. 


%% Analysis outside the RoiViewer
% Convert response to zscores
signalsZ = zeros(size(signals));
for i = 1:size(signals, 3)
    signalsZ(:,:,i) = roiZScores(signals(:,:,i), bkgdWindow);
end

% Smooth then ask what the peak value was for each ROI during the stimulusc
signalsSmoothed = mysmooth32(signalsZ, 100);
figure(); hold on;
plot(max(mean(signalsSmoothed,3), [], 2), '-ok');
xlabel('ROIs');
ylabel('SDs');
% Anything over 2 SDs I call 'significant'
% Between 1-2 SDs is 'weak', or maybe just noise
% < 1 SD is probably not a response at all

% It's still worth checking them out with the RoiViewer, especially the 'weak' ones, bc sometimes we get those weird intensity fluctuations that aren't really a response
% e.g. ROI 75 in the S-cone dataset is a weak response, ROI 19 is probably not a real response




