% img=imread('01.jpg');       %����vΪԭͼ��ĸ߶ȣ�uΪԭͼ��Ŀ��
% imshow(img);     %����yΪ�任��ͼ��ĸ߶ȣ�xΪ�任��ͼ��Ŀ��
function [imgn,num]=yytwo2(img,rot,img1)
[h, w, q]=size(img);
img1=double(img1);
imgn=zeros(h,w,q);
num=0;
for i=1:h
    for j=1:w
        pix=rot\[i;j;1];                                  %�ñ任��ͼ��ĵ������ȥѰ��ԭͼ�������꣬                                         
                                                               %������Щ�任���ͼ������ص��޷���ȫ���
        float_Y=pix(1)-floor(pix(1)); 
        float_X=pix(2)-floor(pix(2));    
       
        if pix(1)>=1 && pix(2)>=1 && pix(1) <= h && pix(2) <= w     
            
            pix_up_left=[floor(pix(1)) floor(pix(2))];          %�ĸ����ڵĵ�
            pix_up_right=[floor(pix(1)) ceil(pix(2))];
            pix_down_left=[ceil(pix(1)) floor(pix(2))];
            pix_down_right=[ceil(pix(1)) ceil(pix(2))]; 
        
            value_up_left=(1-float_X)*(1-float_Y);              %�����ٽ��ĸ����Ȩ��
            value_up_right=float_X*(1-float_Y);
            value_down_left=(1-float_X)*float_Y;
            value_down_right=float_X*float_Y;
               for z=1:q                                          
            imgn(i,j,z)=value_up_left*img(pix_up_left(1),pix_up_left(2),z)+ ...
                                        value_up_right*img(pix_up_right(1),pix_up_right(2),z)+ ...
                                        value_down_left*img(pix_down_left(1),pix_down_left(2),z)+ ...
                                        value_down_right*img(pix_down_right(1),pix_down_right(2),z);
                 
               end
               %a=cat(3,imgn(i,j,1),imgn(i,j,2),imgn(i,j,3));
               a=0.2989*double(imgn(i,j,1)) + 0.5870 * double(imgn(i,j,2)) + 0.1140 * double(imgn(i,j,3)); 
               cha=abs(a-img1(i,j));
               if cha>30
                   num=num+1;
               end
        end       
    end
end
imgn=uint8(imgn);