function w=normal(psf,geshu)
w=cell(1,geshu);
parfor ii=1:geshu
    totle=double(sum(sum(psf{ii})));
    w{ii}=double(psf{ii})/totle;
end
end