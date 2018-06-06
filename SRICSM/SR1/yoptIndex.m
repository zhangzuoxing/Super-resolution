function opt=yoptIndex(agl,num)
opt=zeros(1,num);
[~,indx] = sort(abs(agl));
opt(1:num)=indx(1:num);


