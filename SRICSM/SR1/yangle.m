
function [agl,aglocal]=yangle(loc1, loc2)
  agl=loc2(:,4)-loc1(:,4);
  agl=agl*180/pi;%���ȱ�Ƕ�
  aglocal=find(agl>-180 & agl<180);%�ҵ�-180~180֮��ĽǶȵ����ꡣ 
  agl=agl(aglocal);
  %agl=agl(agl>-180);%ֻҪ����-180�ĽǶ�
  %agl=agl(agl<180);%ֻҪС��180�ĽǶ�
  %hist(agl,180);%N=hist(Y,X) ���ܣ�X����������X�е�Ԫ��Ϊ�������Ŀɻ��һϵ�����䣬ִ������ɻ��Y����Щ�����еķֲ������
  %hold on
  %set(gcf,'Color','w');
  %xlabel('Rotated Angle(��)');
  %ylabel('Number of Feature Point');
