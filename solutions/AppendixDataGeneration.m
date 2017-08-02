clc
clear
close all
for f=1:10
    x = (-3*pi:.01:3*pi);
    noise = 0.3.*randn(1,size(x,2));
    data = cos(x) + noise;
    length=size(data,2);
    dt=0;
    time=zeros(length,1);
    for i=1:length,
        time(i,1)=dt;
        dt=dt+0.1;
    end
    array(:,1)=time();
    array(:,2)=data();
    filename=strcat('tutorial-',num2str(f),'.dat');
    delete(filename)
    dlmwrite(filename,array,'\t')
end
