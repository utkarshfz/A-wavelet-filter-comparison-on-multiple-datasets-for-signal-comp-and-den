% Utilizzo pacchetto 'wcompress'

clear
close all
clc

%%%%% Parameters %%%%%
v_wname = {'bior1.1', 'bior1.3', 'bior1.5', 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8',...
    'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8',...
    'db1', 'db2', 'db3', 'db4', 'db5', 'db10',...
    'coif1', 'coif2', 'coif3', 'coif4', 'coif5'};
dim = 1024;
L_max = 0;
for w = 1:length(v_wname)
    L_max = max(L_max, wmaxlev(dim, v_wname{w}));
end

% Dataset
D = strcat('Set audio/');
frm = '*.wav';
folder_dataset = strcat('Dataset/', D);
listing = dir(strcat(folder_dataset, frm));

v_SNR = 5:5:20;
Er_tab = zeros(L_max, length(v_SNR), length(listing), length(v_wname));
for i = 1:length(listing)
    str_audio = listing(i).name;
    fprintf('Image = %s\n', str_audio)
    x = audioread(strcat(folder_dataset, str_audio));
    x = mean(x,2);
    x = transpose(x);
    x = x(1:2^14);
    for w = 1:length(v_wname)
        L_max = wmaxlev(dim, v_wname{w});
        v_levels = 1:L_max;
        for q = 1:length(v_SNR)
            y = awgn(x,v_SNR(q),'measured');
            for l = 1:length(v_levels)
                xden = wdenoise(y,v_levels(l),'Wavelet',v_wname{w});
                Er_tab(l, q, i, w) = sum((x-xden).^2)/length(x);
            end
        end
    end
end
% my_plot_den1D(Er_tab, v_SNR, v_wname, D)
% save(strcat('Out/', D, 'Den.mat'), 'Er_tab', 'v_SNR', 'v_wname')