# AWB-histogram-based-
 This is a white balance processing program based on histogram matching and translation (maximization of histogram area)；
 这是一个基于直方图匹配与平移的白平衡处理程序（直方图面积最大化）

## 1. 系统概述
本项目是一个完整的自动白平衡（AWB）系统，包含多种白平衡算法实现、测试框架和联合仿真验证。系统采用模块化设计，主要分为算法实现、测试验证和联合仿真三大模块。
## 2. 系统架构
### 2.1 算法模块 2.1.1 白平衡算法选择器
- 文件： `white_balance_selector.m`
- 功能：根据图像RGB直方图特征自动选择合适的白平衡处理方法
- 判断条件：
  - 基于高亮饱和像素数量
  - 基于G通道高明度像素数量
  - 自动选择直方图平移法或直方图匹配法 2.1.2 基于直方图重叠的白平衡算法
- 文件： `AWBbasedHistOverlap.m`
- 功能：基于RGB空间直方图重叠面积最大化的自动白平衡算法
- 特点：
  - 通过调整RGB增益实现白平衡
  - 使用直方图重叠度量色彩平衡程度
  - 支持参数化配置（增益范围、间隔等） 2.1.3 基于直方图匹配的白平衡算法
- 文件： `histogram_matching_awb_with_visualization.m`
- 功能：使用直方图匹配方法实现自动白平衡
- 特点：
  - 以G通道作为参考
  - 通过直方图匹配调整R和B通道
  - 包含可视化功能 2.1.4 RGB直方图计算
- 文件： `rgbhist.m`
- 功能：计算RGB各通道的归一化直方图
### 2.2 测试模块 2.2.1 AWB系数计算
- 文件： `calculate_awb_coefficient.m`
- 功能：
  - 计算图像右下角区域的AWB系数
  - 提供可视化分析
  - 输出红色和蓝色通道的均值及最终系数
### 2.3 联合仿真模块 2.3.1 RGB数据提取
- 文件： `extract_rgb.m`
- 功能：
  - 将图像RGB数据转换为16进制格式
  - 生成Verilog仿真所需的数据文件 2.3.2 结果可视化
- 文件： `visualize_results.m`
- 功能：
  - 显示原始图像和处理后图像
  - 显示RGB通道直方图
  - 保存分析结果 2.3.3 一致性测试
- 文件： `test_same.m`
- 功能：
  - 比较MATLAB和FPGA处理结果
  - 计算相关系数和均方误差
  - 生成SSIM分析

## 3. 使用流程
1. 图像预处理：
   - 使用 extract_rgb.m 将输入图像转换为仿真数据
2. 算法处理：
   - 使用 white_balance_selector.m 自动选择合适的白平衡算法
   - 根据选择结果调用相应的算法进行处理
-图像集在Source_Image文件夹为SFU图集
3. 结果验证：
   - 使用 calculate_awb_coefficient.m 计算AWB系数
   - 使用 test_same.m 进行MATLAB和FPGA结果对比
   - 使用 visualize_results.m 查看处理效果

## 4. 注意事项
1. 图像尺寸要求：
   - 默认处理尺寸为360x240
   - 如果输入图像尺寸不符，系统会自动调整
2. 参数配置：
   - AWB算法参数可在相应文件中调整
   - 直方图重叠算法的增益范围和间隔可配置
   - 直方图匹配算法的参考通道可修改
3. 数据格式：
   - FPGA仿真数据采用16进制格式
   - RGB值按RRGGBB顺序排列
   - 每个像素占一行

## 5. 系统特点
1. 算法多样性：
   - 支持多种白平衡算法
   - 具备自动算法选择功能
2. 可视化支持：
   - 提供完整的可视化工具
   - 支持中间结果分析
3. 验证完备：
   - 支持MATLAB和FPGA结果对比
   - 提供多种评估指标
4. 模块化设计：
   - 各功能模块独立
   - 便于扩展和维护

##6. 文件夹介绍
1. Algorithm routine为处理算法
2. Joint simulation为转化与硬件对比
3. Test为灰球验证
4. example为验证的两个结果以及对应的txt文档
5. Source_Image为SFU图像集

