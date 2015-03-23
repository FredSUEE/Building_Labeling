function Isal=dolocalsaliency_demo(Iset)
Imnum=length(Iset);
for j=1:Imnum
    IRGB=Iset{j};
    %Compute frequency-tuned saliency [CVPR09]
    sm1=AchantaSaliency(IRGB);
    sm1=sm1-min(min(sm1));
    sm1=sm1/max(max(sm1));
    
    %Compute IttiKoch Saliency [IttiPAMI98]
    sm2s=IttiKochSaliency(IRGB);
    sm2=imresize(sm2s,[size(IRGB,1),size(IRGB,2)],'bicubic');
    sm2=sm2-min(min(sm2));
    sm2=sm2/max(max(sm2));
    
    %Compute Spectral residual saliency  [Hou CVPR07]
    sm3=housaliency(IRGB);
    sm3=sm3-min(min(sm3));
    sm3=sm3/max(max(sm3));
    temp=sm1+sm2+sm3;
    Isal{j}=temp/max(max(temp));
end
