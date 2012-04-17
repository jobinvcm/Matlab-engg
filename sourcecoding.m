close all;
clear all;
clc;
 
SEQ = randsrc(1,10^5,[0 1 2 3 4 5 6 7 8 9;2^-1 2^-2 2^-3 2^-4 2^-5 2^-6 2^-7 2^-8 2^-9 2^-9]);
SEQ = sort(SEQ);
 
H=hist(SEQ)/100000; 
hist(SEQ);
disp('Actual Probabilities are:');
disp(0:9);
disp(SEQ);
 
% By Huffmann coding the codes are generated
C=zeros(10,9);
for i = 1:9
    C(i,:)=[ones(1,(i-1)) 0 9*ones(1,(9-i))];
end
C(10,:)=ones(1,9);
 
disp('The codes are');
for i=1:9
    disp([(i-1) ones(1,(i-1)) 0]);
end
disp([9 ones(1,9)]);
 
% the input number sequence is accepted
m=input('\nEnter the number whose digits are to be encoded >> ');
len=0;
while m>0
    M(len+1)=mod(m,10);
    m=floor(m/10);
    len=len+1;
end
M=fliplr(M);
 
input('');
clc;
 
disp('The message sequence:');
disp(M);
 
% the code sequence
encode=9;
for i=1:len
    for j=1:9
        if(C((M(i)+1),j)~=9)
            encode=[encode C((M(i)+1),j)];
        end
    end
end
encode=encode(2:end);
 
disp('The code sequence:');
disp(encode);
 
% adding awgn noise to the encoded sequence
noise=awgn(encode,1);
 
% converting the resultant sequence back to binary sequence
for i=1:length(encode)
    if noise(i)>0.5
        encode2(1,i)=1;
    else
        encode2(1,i)=0;
    end
end
disp('The noisy sequence:');
disp(encode2);
 
% decoding the encoded bit stream
i=0;
dCode=0;
for j=1:length(encode)
    if(encode(j)==1)
        i=i+1;
    else
        dCode=[dCode i];
        i=0;
    end
    if(i==9)
        dCode=[dCode i];
        i=0;
    end
end
dCode=dCode(2:end);
 
disp('The decoded sequence:');
disp(dCode);
 
% decoding the noisy encoded bit stream
i=0;
dCode2=0;
for j=1:length(encode2)
    if(encode2(j)==1)
        i=i+1;
    else
        dCode2=[dCode2 i];
        i=0;
    end
    if(i==9)
        dCode2=[dCode2 i];
        i=0;
    end
end
dCode2=dCode2(2:end);
 
disp('The decoded sequence from the noisy bit stream:');
disp(dCode2);

