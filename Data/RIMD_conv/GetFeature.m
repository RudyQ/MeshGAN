function [ ] = GetFeature( srcfolder, number )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
cmdline = ['.\exe\ARAP.exe 3 ',srcfolder,' ', num2str(number)];
dos(cmdline);
tarfvt = [srcfolder,'\fv.mat'];
movefile('E:\SIGA2014\workspace\fv.mat',tarfvt);
%movefile('F:\SIGA2014\workspace\fv.mat',tarfvt);
end

