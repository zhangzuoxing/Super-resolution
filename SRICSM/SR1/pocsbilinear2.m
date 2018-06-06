
function [picture,factor]=pocsbilinear2(picture,T,img,iters,w,len,derta,factor)
%picture1为双线性插值，picture为重建

[m1, n1 , ~]=size(img{1});
[m, n, q]=size(picture);
picture=double(picture);
geshu=length(img);
%img1=cell(1,geshu);

%MaxError=10;
for ii=1:geshu
    img{ii}=double(img{ii});
end
%%%%%%%%放大矩阵%%%%%%%%%
F=[factor 0 0;0 factor 0;0 0 1];
%F=[factor 0 1-factor;0 factor 1-factor;0 0 1];
%%%%%%%%%%%%%%%%%%%%%%三层%%%%%%%%%%%%%%%%%%%%%
% ww=sum(sum(w.*w));%*代表矩阵乘，.*代表数组乘
 h=waitbar(0,'waiting','WindowStyle','modal');
 low=zeros((m-len),(n-len),q);
 fnew1=low;
for iter=1:iters
    disp(iter);
    waitbar(iter/iters,h,( 'processing'));
for p=1:length(img)
     ww=sum(sum(w{p}.*w{p}));%*代表矩阵乘，.*代表数组乘
  for i=1+len:m-len
    for j=1+len:n-len
          pix=(F*T{p})\[i;j;1];%高分辨率坐标映射到低分辨率坐标；
          
          if pix(1)>=1&&pix(1)<=m1&&pix(2)>=1&&pix(2)<=n1
                  float_Y=pix(1)-floor(pix(1)); 
                  float_X=pix(2)-floor(pix(2));  
                  
                  pix_up_left=[floor(pix(1)) floor(pix(2))];          %四个相邻的点
                  pix_up_right=[floor(pix(1)) ceil(pix(2))];
                  pix_down_left=[ceil(pix(1)) floor(pix(2))];
                  pix_down_right=[ceil(pix(1)) ceil(pix(2))]; 
        
                  value_up_left=(1-float_X)*(1-float_Y);              %计算临近四个点的权重
                  value_up_right=float_X*(1-float_Y);
                  value_down_left=(1-float_X)*float_Y;
                  value_down_right=float_X*float_Y;
                for z=1:q                                      
                  low(i,j,z)=value_up_left*img{p}(pix_up_left(1),pix_up_left(2),z)+ ...
                                        value_up_right*img{p}(pix_up_right(1),pix_up_right(2),z)+ ...
                                        value_down_left*img{p}(pix_down_left(1),pix_down_left(2),z)+ ...
                                        value_down_right*img{p}(pix_down_right(1),pix_down_right(2),z);
              
                b=picture(i-len:i+len,j-len:j+len,z);
                fnew1(i,j,z)=sum(sum(w{p}.*b));
                R=low(i,j,z)-fnew1(i,j,z);
               if R>derta 
                           picture(i,j,z)=picture(i,j,z)+(R-derta).*w{p}(len+1,len+1)./ww;
               else if R<-derta 
                           picture(i,j,z)=picture(i,j,z)+(R+derta).*w{p}(len+1,len+1)./ww;
                   else 
                           picture(i,j,z)=picture(i,j,z);
                   end
               end

               end
          end
     end
  end
  picture(picture<0)=0;
  picture(picture>255)=255;
end
end
close(h);
picture=uint8(picture);

