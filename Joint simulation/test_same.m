% 清空工作区和命令窗口
clear;
clc;

% 读取MATLAB处理后的图像
try
    img1 = imread('res.jpg');  % 可以根据需要修改为res2.jpg
    
    % 调整图像大小为240x360（如果需要）
    if size(img1, 1) ~= 240 || size(img1, 2) ~= 360
        img1 = imresize(img1, [240, 360]);
    end
    
    % 分离RGB通道
    R1 = img1(:,:,1);
    G1 = img1(:,:,2);
    B1 = img1(:,:,3);
    
    disp('成功读取并分析MATLAB处理后的图像');
catch ME
    disp(['无法读取MATLAB处理后的图像: ', ME.message]);
    return;
end

% 读取16进制TXT文件中的RGB数据
try
    % 打开文件
    fileID = fopen('fpga_rgb.txt', 'r');
    if fileID == -1
        error('无法打开FPGA数据文件');
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
    
    % 分离RGB通道
    R2 = img2(:,:,1);
    G2 = img2(:,:,2);
    B2 = img2(:,:,3);
    
    disp(['成功读取并分析FPGA数据文件，共处理', num2str(line_count), '个像素点']);
catch ME
    disp(['读取FPGA数据时出错: ', ME.message]);
    return;
end

% 计算直方图数据（用于后续计算）
[counts_R1, ~] = histcounts(R1(:), 0:256);
[counts_R2, ~] = histcounts(R2(:), 0:256);
[counts_G1, ~] = histcounts(G1(:), 0:256);
[counts_G2, ~] = histcounts(G2(:), 0:256);
[counts_B1, ~] = histcounts(B1(:), 0:256);
[counts_B2, ~] = histcounts(B2(:), 0:256);

% 计算直方图差异
r_diff = counts_R1 - counts_R2;
g_diff = counts_G1 - counts_G2;
b_diff = counts_B1 - counts_B2;

% 计算相关系数
r_corr = corr(double(counts_R1'), double(counts_R2'));
g_corr = corr(double(counts_G1'), double(counts_G2'));
b_corr = corr(double(counts_B1'), double(counts_B2'));

% 计算直方图均方误差 (MSE)
r_mse = mean((counts_R1 - counts_R2).^2);
g_mse = mean((counts_G1 - counts_G2).^2);
b_mse = mean((counts_B1 - counts_B2).^2);

% 计算像素差异
pixel_diff = abs(double(img1) - double(img2));

% 计算结构相似性指数 (SSIM)
[ssim_val, ssim_map] = ssim(img1, img2);

% 设置图形窗口 - 只显示三张图
figure('Name', 'MATLAB与FPGA处理结果对比', 'Position', [100, 100, 1200, 400]);

% 显示MATLAB处理后的图像
subplot(1, 3, 1);
imshow(img1);
title('MATLAB处理后的图像');

% 显示FPGA处理后的图像
subplot(1, 3, 2);
imshow(img2);
title('FPGA处理后的图像');

% 显示SSIM图
subplot(1, 3, 3);
imshow(ssim_map, []);
title('SSIM 图 (均值: 0.8139)');
colorbar;

% 在命令窗口输出结果
fprintf('\n===== 一致性分析结果 =====\n');
fprintf('R通道相关系数: %.4f\n', r_corr);
fprintf('G通道相关系数: %.4f\n', g_corr);
fprintf('B通道相关系数: %.4f\n', b_corr);
fprintf('平均相关系数: %.4f\n\n', mean([r_corr, g_corr, b_corr]));

fprintf('R通道直方图MSE: %.2f\n', r_mse);
fprintf('G通道直方图MSE: %.2f\n', g_mse);
fprintf('B通道直方图MSE: %.2f\n', b_mse);
fprintf('平均直方图MSE: %.2f\n\n', mean([r_mse, g_mse, b_mse]));

fprintf('结构相似性指数 (SSIM): %.4f\n', ssim_val);
fprintf('平均像素差异: %.2f\n', mean(pixel_diff(:)));
fprintf('最大像素差异: %.2f\n\n', max(pixel_diff(:)));

% 找出差异最大的灰度值位置
[~, r_max_diff_idx] = max(abs(r_diff));
[~, g_max_diff_idx] = max(abs(g_diff));
[~, b_max_diff_idx] = max(abs(b_diff));

fprintf('R通道差异最大的灰度值: %d\n', r_max_diff_idx-1);
fprintf('G通道差异最大的灰度值: %d\n', g_max_diff_idx-1);
fprintf('B通道差异最大的灰度值: %d\n\n', b_max_diff_idx-1);

% 一致性评估
avg_corr = mean([r_corr, g_corr, b_corr]);

if avg_corr > 0.95 && ssim_val > 0.9
    fprintf('结论: 两个图像的直方图分布高度一致\n');
elseif avg_corr > 0.8 && ssim_val > 0.7
    fprintf('结论: 两个图像的直方图分布基本一致\n');
else
    fprintf('结论: 两个图像的直方图分布存在明显差异\n');
end

% 保存分析结果
saveas(gcf, 'consistency_analysis_result.png');
disp('分析结果已保存为consistency_analysis_result.png');