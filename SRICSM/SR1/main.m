%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ֱ����ؽ�
%����:Ҧ��
%��Ϊ�ĸ����֣�ͼ����׼������ɢ������ͼ���ؽ���ͼ���������ۺ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ȡͼƬ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder=uigetdir('','��ѡ������ͼ���ļ���');
img=readimage(folder);%img�Ǽ���ͼ��ɵ�
geshu=length(img); 
[m,n,~]=size(img{1});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ȡ����ɢ�������в���һ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%deblur���ֻ�ܴ���800*800��С��ͼ��
factor=2;
%%%%%˫���Բ�ֵ����ԭ��factor��%%%%%%
pic_bilinear{1}=imresize(img{1},factor,'bilinear');
[mm,nn,q]=size(pic_bilinear{1});
folder=uigetdir('','��ѡ�����е���ɢ�����ļ���');%�������е���ɢ�����ļ���
psf=readimage(folder);%img�Ǽ���ͼ��ɵ�   
w=normal(psf,geshu);%��һ��
[row,col]=size(w{1});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ͼ����׼%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ɵ�����disrRatio(0.3-0.9��Ĭ��0.49),alpha��0.1-1.5��Ĭ��0.2��,num=(4-100,Ĭ��50)��
%        Jy=4000(1000-10000);
%%%%%%%%%%%%%%�Ҷ�ͼ����%%%%%%%%%%%%%%%%%
img1=x3gray(img,geshu,q);%img1�Ǽ���ͼ�ĻҶ�ͼ,��ɻҶ�ͼ
%%%%%%%%%%%%SIFT�㷨��ȡ������%%%%%%%%%%
image=cell(1,geshu);
des=cell(1,geshu);
loc=cell(1,geshu);
for ii=1:geshu
    [image{ii},des{ii},loc{ii}]=ysift(img1{ii},ii);    
end 
%%%%%%%%%%%%%%������ƥ��%%%%%%%%%%%
locmatch=cell(1,geshu);
distRatio = 0.49;
%figure;  
parfor ii=1:geshu 
    [c,num]=rymatch(des{1},des{ii},distRatio);  
fprintf('Found %d ymatches.\n', num);
locmatch{ii}{1}=loc{1}(c(1,:),:); 
locmatch{ii}{2}=loc{ii}(c(2,:),:);
end
%%%%%%%%%%%%%%������ǶȲ�ֱ��ͼ%%%%%%%%%%%
agl=cell(1,geshu);%agl�ǽǶȲ�
parfor ii=1:geshu
    [agl{ii},aglocal]=yangle(locmatch{ii}{1},locmatch{ii}{2});
    locmatch{ii}{1}=locmatch{ii}{1}(aglocal,:); 
    locmatch{ii}{2}=locmatch{ii}{2}(aglocal,:);
end
%%%%%%%%%%%%%%%%%%%������ɸѡ%%%%%%%%%%%%%%%%
%���սǶ�ɸѡ������
%figure;
alpha=0.5;num=50;
parfor ii=1:geshu 
    opt=yoptIndex(agl{ii},num);
    locmatch{ii}{1}=locmatch{ii}{1}(opt,:);
    locmatch{ii}{2}=locmatch{ii}{2}(opt,:);
end
%%%%%%%%%%%%%%%%%��T%%%%%%%%%%%%%%%%%%%%%%%%%
T=cell(1,geshu);
loc2new=cell(1,geshu);%loc2new����׼ͼ���T�Ľ��
parfor ii=2:geshu
    [T{ii},loc2new{ii}]=rac2(locmatch{ii}{2},locmatch{ii}{1});%%%t=inv(a)*b;
end
T{1}=[1 0 0;0 1 0;0 0 1];
%%%%%%%˫���Բ�ֵ,��֤��׼�Ƿ���ȷ�������ȷ�ɼ���ִ��%%%%%%%%%%%%%

%gray=cell(1,geshu);
%gray{1}=rgb2gray(img{1});
%num=cell(1,geshu);
%imgn=cell(1,geshu);
%for ii=2:geshu
%[imgn{ii},num{ii}]=yytwo2(img{ii},T{ii},gray{1});%%������������׼ͼ��
%gray{ii}=rgb2gray(imgn{ii});
%figure;imshow(gray{ii}); 
%figure;imshowpair(img{1},imgn{ii});
%cha{ii}=uint8(abs(double(gray{ii})-double(gray{1})));%%%%����ͼ��Ĳ���Ƿ���׼
%figure;imshow(cha{ii});title(num2str(ii));
%end
%imgn{1}=img{1};
%%%%%%%%%%%%%%%%%����֡���%%%%%%%%%%%%%%%%%%%%%
%Jy=4000;
%for ii=2:8
%     if num{ii}>Jy %���þ�ȷ�ٷֱȣ���Ϊ1000/(1000*1000),��ȷ����ǧ��֮һ
%         w{ii}=[];
%         img{ii}=[];
%         T{ii}=[];
%     end
%end
%id=cellfun('isempty',w);%ȥ���վ��󡣼�ȥ�����õ�֡
%w(id==1)=[];
%img(id==1)=[];
%T(id==1)=[];
%geshu=length(img); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ؽ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FirsrHD,r]=deconvblind(pic_bilinear{1},w{1});%ȥ�����֤
len=(row-1)./2;
iters=3;%��������
derta=2;
[picture,factor]=pocsbilinear2(FirsrHD,T,img,iters,w,len,derta,factor);
%[picture]=pocsbilinear(FirsrHD,T,img,iters,w,len,derta,factor);
%figure;imshow(picture);
%imwrite(picture,'finally1.bmp')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ȥ������ɢ�����ı�Ե%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
high=nn-len*2-1;
width=mm-len*2-1;
finally=imcrop(picture,[len+1 len+1 high width]);
%figure;imshow(finally);
imwrite(finally,'finally_new.bmp')


 
