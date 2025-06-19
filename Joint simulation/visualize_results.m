% 清空工作区和命令窗口
clear;
clc;

% 设置图形窗口
figure('Name', '原始图像与处理后图像分析', 'Position', [100, 100, 1200, 600]);

% 读取原始图像
try
    img1 = imread('111.jpg');
    
    % 显示原始图像
    subplot(2, 4, 1);
    imshow(img1);
    title('原始图像');

    % 分离RGB通道
    R1 = img1(:,:,1);
    G1 = img1(:,:,2);
    B1 = img1(:,:,3);
    
    % 显示R通道直方图
    subplot(2, 4, 2);
    histogram(R1(:), 0:255, 'FaceColor', 'r');
    title('R通道直方图');
    xlim([0 255]);
    grid on;
    
    % 显示G通道直方图
    subplot(2, 4, 3);
    histogram(G1(:), 0:255, 'FaceColor', 'g');
    title('G通道直方图');
    xlim([0 255]);
    grid on;
    
    % 显示B通道直方图
    subplot(2, 4, 4);
    histogram(B1(:), 0:255, 'FaceColor', 'b');
    title('B通道直方图');
    xlim([0 255]);
    grid on;
    
    disp('成功读取并分析原始图像');
catch
    disp('无法读取原始图像，请确保文件存在且格式正确');
end

% 读取16进制TXT文件中的RGB数据
try
    % 打开文件
    fileID = fopen('fpga_rgb.txt', 'r');
    if fileID == -1
        error('无法打开文件');
    end
    
    % 初始化RGB图像
    img2 = zeros(240, 360, 3, 'uint8');
    
    % 读取数据并构建图像
    line_count = 0;
    while ~feof(fileID)
        % 读取一行
        line = fgetl(fileID);
        if isempty(line) || ~ischar(line)
            continue;
        end
        
        % 移除可能的空格和换行符
        line = strtrim(line);
        
        % 计算当前像素的行列位置
        row = floor(line_count / 360) + 1;
        col = mod(line_count, 360) + 1;
        
        if row > 240 || col > 360
            break;
        end
        
        % 解析16进制值为RGB
        if length(line) >= 6
            r = hex2dec(line(1:2));
            g = hex2dec(line(3:4));
            b = hex2dec(line(5:6));
            
            % 存储RGB值到图像
            img2(row, col, 1) = r;
            img2(row, col, 2) = g;
            img2(row, col, 3) = b;
        end
        
        line_count = line_count + 1;
    end
    
    % 关闭文件
    fclose(fileID);
    
    % 显示从TXT构建的图像
    subplot(2, 4, 5);
    imshow(img2);
    title('从16进制TXT构建的图像');
    
    % 分离RGB通道
    R2 = img2(:,:,1);
    G2 = img2(:,:,2);
    B2 = img2(:,:,3);
    
    % 显示R通道直方图
    subplot(2, 4, 6);
    histogram(R2(:), 0:255, 'FaceColor', 'r');
    title('R通道直方图');
    xlim([0 255]);
    grid on;
    
    % 显示G通道直方图
    subplot(2, 4, 7);
    histogram(G2(:), 0:255, 'FaceColor', 'g');
    title('G通道直方图');
    xlim([0 255]);
    grid on;
    
    % 显示B通道直方图
    subplot(2, 4, 8);
    histogram(B2(:), 0:255, 'FaceColor', 'b');
    title('B通道直方图');
    xlim([0 255]);
    grid on;
    
    disp(['成功读取并分析16进制TXT文件，共处理', num2str(line_count), '个像素点']);
catch ME
    disp(['读取时出错: ', ME.message]);
end

% 保存分析结果
saveas(gcf, 'histogram_analysis_result.png');
disp('分析结果已保存为histogram_analysis_result.png');