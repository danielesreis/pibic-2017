% preprocess('keywords')
% '[] Loop...'
% 'Abs       [Absolute Value]'
% 'arithmetic       [Arithmetic Operation]'
% 'Autoscale'
% 'baseline       [Baseline (Automatic Weighted Least Squares)]'
% 'whittaker       [Baseline (Automatic Whittaker Filter)]'
% 'simple baseline       [Baseline (Specified points)]'
% 'blockvariance       [Block Variance Scaling]'
% 'classcenter       [Class Center]'
% 'classcentroid       [Class Centroid Centering]'
% 'classcentroidscale       [Class Centroid Centering and Scaling]'
% 'derivativecolumns       [Column-wise Derivative]'
% 'derivative       [Derivative (SavGol)]'
% 'Detrend'
% 'eemfilter       [EEM Filtering]'
% 'emsc       [EMSC (Extended Scatter Correction)]'
% 'EPO       [EPO Filter]'
% 'gapsegment       [Gap Segment Derivative]'
% 'GLog'
% 'GLS Weighting'
% 'gscale       [Group Scale]'
% 'haar       [Haar Transform]'
% 'holoreact       [Kaiser HoloReact Method]'
% 'logdecay       [Log Decay Scaling]'
% 'Log10'
% 'Mean Center'
% 'Median Center'
% 'msc       [MSC (mean)]'
% 'msc_median       [MSC (median)]'
% 'Centering       [Multiway Center]'
% 'Scaling       [Multiway Scale]'
% 'Normalize'
% 'osc       [OSC (Orthogonal Signal Correction)]'
% 'pareto       [Pareto (Sqrt Std) Scaling]'
% 'sqmnsc       [Poisson (Sqrt Mean) Scaling]'
% 'PQN'
% 'referencecorrection       [Reference/Background Correction]'
% 'smooth       [Smoothing (SavGol)]'
% 'SNV'
% 'trans2abs       [Transmission to Absorbance (log(1/T))]'
% 'specalign       [Variable Alignment]'
% 'autoscalenomean       [Variance (Std) Scaling]'

% ah = xlsread('Syraz3.xlsx', 'C2:AZB289');
% abs = xlsread('Syraz3.xlsx', 'D2:AZB289');
% qua = xlsread('Syraz3.xlsx', 'C2:C289');

% abs = ah(1:288,2:1353);
% qua = ah(1:288,2);

% x = DataMatrix(1:288,2:1352);
% y = DataMatrix(1:288,1);

% saida = median_filter(x, 7);
% saida2 = moving_average(x, 7);

%saida = medfilt1(x,3);

%dataosc = preprocess('calibrate', 'osc', abs, qua);

%ihu = medfilt1(abs', 2);
% aha = filter(b, 1, abs);

x = ah(1:288, 3:1353);
y = ah(1:288, 1);

%%%funcionando
%[y_hat, D] = savgol(x,7,2,1);
%[y_hat2, D] = savgol(abs,21,2,2);
% [y_hat3, D] = savgol(abs,21,2,1);
% [y_hat4, D] = savgol(abs,21,2,2);

datap2 = preprocess('calibrate', 'SNV', x);
datap3 = preprocess('calibrate', 'msc', x);
