function img=readimage(folder)
files=dir(folder);%因为dir前两个不是
a=length(files)-2;
img=cell(1,a);
for ii=1:a
    filename=fullfile(folder,files(ii+2).name);
    img{1,ii}=imread(filename);
end