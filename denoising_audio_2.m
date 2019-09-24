% Utilizzo pacchetto 'wcompress'

clear
close all
clc

%%%%% Parameters %%%%%
v_wname = {'bior1.1', 'bior1.3', 'bior1.5', 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8',...
    'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8',...
    'db1', 'db2', 'db3', 'db4', 'db5', 'db10',...
    'coif1', 'coif2', 'coif3', 'coif4', 'coif5'};
dim = 2^14;

% Dataset
D = strcat('Set audio/');
frm = '*.wav';
folder_dataset = strcat('Dataset/', D);
listing = dir(strcat(folder_dataset, frm));

v_SNR = 5:5:20;
Er_tab = zeros(length(v_SNR), length(listing), length(v_wname));
for i = 1:length(listing)
    str_audio = listing(i).name;
    fprintf('Audio = %s\n', str_audio)
    x = audioread(strcat(folder_dataset, str_audio));
    x = mean(x,2);
    x = transpose(x);
    x = x(1:dim);
    for w = 1:length(v_wname)
        L_max = wmaxlev(dim, v_wname{w});
        for q = 1:length(v_SNR)
            y = awgn(x,v_SNR(q),'measured');
            xden = wdenoise(y,L_max,'Wavelet',v_wname{w});
            Er_tab(q, i, w) = sum((x-xden).^2)/length(x);
        end
    end
end
% my_plot_den1D_2(Er_tab, v_SNR, v_wname, D)
% save(strcat('Out/', D, 'Den_2.mat'), 'Er_tab', 'v_SNR', 'v_wname')