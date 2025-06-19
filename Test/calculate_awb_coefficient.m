function result = calculate_awb_coefficient(image_path)
    % 读取图像
    img = imread('res2.jpg');
    
    % 获取图像尺寸
    [height, width, ~] = size(img);
    
    % 定义右下角区域的大小和位置（不靠边）
    region_size = min(height, width) / 6; % 区域大小为图像较小边长的1/6
    region_x_start = width - region_size - width/6; % 右边缘留出1/6的距离
    region_y_start = height - region_size - height/6; % 下边缘留出1/6的距离
    
    % 确保区域坐标为整数
    region_size = round(region_size);
    region_x_start = round(region_x_start);
    region_y_start = round(region_y_start);
    
    % 截取右下角区域
    region = img(region_y_start:region_y_start+region_size, ...
                region_x_start:region_x_start+region_size, :);
    
    % 分离RGB通道
    R = double(region(:,:,1));
    G = double(region(:,:,2));
    B = double(region(:,:,3));
    
    % 计算红色通道和蓝色通道的平均值
    C_ar = mean(R(:));
    C_ab = mean(B(:));
    
    % 使用公式计算C_awb
    C_awb = sqrt(C_ar^2 + C_ab^2);
    
    % 显示结果
    figure;
    
    % 显示原始图像并标记区域
    subplot(2,2,1);
    imshow(img);
    title('原始图像');
    hold on;
    rectangle('Position', [region_x_start, region_y_start, region_size, region_size], ...
              'EdgeColor', 'r', 'LineWidth', 2);
    hold off;
    
    % 显示截取的区域
    subplot(2,2,2);
    imshow(region);
    title('截取的右下角区域');
    
 % 显示计算结果的部分
subplot(2,2,[3,4]);
text(0.1, 0.7, ['红色通道均值 C_ar = ', num2str(C_ar)], 'FontSize', 12);
text(0.1, 0.5, ['蓝色通道均值 C_ab = ', num2str(C_ab)], 'FontSize', 12);
text(0.1, 0.3, ['计算结果 C_awb = sqrt(C_ar^2 + C_ab^2) = ', num2str(C_awb)], 'FontSize', 12);
axis off;
    
    % 返回计算结果
    result = C_awb;
    
    % 打印结果到控制台
    fprintf('红色通道均值 C_ar = %f\n', C_ar);
    fprintf('蓝色通道均值 C_ab = %f\n', C_ab);
    fprintf('计算结果 C_awb = %f\n', C_awb);
end