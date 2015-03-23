function Sim = simrank(W,indexA,indexB,par)
% Input:  W is adjacency matrix
%         indexA is the index of node A (the indexA th row or column of A)
% Output: Sim: the similarity between node A and B

temp=sum(W,2);
indx=find(temp==0);
temp(indx)=1;
S=diag(temp);    
T=S\W;          %Markov Matrix


%Set constants
C=0.8;    % Decay factor
K=par.clnum;      % Number of iterations
Sim=0;    % Initial value of Sim

%Q£ºthe indexA th row, indexB th column is 1
[N N]=size(W);
Qk=sparse(indexA,indexB,1,N,N); 

%Compute similarity
for k=1:K  
    
    [r,c,v]=find(Qk);     %  When K=1£¬r/c must be indexA/indexB
    n=nnz(Qk);  
      
    j=1:n;
    newV=sparse(j,j,v(j)');         
    QkTemp=T(r(j),:)'*(newV*T(c(j),:));      %Compute Qk^ab
    
    Mk=(C.^k)*sum(diag(QkTemp));
    Sim=Sim+Mk;   
    
    % Set diagonal entries of Qk as 0, for next iteration
    q=diag(diag(QkTemp));  % Get diagonal entries to form a diagonal matrix 
    Qk=QkTemp+(-1)*q;  % Set diagonal entries as 0
    
end