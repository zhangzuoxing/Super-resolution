
function [agl,aglocal]=yangle(loc1, loc2)
  agl=loc2(:,4)-loc1(:,4);
  agl=agl*180/pi;%弧度变角度
  aglocal=find(agl>-180 & agl<180);%找到-180~180之间的角度的坐标。 
  agl=agl(aglocal);
  %agl=agl(agl>-180);%只要大于-180的角度
  %agl=agl(agl<180);%只要小于180的角度
  %hist(agl,180);%N=hist(Y,X) 功能：X是向量，以X中的元素为区间中心可获得一系列区间，执行命令可获得Y在这些区间中的分布情况。
  %hold on
  %set(gcf,'Color','w');
  %xlabel('Rotated Angle(°)');
  %ylabel('Number of Feature Point');
