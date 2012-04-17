close all;
clear all;
clc;
 
% reading the image file
A=floor(imread('plane.png')/64);
 
%converting the matrix into an array
file=zeros(1,65536);
for i=1:256
    file((256*(i-1)+1):(256*i))=floor(A(i,:));
end
 
%calcultaing the probabilites
file2=sort(file);
H=zeros(2,5);
j=0;
for i=1:65536
    if(file2(i)==j)
        H(1,j+1)=H(1,j+1)+1;
    else
        j=j+1;
        H(1,j+1)=H(1,j+1)+1;
    end
end
% Assigning codes to the 5 levels
for i=1:5
    H(2,i)=i-1;
end
[x,y]=sort(H(1,:));
C=zeros(5,5);
C(:,1)=y(1,:)-1;
C(1,2:end)=[1 1 1 1];
C(2,2:end)=[1 1 1 0];
C(3,2:end)=[1 1 0 9];
C(4,2:end)=[1 0 9 9];
C(5,2:end)=[0 9 9 9];
 
% the code sequence
encode=9;
for i=1:65536
    for j=1:5
        if(file(i)==C(j,1))
            break;
        end
    end
    for k=2:5
        if(C(j,k)~=9)
            encode=[encode C(j,k)];
        end
    end
end
encode=encode(2:end);
 
% decoding the sequence
i=0;
dCode=0;
for j=1:length(encode)
    if(encode(j)==1)
        i=i+1;
    else
        dCode=[dCode C(5-i,1)];
        i=0;
    end
    if(i==4)
        dCode=[dCode C(5-i,1)];
        i=0;
    end
end
dCode=dCode(2:end);
 
%converting the decoded array into image matrix
IM=zeros(256,256);
for i=1:256
    IM(i,:)=dCode((256*(i-1)+1):(256*i));
end
IM=IM*64;
% writing the image to file
imwrite(IM,'planenoise.png');
 
% adding awgn noise to the encoded sequence
noise=awgn(encode,1);
 
% converting the resultant sequence back to binary sequence
encode2=zeros(1,length(encode));
for i=1:length(encode)
    if noise(i)>0.5
        encode2(1,i)=1;
    else
        encode2(1,i)=0;
    end
end
 
% decoding the corrupted sequence
i=0;
k=1;
dCode2=4*ones(1,65536);
for j=1:length(encode2)
    if(encode2(j)==1)
        i=i+1;
    else
        dCode2(1,k)=C(5-i,1);
        k=k+1;
        i=0;
    end
    if(i==4)
        dCode2(1,k)=C(5-i,1);
        k=k+1;
        i=0;
    end
end
 
% writing the corrupted array into image
%converting the decoded array into image matrix
IM=zeros(256,256);
for i=1:256
    IM(i,:)=dCode2((256*(i-1)+1):(256*i));
end
IM=IM*64;
% writing the image to file
imwrite(IM,'planere.png');
