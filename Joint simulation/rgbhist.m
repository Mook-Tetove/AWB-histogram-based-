function [H_R,H_G,H_B]=rgbhist(img)
% 求rgb色域空间各分量的直方图
img=double(img);
sumRGB=sum(img,3);
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);

r=R./(sumRGB+0.001);
g=G./(sumRGB+0.001);
b=B./(sumRGB+0.001);


rr=round(255*r);
gg=round(255*g);
bb=round(255*b);

H_R = zeros(1, 256);
for i = 1:numel(rr)
    val = rr(i);
    if val >= 0 && val <= 255
        H_R(val + 1) = H_R(val + 1) + 1;
    end
end

H_G = zeros(1, 256);
for i = 1:numel(gg)
    val = gg(i);
    if val >= 0 && val <= 255
        H_G(val + 1) = H_G(val + 1) + 1;
    end
end

H_B = zeros(1, 256);
for i = 1:numel(bb)
    val = bb(i);
    if val >= 0 && val <= 255
        H_B(val + 1) = H_B(val + 1) + 1;
    end
end
end