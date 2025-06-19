% 图像处理程序 - extract_rgb_hex.m 
% 提取图片的RGB信息并以16进制格式保存为文件供Verilog读取 
 
clear all; 
close all; 
 
% 读取图像文件 
img = imread('00460.jpg');  % 替换为您的测试图像 
[height, width, channels] = size(img); 
 
% 确保图像是RGB格式 
if channels ~= 3 
    error('输入图像必须是RGB格式'); 
end 
 
% 调整图像大小为360x240（如果需要） 
if height ~= 240 || width ~= 360 
    img = imresize(img, [240, 360]); 
    [height, width, channels] = size(img); 
    disp('图像已调整为360x240分辨率'); 
end 
 
% 创建输出文件 
fid = fopen('rgb_data_hex.txt', 'w'); 
 
% 逐像素写入16进制RGB值 
for y = 1:height 
    for x = 1:width 
        r = img(y, x, 1); 
        g = img(y, x, 2); 
        b = img(y, x, 3); 
        
        % 将RGB值组合为24位16进制数（格式：RRGGBB）
        hex_value = sprintf('%02X%02X%02X', r, g, b);
        
        % 写入文件（每行一个像素的16进制值）
        fprintf(fid, '%s\n', hex_value); 
    end 
end 
 
% 关闭文件 
fclose(fid); 
 
disp(['已成功提取RGB数据，共', num2str(height*width), '个像素点']); 
disp('数据已保存到rgb_data_hex.txt文件中'); 
 
% 显示原始图像 
figure; 
imshow(img); 
title('原始图像'); 