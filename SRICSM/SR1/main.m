%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%超分辨率重建
%作者:姚烨
%分为四个部分，图像配准，点扩散函数，图像重建，图像质量评价函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%读取图片序列%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder=uigetdir('','请选择序列图像文件夹');
img=readimage(folder);%img是几个图组成的
geshu=length(img); 
[m,n,~]=size(img{1});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%读取点扩散函数序列并归一化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%deblur软件只能处理800*800大小的图，
factor=2;
%%%%%双线性插值扩大原来factor倍%%%%%%
pic_bilinear{1}=imresize(img{1},factor,'bilinear');
[mm,nn,q]=size(pic_bilinear{1});
folder=uigetdir('','请选择序列点扩散函数文件夹');%输入序列点扩散函数文件夹
psf=readimage(folder);%img是几个图组成的   
w=normal(psf,geshu);%归一化
[row,col]=size(w{1});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%图像配准%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%可调参数disrRatio(0.3-0.9，默认0.49),alpha（0.1-1.5，默认0.2）,num=(4-100,默认50)；
%        Jy=4000(1000-10000);
%%%%%%%%%%%%%%灰度图序列%%%%%%%%%%%%%%%%%
img1=x3gray(img,geshu,q);%img1是几个图的灰度图,变成灰度图
%%%%%%%%%%%%SIFT算法提取特征点%%%%%%%%%%
image=cell(1,geshu);
des=cell(1,geshu);
loc=cell(1,geshu);
for ii=1:geshu
    [image{ii},des{ii},loc{ii}]=ysift(img1{ii},ii);    
end 
%%%%%%%%%%%%%%特征点匹配%%%%%%%%%%%
locmatch=cell(1,geshu);
distRatio = 0.49;
%figure;  
parfor ii=1:geshu 
    [c,num]=rymatch(des{1},des{ii},distRatio);  
fprintf('Found %d ymatches.\n', num);
locmatch{ii}{1}=loc{1}(c(1,:),:); 
locmatch{ii}{2}=loc{ii}(c(2,:),:);
end
%%%%%%%%%%%%%%特征点角度差直方图%%%%%%%%%%%
agl=cell(1,geshu);%agl是角度差
parfor ii=1:geshu
    [agl{ii},aglocal]=yangle(locmatch{ii}{1},locmatch{ii}{2});
    locmatch{ii}{1}=locmatch{ii}{1}(aglocal,:); 
    locmatch{ii}{2}=locmatch{ii}{2}(aglocal,:);
end
%%%%%%%%%%%%%%%%%%%特征点筛选%%%%%%%%%%%%%%%%
%按照角度筛选特征点
%figure;
alpha=0.5;num=50;
parfor ii=1:geshu 
    opt=yoptIndex(agl{ii},num);
    locmatch{ii}{1}=locmatch{ii}{1}(opt,:);
    locmatch{ii}{2}=locmatch{ii}{2}(opt,:);
end
%%%%%%%%%%%%%%%%%求T%%%%%%%%%%%%%%%%%%%%%%%%%
T=cell(1,geshu);
loc2new=cell(1,geshu);%loc2new待配准图像乘T的结果
parfor ii=2:geshu
    [T{ii},loc2new{ii}]=rac2(locmatch{ii}{2},locmatch{ii}{1});%%%t=inv(a)*b;
end
T{1}=[1 0 0;0 1 0;0 0 1];
%%%%%%%双线性插值,验证配准是否正确，如果正确可继续执行%%%%%%%%%%%%%

%gray=cell(1,geshu);
%gray{1}=rgb2gray(img{1});
%num=cell(1,geshu);
%imgn=cell(1,geshu);
%for ii=2:geshu
%[imgn{ii},num{ii}]=yytwo2(img{ii},T{ii},gray{1});%%输入矩阵与待配准图像
%gray{ii}=rgb2gray(imgn{ii});
%figure;imshow(gray{ii}); 
%figure;imshowpair(img{1},imgn{ii});
%cha{ii}=uint8(abs(double(gray{ii})-double(gray{1})));%%%%两个图像的差，看是否配准
%figure;imshow(cha{ii});title(num2str(ii));
%end
%imgn{1}=img{1};
%%%%%%%%%%%%%%%%%奇异帧检测%%%%%%%%%%%%%%%%%%%%%
%Jy=4000;
%for ii=2:8
%     if num{ii}>Jy %设置精确百分比，此为1000/(1000*1000),精确到了千分之一
%         w{ii}=[];
%         img{ii}=[];
%         T{ii}=[];
%     end
%end
%id=cellfun('isempty',w);%去除空矩阵。即去除不好的帧
%w(id==1)=[];
%img(id==1)=[];
%T(id==1)=[];
%geshu=length(img); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%重建部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FirsrHD,r]=deconvblind(pic_bilinear{1},w{1});%去卷积验证
len=(row-1)./2;
iters=3;%迭代次数
derta=2;
[picture,factor]=pocsbilinear2(FirsrHD,T,img,iters,w,len,derta,factor);
%[picture]=pocsbilinear(FirsrHD,T,img,iters,w,len,derta,factor);
%figure;imshow(picture);
%imwrite(picture,'finally1.bmp')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%去掉点扩散函数的边缘%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
high=nn-len*2-1;
width=mm-len*2-1;
finally=imcrop(picture,[len+1 len+1 high width]);
%figure;imshow(finally);
imwrite(finally,'finally_new.bmp')


 
