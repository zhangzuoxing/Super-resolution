function img1=x3gray(img,geshu,q)
img1=cell(1,geshu);%img1�Ǽ���ͼ��ɵĻҶ�ͼ
if q==3
   parfor i=1:geshu       
     img1{i}=rgb2gray(img{i});
   end
else
  for i=1:geshu       
     img1{i}=img{i};
  end
end