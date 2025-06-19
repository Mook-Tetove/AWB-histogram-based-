function cimg=AWBbasedHistOverlap(img,wid,minGain,maxGain,minGainG,maxGainG,interval)
% 基于rgb空间(对R/G/B归一化)直方图重叠面积最大化的自动白平衡算法

img=double(img);
% 将图像转换为双精度
dimg = zeros(size(img));
for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        for k = 1:3
            dimg(i, j, k) = double(img(i, j, k));
        end
    end
end

% 提取RGB通道
R = dimg(:,:,1);
G = dimg(:,:,2);
B = dimg(:,:,3);

% 计算增益数量
gainNum = floor((maxGain - minGain) / interval) + 1;
gainNumG = floor((maxGainG - minGainG) / interval) + 1;

% 初始化重叠面积和直方图计数
overlapNum = zeros(gainNum, gainNum, gainNumG);
countsBox = zeros(floor(256 / wid), floor(256 / wid), floor(256 / wid));

% 构建RGB三维直方图
for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        idxR = floor(R(i, j) / wid) + 1;
        idxG = floor(G(i, j) / wid) + 1;
        idxB = floor(B(i, j) / wid) + 1;
        countsBox(idxR, idxG, idxB) = countsBox(idxR, idxG, idxB) + 1;
    end
end

% 遍历增益组合
for i = 1:gainNum
    for j = 1:gainNum
        for k = 1:gainNumG
            gainR = minGain + interval * (i - 1);
            gainG = minGainG + interval * (k - 1);
            gainB = minGain + interval * (j - 1);
            rc = zeros(1, floor(256 / wid));
            gc = zeros(1, floor(256 / wid));
            bc = zeros(1, floor(256 / wid));
            for m = 0:floor(256 / wid) - 1
                for n = 0:floor(256 / wid) - 1
                    for p = 0:floor(256 / wid) - 1
                        mnpNum = countsBox(m + 1, n + 1, p + 1);
                        midR = min(255, wid * (2 * m + 1) / 2);
                        midG = min(255, wid * (2 * n + 1) / 2);
                        midB = min(255, wid * (2 * p + 1) / 2);
                        gainedSum = gainR * midR + gainG * midG + gainB * midB;
                        r = round(255 * gainR * midR / gainedSum);
                        r = min(255, max(r, 0));
                        g = round(255 * gainG * midG / gainedSum);
                        g = min(255, max(g, 0));
                        b = 255 - r - g;
                        idxR = floor(r / wid) + 1;
                        idxG = floor(g / wid) + 1;
                        idxB = floor(b / wid) + 1;
                        rc(idxR) = rc(idxR) + mnpNum;
                        gc(idxG) = gc(idxG) + mnpNum;
                        bc(idxB) = bc(idxB) + mnpNum;
                    end
                end
            end
            minHist = zeros(1, length(rc));
            for x = 1:length(rc)
                minHist(x) = min([rc(x), gc(x), bc(x)]);
            end
            overlapNum(i, j, k) = sum(minHist(floor(50 / wid) + 1:floor(120 / wid) + 1));
        end
    end
end

% 对重叠面积进行滤波
f_overlapNum = overlapNum;
r = 0;
for i = 1:gainNum
    for j = 1:gainNum
        for k = 1:gainNumG
            ilow = max(1, i - r);
            ihigh = min(gainNum, i + r);
            jlow = max(1, j - r);
            jhigh = min(gainNum, j + r);
            klow = max(1, k - r);
            khigh = min(gainNumG, k + r);
            block = overlapNum(ilow:ihigh, jlow:jhigh, klow:khigh);
            f_overlapNum(i, j, k) = sum(block(:)) / ((ihigh - ilow + 1) * (jhigh - jlow + 1) * (khigh - klow + 1));
        end
    end
end

% 找到最大重叠面积的增益组合
maxOverlapIdx = 0;
maxOverlapValue = -1;
for i = 1:numel(f_overlapNum)
    if f_overlapNum(i) > maxOverlapValue
        maxOverlapValue = f_overlapNum(i);
        maxOverlapIdx = i - 1;
    end
end


% 计算最佳增益
gainR = minGain + interval * mod(maxOverlapIdx, gainNum);
gainB = minGain + interval * floor(mod(maxOverlapIdx, gainNum^2) / gainNum);

% 应用增益并生成最终图像
cR = gainR * R;
cG = G; % 直接使用原始G通道
cB = gainB * B;

cimg = zeros(size(dimg));
for i = 1:size(dimg, 1)
    for j = 1:size(dimg, 2)
        cimg(i, j, 1) = cR(i, j);
        cimg(i, j, 2) = cG(i, j);
        cimg(i, j, 3) = cB(i, j);
    end
end
cimg = uint8(cimg);