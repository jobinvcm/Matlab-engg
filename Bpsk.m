close all;
clear all;
clc;
 
% the reference carrier signal
ref=zeros(1,25);
for i=1:25
    ref(i)=sin(2*pi*(i-1)/25);
end
 
%generator matrix for systematic (15,11) cyclic Hamming code
G=[1 0 0 0 0 0 0 0 0 0 0 0 1 1 1; 
   0 1 0 0 0 0 0 0 0 0 0 1 0 1 1;
   0 0 1 0 0 0 0 0 0 0 0 1 1 0 1;
   0 0 0 1 0 0 0 0 0 0 0 1 1 1 0;
   0 0 0 0 1 0 0 0 0 0 0 1 1 1 1;
   0 0 0 0 0 1 0 0 0 0 0 1 1 0 0;
   0 0 0 0 0 0 1 0 0 0 0 1 0 1 0;
   0 0 0 0 0 0 0 1 0 0 0 1 0 0 1;
   0 0 0 0 0 0 0 0 1 0 0 0 1 1 0;
   0 0 0 0 0 0 0 0 0 1 0 0 1 0 1;
   0 0 0 0 0 0 0 0 0 0 1 0 0 1 1];
 
%parity check matrix
H=[1 1 1 0 1 0 0 1 0 1 1 0 0 0 1;
   1 1 0 1 1 0 1 0 1 0 1 0 0 1 0;
   1 0 1 1 1 1 0 0 1 1 0 0 1 0 0;
   0 1 1 1 1 1 1 1 0 0 0 1 0 0 0];
 
S=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15;
   0 14 13 11 7 15 3 5 9 6 10 12 1 2 4 8];
 
msg=zeros(1,11);
ucBER=zeros(1,7);
cBER=zeros(1,7);
for c=0:(2^11-1)
    k=c;
    for j=1:11
        msg(1,j)=mod(k,2);
        k=floor(k/2);
    end
    
    % Uncoded Transmission
    N=11;
    signal=zeros(1,N*25);
    for i=1:N
        if msg(1,i)==0
            signal(1,(25*(i-1)+1):(25*i))=ref(1,:);
        else
            signal(1,(25*(i-1)+1):(25*i))=-ref(1,:);
        end
    end
    
    for snr=0:2:12
        %adding noise
        noisy=awgn(signal,snr);
    
        %demodulating BPSK signal
        dMod=zeros(1,N);
        for j=1:N
            k=(j-1)*25;
            if (noisy(k+7)+ref(7))>1
                dMod(j)=0;
            else
                dMod(j)=1;
            end
        end
        
        k=0;
        for i=1:N
            if dMod(1,i)~=msg(1,i)
                k=k+1;
            end
        end
        ucBER(snr/2+1)=ucBER(snr/2+1)+k;
    end
    
    %----------------------------------------------------------------------
          
    %Coded Transmission
    code=zeros(1,15);
    for i=1:15
        mul=0;
        for j=1:11
            mul=mul+and(msg(j),G(j,i));
        end
        code(i)=mod(mul,2);
    end
    
    N=15;
    signal=zeros(1,N*25);
    for i=1:N
        if code(1,i)==0
            signal(1,(25*(i-1)+1):(25*i))=ref(1,:);
        else
            signal(1,(25*(i-1)+1):(25*i))=-ref(1,:);
        end
    end
    
    for snr=0:2:12
        %adding noise
        noisy=awgn(signal,snr);
    
        %demodulating BPSK signal
        dMod=zeros(1,N);
        for j=1:N
            k=(j-1)*25;
            if (noisy(k+7)+ref(7))>1
                dMod(j)=0;
            else
                dMod(j)=1;
            end
        end
        
        syndrome=0;
        
        for i=1:4
            mul=0;
            for j=1:15
                mul=mul+and(dMod(j),H(i,j));
            end
            syndrome=syndrome+mod(mul,2)*(2^(4-i));
        end
        for i =1:16
            if syndrome==S(2,i);
                syndrome=S(1,i);
                break;
            end 
        end
        error=zeros(1,15);
        if syndrome~=0
            error=[zeros(1,(syndrome-1)) 1 zeros(1,(15-syndrome))];
        end
        
        dCode=xor(dMod,error);
        dCode=dCode(1,1:11);
        k=0;
        for i=1:11
            if dCode(1,i)~=msg(1,i)
                k=k+1;
            end
        end
        cBER(snr/2+1)=cBER(snr/2+1)+k;
    end
end
 
snr=0:2:12;
 
ucBER=ucBER/((2^11)*11);
cBER=cBER/((2^11)*11);
 
figure;
grid on;
axis([0 12 0 .2]);
subplot(2,1,1),stem(snr,ucBER);
subplot(2,1,2),stem(snr,cBER);
