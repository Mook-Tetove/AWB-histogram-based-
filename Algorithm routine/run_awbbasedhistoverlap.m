function run_awbbasedhistoverlap(img)
%输出原图
figure,imshow(img);
%通过运行rghist函数
[H_R,H_G,H_B]=rgbhist(img);
    % 显示原始图像的RGB通道直方图
    figure('Name', '原始图像RGB通道直方图', 'NumberTitle', 'off');
    
    subplot(3,1,1);
    bar(0:255, H_R, 'r');
    title('原始R通道直方图');
    xlabel('灰度值');
    ylabel('频率');
    
    subplot(3,1,2);
    bar(0:255, H_G, 'g');
    title('原始G通道直方图');
    xlabel('灰度值');
    ylabel('频率');
    
    subplot(3,1,3);
    bar(0:255, H_B, 'b');
    title('原始B通道直方图');
    xlabel('灰度值');
    ylabel('频率');

%运行函数m文件平移白平衡处理
wbmg=AWBbasedHistOverlap(img,8,0.76,1.36,1,1,0.02);
%输出处理后的图
figure,imshow(wbmg);
%读取处理后图片
imwrite(wbmg,'res.jpg');
%运行rghist函数对于新图片
[H_R_NEW,H_G_NEW,H_B_NEW]=rgbhist(wbmg);
 % 显示处理后图像的RGB通道直方图
    figure('Name', '处理后图像RGB通道直方图', 'NumberTitle', 'off');
    
    subplot(3,1,1);
    bar(0:255, H_R_NEW, 'r');
    title('处理后R通道直方图');
    xlabel('灰度值');
    ylabel('频率');
    
    subplot(3,1,2);
    bar(0:255, H_G_NEW, 'g');
    title('处理后G通道直方图');
    xlabel('灰度值');
    ylabel('频率');
    
    subplot(3,1,3);
    bar(0:255, H_B_NEW, 'b');
    title('处理后B通道直方图');
    xlabel('灰度值');
    ylabel('频率');


end