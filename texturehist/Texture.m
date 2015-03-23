%**************************************************************************
%                   Image Retrieval - Texture Features
%Feature extraction based on cooccurrence matrix
%d=1,¦È=0¡ã,45¡ã,90¡ã,135¡ã, four matrices in total
%Intensity of imput image is between 0 and 255
%function : T=Texture(Image) 
%Image    : input image
%T        : 1-by-8 vector of texture features
%**************************************************************************
function T = Texture(Image)
M = 256; 
N = 256;

%--------------------------------------------------------------------------
%1.transform input image to grayscale image
%--------------------------------------------------------------------------
Gray = double(0.3*Image(:,:,1)+0.59*Image(:,:,2)+0.11*Image(:,:,3));

%--------------------------------------------------------------------------
%2.Compress image£¬quantize grayscale to 16 levels
%--------------------------------------------------------------------------
for i = 1:M
    for j = 1:N
        for n = 1:256/16
            if (n-1)*16<=Gray(i,j)&Gray(i,j)<=(n-1)*16+15
                Gray(i,j) = n-1;
            end
        end
    end
end

%--------------------------------------------------------------------------
%3.Compute the four cooccurrence matrices P
%--------------------------------------------------------------------------
P = zeros(16,16,4);
for m = 1:16
    for n = 1:16
        for i = 1:M
            for j = 1:N
                if j<N&Gray(i,j)==m-1&Gray(i,j+1)==n-1
                    P(m,n,1) = P(m,n,1)+1;
                    P(n,m,1) = P(m,n,1);
                end
                if i>1&j<N&Gray(i,j)==m-1&Gray(i-1,j+1)==n-1
                    P(m,n,2) = P(m,n,2)+1;
                    P(n,m,2) = P(m,n,2);
                end
                if i<M&Gray(i,j)==m-1&Gray(i+1,j)==n-1
                    P(m,n,3) = P(m,n,3)+1;
                    P(n,m,3) = P(m,n,3);
                end
                if i<M&j<N&Gray(i,j)==m-1&Gray(i+1,j+1)==n-1
                    P(m,n,4) = P(m,n,4)+1;
                    P(n,m,4) = P(m,n,4);
                end
            end
        end
        if m==n
            P(m,n,:) = P(m,n,:)*2;
        end
    end
end

%%---------------------------------------------------------
% Normalize the cooccurrence matrices
%%---------------------------------------------------------
for n = 1:4
    P(:,:,n) = P(:,:,n)/sum(sum(P(:,:,n)));
end

%--------------------------------------------------------------------------
%4.Compute power, contrast, correlation and entropy of cooccurrence
%matrices
%--------------------------------------------------------------------------
H = zeros(1,4);
I = H;
Ux = H;      Uy = H;
deltaX= H;  deltaY = H;
C =H;
for n = 1:4
    E(n) = sum(sum(P(:,:,n).^2)); %%Power
    for i = 1:16
        for j = 1:16
            if P(i,j,n)~=0
                H(n) = -P(i,j,n)*log(P(i,j,n))+H(n); %%Entropy
            end
            I(n) = (i-j)^2*P(i,j,n)+I(n);  %%Moment of Inertia
           
            Ux(n) = i*P(i,j,n)+Ux(n); %¦Ìx in Correlation
            Uy(n) = j*P(i,j,n)+Uy(n); %¦Ìy in Correlation
        end
    end
end
for n = 1:4
    for i = 1:16
        for j = 1:16
            deltaX(n) = (i-Ux(n))^2*P(i,j,n)+deltaX(n); %¦Òx in Correlation
            deltaY(n) = (j-Uy(n))^2*P(i,j,n)+deltaY(n); %¦Òy in Correlation
            C(n) = i*j*P(i,j,n)+C(n);             
        end
    end
    C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %Correlation   
end

%--------------------------------------------------------------------------
%Compute mean and standard deviation of power, entropy, moment of inertia,
%and correlation, to get the 8-dim texture feature
%--------------------------------------------------------------------------
T(1) = mean(E);   T(2) = sqrt(cov(E));
T(3) = mean(H);   T(4) = sqrt(cov(H));
T(5) = mean(I);   T(6) = sqrt(cov(I));
T(7) = mean(C);   T(8) = sqrt(cov(C));

