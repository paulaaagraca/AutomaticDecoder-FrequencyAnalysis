%_________________________________
%_______Author: Paula Gra?a_______
%____________04/2018______________
%_________________________________

clc
clear
N=512;

% aproximate frequency interval
lowfreq = [650 733 811 897 1000]; 
highfreq = [1000 1273 1407 1515];

% tone frequency dictionaries 
dic_low = [697 770 852 941];    
dic_high = [1209 1336 1477];

% digited numbers
tele = [1,2,3; 4,5,6; 7,8,9; 11,0,12];    % '*' = 11; '#' = 12

[signal, fs] = audioread('dtmf3.wav');
fN=fs/2;    % Nyquist frequency

playout = audioplayer(signal,fs);
play(playout);

figure(1)
plot (signal)
title('Signal')
xlabel('Time')
ylabel('Magnitude')

% 12 column matrix of the signal (stable part of the signal segments)
x = [signal(950:1450), signal(2100:2600), signal(3150:3650), signal(4200:4700), signal(5250:5750), signal(6350:6850), signal(7400:7900), signal(8500:9000), signal(9600:10100), signal(10600:11100), signal(11750:12250), signal(12800:13300)];

fprintf('The telephone number is: ')
% 12 digit identification
for k = 1:12
    X = fft(x(:,k),N);
    f = fN*linspace(0,1,N/2);
    d = abs(X(1:N/2));
   
    [maximo,MaxFreq]=findpeaks(d,'MinPeakProminence', 20);
    maxs = MaxFreq*(fs/N);
    maxs = round(maxs, 0);   %round to units(0)

    low=0;
    high=0;

    % test aproximate frequency interval
    for j=1:4
        for i=lowfreq(j):lowfreq(j+1)
            % correspondent in real frequency dictionary
            if i == maxs(1)
                low = dic_low(j);
                line = j;
                break;
            end
            i=i+1;
        end
        if j < 4
            for i=highfreq(j):highfreq(j+1)
                % correspondent in real frequency dictionary
                if i == maxs(2)
                    high = dic_high(j);
                    column = j;
                    break;
                end
                i=i+1;
            end
        end
    end
    
    t = tele(line, column);
    if t == 11      %in case of '*' --> char
        t='*';
        fprintf('%c ',t)
    elseif t == 12  %in case of '#' --> char
        t='#';
        fprintf('%c ',t)
    else 
        fprintf('%d ',t)    %in case of int
    end
end

figure(2)
plot(f,d)
title('Example of FFT (last tone)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

fprintf('\n')