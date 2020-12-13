clear; clc;

%% load audio
file = 'ShreyAudio1.wav';
[x, fs] = audioread(file);

info = audioinfo(file);
disp(info);

x = mean(x, 2); % mono

x = 0.9*x/max(abs(x)); % normalize

x = resample(x, 8000, fs);% resampling to 8kHz
fs = 8000;

w = hann(floor(0.03*fs), 'periodic'); % using 30ms Hann window
%% LPC encode 
p = 12; % using 12th order
[A, G] = encode(x, p, w);
size(A)
size(G)
%% LPC decode
xhat = decode(A, G, w);

%% compare amount of data
nSig = length(x);
disp(['Original signal size: ' num2str(nSig)]);
sz = size(A);
nLPC = sz(1)*sz(2) + length(G);
disp(['Encoded signal size: ' num2str(nLPC)]);
disp(['Data reduction: ' num2str(nSig/nLPC)]);


%% listen to resynthesized signal
% uncomment the lines below to play the estimated signal
apLPC = audioplayer(xhat, fs);
play(apLPC); 


%% save result to file
%%audiowrite(xhat, fs, ['lpc/output/lpc_breathy_' num2str(p) '.wav']);
%%audiowrite(['lpc/output/lpc_breathy_' num2str(p) '.wav'],xhat, fs);
s1 = split(file,'.');
s1 = string(s1(1,1));
%%s = strcat(s1,strcat('_',num2str(p)));
%%disp(s);
%%type s;
s = strcat(s1,strcat('_',num2str(p)));
s = strcat(s,'.wav');
audiowrite(s,xhat, fs);

info = audioinfo(s);
disp(info);