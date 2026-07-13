clc;clear;close

origin = [0 0 0];
% origin = [0 0 0];
iterfile1 = 'Model3_G_new_jieti.ws';
iterfile2 = 'Model2_M_new_jieti.ws';
Modelcase = 'MG';%'MG','EM'
nx=30;ny=20;nz=30; %定义中心网格个数
dx=500;dy=500;dz=200;   %定义中心网格x，y间距
depth = 6000;zblocks_origin=100;
value = 0;

switch Modelcase

    % M&G模型
    case 'MG'
   modtype = 'Linear'; 
   xblocks = ones(1,nx); yblocks = ones(1,ny); zblocks = ones(1,nz);
   xblocks = xblocks*dx; yblocks = yblocks*dy; zblocks = zblocks*dz;
   % zblocks = create_zblocks(nz, depth, zblocks_origin);
   % disp(zblocks);  
   % disp(['Total Sum: ', num2str(sum(zblocks))]); 
   % return
   % zblocks = (  300.000  300.000  300.000  300.000  400.000  400.000  400.000  500.000  500.000  500.000  600.000  ...
   %     600.000  700.000  700.000  800.000  900.000    1000.000    1000.000    1100.000    1200.000    1300.000    1400.000    ...
   %     1600.000    1700.000    1800.000    2000.000    2400.000    2900.000    3500.000    4100.000    5000.000    6000.000    ...
   %     7200.000    8600.000]);%   2500.000    3000.000    3600.000    4400.000    5400.000    6600.000    8000.000    9800.000   11900.000   14500.000   17600.000]);
   % zblocks = [10,10,10,20,20,30,30,40,50,60,70,90,100,100,200,200,200,300,300,400,500,600,800,900,1100,1400,1700,2000,2500,3000];
% EM模型（扩边）
    case 'EM'
   modtype = 'LOGE'; 
%    xblocks = ones(1,nx+12);yblocks = ones(1,ny+12);%zblocks = ones(1,nz+10);
   xblocks(1+6:nx+6) = dx; yblocks(1+6:ny+6) = dy; 
   zblocks(1:nz)=dz; 
  
   %length(z) = 28
%    zblocks = ([ 10.000  10.000  10.000  20.000  20.000  30.000  30.000  40.000  50.000  60.000  70.000  90.000    ...
%    100.000  100.000  200.000  200.000  200.000  300.000  300.000  400.000  500.000  600.000  800.000  900.000    ...
%    1100.000    1400.000    1700.000    2000.000 ]);%   2500.000    3000.000    3600.000    4400.000    5400.000    6600.000    8000.000    9800.000   11900.000   14500.000   17600.000]);


%    xblocks(1:6)=[15000 6400 3200 1600 800 400];xblocks(nx+7:nx+12)= [400 800 1600 3200 6400 15000];
%    yblocks(1:6)=[15000 6400 3200 1600 800 400];yblocks(nx+7:nx+12)= [400 800 1600 3200 6400 15000];
   xblocks(1:6)=[20000 10000 5000 3000 2000 1000];xblocks(ny+7:ny+12)= [1000 2000 3000 5000 10000 20000];
   yblocks(1:6)=[20000 10000 5000 3000 2000 1000];yblocks(ny+7:ny+12)= [1000 2000 3000 5000 10000 20000];
   zblocks(nz+1:nz+10)=[1000 2000 3000 4000 5000 5000 10000 10000 20000 40000];
%    zblocks(nz+1:nz+10)=[600 1200 2400 3000 5000 5000 10000 10000 20000 40000];
end

%M&G EM矩阵赋初值
rho1 = ones(nx,ny,nz)*value;
rho2 = rho1;

%%  MG 测试


% 地热模型（30*20*30，dxy=800m,dz=200m）
% Grav
A1 = 1.5; A2 = 1.5; A3 = 3.0; Background1 = 2.0;
% Mag
B1 = 5e-2; B2 = 5e-2; B3 = 1e-1; Background2 = 0.0;
rho1(:,:,:) = Background1;
rho2(:,:,:) = Background2;

% 断层
 for i =1:7
   rho1(11-i-2:14-i-2,9:12,i+5-2)   = A1;  %阶梯1  
   rho2(11-i:14-i,9:12,i+5)   = B1;  %阶梯1
   rho1(18+i+1:21+i+1,9: 12,i+6-3) = A2;  %阶梯2
   rho2(18+i:21+i,9:12,i+6) = B2;  %阶梯2
 end

