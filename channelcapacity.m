close all;
clear all;
clc;
 
r=input('Enter the number of inputs\n>> '); % input alphabet size is entered
s=input('Enter the number of outputs\n>> '); % output alphabet size is entered
 
T=zeros(r,s);
disp('Enter the valid channel transition matrix row wise.');
for i=1:r
    for j=1:s
        T(i,j)=input('>> ');
    end
end
% Channel Transition Matrix is obtained in T;
 
Px=1/r; % probability of inputs is uniform
Hx=log2(r); % Entropy of input alphabet
 
Py=zeros(1,s); % probability values of output
for j=1:s
    for i=1:r
        Py(1,j)=Py(1,j)+T(i,j)*Px;
    end
end
 
% conditional entropy of x given y is computed using basic formula
Hxy=0;
for i=1:r
    for j=1:s
        if (T(i,j)~=0)
            Hxy=Hxy+Px*T(i,j)*log2(T(i,j)*Px/Py(1,j));
        end
    end
end
Hxy=-Hxy;
 
% Capacity = Max(H(x) - H(x/y))
C=Hx-Hxy;
 
disp('The transition matrix:');
disp(T);
disp('Capacity:');
disp(C);
 
