function histogram_matching_awb_with_visualization(img)
    % 基于直方图匹配的自动白平衡程序，包含可视化

    % 获取图像尺寸
    [H, W, ~] = size(img);
    
    % 分离RGB通道
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    
    % 步骤1: 计算RGB通道的直方图 H_R[i], H_G[i], H_B[i]
    H_R = zeros(256, 1);
    H_G = zeros(256, 1);
    H_B = zeros(256, 1);

    for i = 0:255
        % 计算R通道中像素值等于i的数量
        count_R = 0;
        for x = 1:W
            for y = 1:H
                if R(y, x) == i
                    count_R = count_R + 1;
                end
            end
        end
        H_R(i+1) = count_R / (W * H);
        
        % 计算G通道中像素值等于i的数量
        count_G = 0;
        for x = 1:W
            for y = 1:H
                if G(y, x) == i
                    count_G = count_G + 1;
                end
            end
        end
        H_G(i+1) = count_G / (W * H);
        
        % 计算B通道中像素值等于i的数量
        count_B = 0;
        for x = 1:W
            for y = 1:H
                if B(y, x) == i
                    count_B = count_B + 1;
                end
            end
        end
        H_B(i+1) = count_B / (W * H);
    end
    
    % 步骤2: 计算RGB通道的累积直方图 S_R, S_G, S_B
    S_R = zeros(256, 1);
    S_G = zeros(256, 1);
    S_B = zeros(256, 1);
    
    for c = 0:255
        % 计算R通道从0到c的累积直方图
        sum_R = 0;
        for i = 0:c
            sum_R = sum_R + H_R(i+1);
        end
        S_R(c+1) = sum_R;
        
        % 计算G通道从0到c的累积直方图
        sum_G = 0;
        for i = 0:c
            sum_G = sum_G + H_G(i+1);
        end
        S_G(c+1) = sum_G;
        
        % 计算B通道从0到c的累积直方图
        sum_B = 0;
        for i = 0:c
            sum_B = sum_B + H_B(i+1);
        end
        S_B(c+1) = sum_B;
    end
    
    % 步骤3: 使用G通道的累积直方图作为参考，计算转换函数 Z_R = S_G^(-1)(S_R)
    Z_R = zeros(256, 1);
    Z_B = zeros(256, 1);
    
    for i = 1:256
        % 对于R通道的每个灰度级，找到最接近的S_G值
        min_diff_R = 1.0;
        idx_R = 1;
        
        for j = 1:256
            diff = abs(S_G(j) - S_R(i));
            if diff < min_diff_R
                min_diff_R = diff;
                idx_R = j;
            end
        end
        Z_R(i) = idx_R - 1;  % 减1是因为MATLAB索引从1开始
        
        % 对于B通道的每个灰度级，找到最接近的S_G值
        min_diff_B = 1.0;
        idx_B = 1;
        
        for j = 1:256
            diff = abs(S_G(j) - S_B(i));
            if diff < min_diff_B
                min_diff_B = diff;
                idx_B = j;
            end
        end
        Z_B(i) = idx_B - 1;  % 减1是因为MATLAB索引从1开始
    end
    
    % 步骤4: 应用映射到R和B通道，得到新的R通道与B通道
    R_new = zeros(H, W, 'uint8');
    B_new = zeros(H, W, 'uint8');
    
    for x = 1:W
        for y = 1:H
            R_new(y, x) = Z_R(R(y, x) + 1);  % 加1是因为MATLAB索引从1开始
            B_new(y, x) = Z_B(B(y, x) + 1);  % 加1是因为MATLAB索引从1开始
        end
    end
    
    % 组合通道生成输出图像
    output_img = img;
    output_img(:,:,1) = R_new;
    output_img(:,:,3) = B_new;
    
    % 计算处理后图像的直方图
    H_R_new = zeros(256, 1);
    H_G_new = zeros(256, 1);
    H_B_new = zeros(256, 1);
    
    for i = 0:255
        % 计算新R通道中像素值等于i的数量
        count_R = 0;
        for x = 1:W
            for y = 1:H
                if R_new(y, x) == i
                    count_R = count_R + 1;
                end
            end
        end
        H_R_new(i+1) = count_R / (W * H);
        
        % 计算新G通道中像素值等于i的数量
        count_G = 0;
        for x = 1:W
            for y = 1:H
                if G(y, x) == i
                    count_G = count_G + 1;
                end
            end
        end
        H_G_new(i+1) = count_G / (W * H);
        
        % 计算新B通道中像素值等于i的数量
        count_B = 0;
        for x = 1:W
            for y = 1:H
                if B_new(y, x) == i
                    count_B = count_B + 1;
                end
            end
        end
        H_B_new(i+1) = count_B / (W * H);
    end
    
    % 显示原始图像和处理后图像
    figure('Name', '基于直方图匹配的自动白平衡结果', 'NumberTitle', 'off');
    subplot(2,2,1); 
    imshow(img);
    title('原始图像');
    
    subplot(2,2,2);
    imshow(output_img);
    title('白平衡校正后');
    %读取处理后图片
    imwrite(output_img,'res2.jpg');
    
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
    
    % 显示处理后图像的RGB通道直方图
    figure('Name', '处理后图像RGB通道直方图', 'NumberTitle', 'off');
    
    subplot(3,1,1);
    bar(0:255, H_R_new, 'r');
    title('处理后R通道直方图');
    xlabel('灰度值');
    ylabel('频率');
    
    subplot(3,1,2);
    bar(0:255, H_G_new, 'g');
    title('处理后G通道直方图');
    xlabel('灰度值');
    ylabel('频率');
    
    subplot(3,1,3);
    bar(0:255, H_B_new, 'b');
    title('处理后B通道直方图');
    xlabel('灰度值');
    ylabel('频率');
    
end