% 盖层
rho1(13:18,7:14,12-4:16-2)=A3;
rho2(11:20,7:14,12:16)=B3;


%% 输出文件
switch Modelcase
    case 'MG'
        writeModEMFwdModel(xblocks,yblocks,zblocks(1:nz),rho1,origin,iterfile1,modtype);
        writeModEMFwdModel(xblocks,yblocks,zblocks(1:nz),rho2,origin,iterfile2,modtype);
        figure(1)
        subplot(1,2,1)
        a1(1:nx,1:nz) = rho1(1:nx,floor(ny/2),1:nz);a1 = a1';
        imagesc(a1);title('yprofile');
        colorbar;
        subplot(1,2,2)
        b1(1:nx,1:ny) = rho1(1:nx,1:ny,10);b1 = b1';
        imagesc(b1);title('zprofile');
        colorbar;

        figure(2)
        subplot(1,2,1)
        a2(1:nx,1:nz) = rho2(1:nx,floor(ny/2),1:nz);a2 = a2';
        imagesc(a2);title('yprofile');
        colorbar;
        subplot(1,2,2)
        b2(1:nx,1:ny) = rho2(1:nx,1:ny,10);b2 = b2';
        imagesc(b2);title('zprofile');
        colorbar;
    case 'EM'
        rho2(7:nx+6,7:ny+6,1:nz)=rho(1:nx,1:ny,1:nz);
        writeModEMFwdModel(xblocks,yblocks,zblocks,rho2,origin,iterfile,modtype);
        figure(1)
        subplot(1,2,1)
        a(1:nx,1:nz) = rho2(6+1:6+nx,(ny+12)/2,1:nz);a = a';
        imagesc(log10(a));title('yprofile');
        colorbar;
        subplot(1,2,2)
        b(1:nx,1:ny) = rho2(1+6:nx+6,1+6:ny+6,4);b = b';
        imagesc(log10(b));title('zprofile');
        colorbar;
end


%% --------------Function----------------
function zblocks = create_zblocks(nz, depth, zblocks_origin)  
    % create_zblocks - 创建一个自定义的 zblocks 数组  
    %  
    % 输入参数:  
    % nz               : zblocks 的总长度（整数）  
    % depth            : zblocks 的总和（实数）  
    % zblocks_origin   : zblocks 的初始值（实数）  
    %  
    % 输出参数:  
    % zblocks          : 返回的生成 zblocks 数组（整数阵列）  

    % 初始化 zblocks 数组  
    zblocks = zeros(1, nz);  
    
    % 设置初始值为最接近的 10 的倍数，且不小于 zblocks_origin  
    zblocks(1) = max(round(zblocks_origin / 10) * 10, zblocks_origin);  % 第一个值设置为 zblocks_origin 的 10 的倍数  

    % 生成剩余值并按比例增加  
    for i = 2:nz  
        ratio = 1.1 + (0.7 * rand());  % 随机生成比例在 1.1 到 1.8 之间  
        next_value = round(zblocks(i - 1) * ratio / 10) * 10;  % 计算下一个值并四舍五入为 10 的倍数  
        
        % 确保下一个值不小于 zblocks_origin  
        zblocks(i) = max(next_value, zblocks_origin);  
    end  
    
    % 确保总和为 depth  
    current_sum = sum(zblocks);  
    scaling_factor = depth / current_sum;  % 计算缩放因子  
    zblocks = round(zblocks * scaling_factor / 10) * 10;  % 按比例缩放并四舍五入为 10 的倍数  

    % 修正值以确保数组中的每个值是整数  
    zblocks(zblocks < zblocks_origin) = zblocks_origin;  % 确保没有小于 zblocks_origin 的值  

    % 最后检查，如果数组长度符合要求并且总和值不正确，进行调整  
    while sum(zblocks) ~= depth  
        if sum(zblocks) < depth  
            % 增加随机一些元素的值  
            idx = randi(nz);  
            zblocks(idx) = zblocks(idx) + 10;  % 增加 10  
        elseif sum(zblocks) > depth  
            % 减少随机一些元素的值  
            idx = randi(nz);  
            if zblocks(idx) > zblocks_origin + 10  
                zblocks(idx) = zblocks(idx) - 10;  % 减少 10  
            end  
        end  
    end  
end

