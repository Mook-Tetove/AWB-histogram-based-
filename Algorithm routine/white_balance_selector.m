function white_balance_selector()
% 自动白平衡处理模式选择器
% 输入: img0_path - 图像路径
% 根据RGB直方图分析选择合适的白平衡处理方法

% 读取图像
img = imread('04380.jpg'); 

% 步骤1: 调用rgbhist.m获取RGB通道直方图
[H_R, H_G, H_B] = rgbhist(img);

% 步骤2: 设定阈值
sat_thrb = 0.8; % R和G通道像素值被定义为高亮饱和像素的下界限
h_thg = 0.75;    % G通道像素值被定义为高明度像素的下界限

% 步骤3: 判断条件
% 计算高亮饱和像素数量
sat_sumr = sum(H_R(round(sat_thrb*255):255));
sat_sumb = sum(H_B(round(sat_thrb*255):255));
% 计算G通道高明度像素数量
h_sumg = sum(H_G(round(h_thg*255):255));

% 显示分析结果
fprintf('R通道高亮饱和像素数量: %d\n', sat_sumr);
fprintf('B通道高亮饱和像素数量: %d\n', sat_sumb);
fprintf('G通道高明度像素数量: %d\n', h_sumg);

% 步骤4: 根据条件选择处理方法
if (sat_sumr > h_sumg) || (sat_sumb > h_sumg)
    % 条件成立，使用直方图平移法
    fprintf('选择直方图平移法进行白平衡处理\n');
    run_awbbasedhistoverlap(img);
else
    % 条件不成立，使用直方图匹配法
    fprintf('选择直方图匹配法进行白平衡处理\n');
    histogram_matching_awb_with_visualization(img);
end

