clc;
clear all;
close all;
N = 100000; % The number of bits to send
ip = rand(1,N)>0.5; % generating 0,1 with equal probability
S = 2*ip-1; %BPSK modulation 0 -> -1; 1 -> 1
PS = sum(S.^2)/N;
h = 1/sqrt(2).*(randn(1,N) + j*randn(1,N)); %Generate a random bit stream (channel).

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Rayleigh distribution ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
for SNR = 1:30
    PN = PS*10.^-(SNR/10);
    noise = (sqrt(PN))*1/sqrt(2)*(randn(1,N) + j*randn(1,N)); % white gaussian noise, 0dB variance
    r =S.*h+noise;  %Channel and noise Noise addition (recieved vector)
    rHat = r./h; %equalization
    
    New = [];
    for i =1:N
        if real(rHat(i))>0
            New(i)=1;
        else New(i)=-1;
        end
    end
    
    c=0;
    for i = 1:N
        if New(i)~= S(i)
            c=c+1;
        end
    end
    BER(SNR)= c/N;
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ AWGN Theoretical ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
for SNR = 1:30
    PN = PS*10.^-(SNR/10);
    noise = (sqrt(PN))*1/sqrt(2)*(randn(1,N) + j*randn(1,N)); % white gaussian noise, 0dB variance
    r =S+noise;  %Channel and noise Noise addition (recieved vector)
    rHat = r; %equalization
    
    New = [];
    for i =1:N
        if real(rHat(i))>0
            New(i)=1;
        else New(i)=-1;
        end
    end
    
    c=0;
    for i = 1:N
        if New(i)~= S(i)
            c=c+1;
        end
    end
    BER2(SNR)= c/N;
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Plotting ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
SNRpp =[1:1:30];
semilogy(SNRpp,BER,'-','LineWidth',2)
xlabel('SNR (dB)');
ylabel('BER');
title('SNR Vs BER plot for BPSK Modualtion in Rayleigh Channel');

hold on;
semilogy(SNRpp,BER2,'blad-','LineWidth',2)
legend('Rayleigh distribution', 'AWGN Theoretical');
axis([0 40 10^-5 0.5]);
grid on;













