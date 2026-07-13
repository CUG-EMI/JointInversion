close all;clc;clear
currentFilePath = mfilename('fullpath');mFilePath = fileparts(currentFilePath);
invFilepath = fullfile(mFilePath, 'Lp_test');
nx=30;ny=20;nz=30;

% model 1 盖层在断层之上
% md = [{'md011-L0','md011-L1','md2010-L2','md011-L12'}];
 % md = [{'md010-no','md010-AA','md010-Dep1','md010-Dep2'}];
% md = [{'mk011-L0-0-0','mk011-L1-0-0','mk011-L2-0-0','mk011-L12-0-0'}];
% md = [{'mk010-no','mk010-AA','mk010-Dep1-45-0','mk010-Dep2'}];
md = [{'md3010-no','md3010-AA','md3010-Dep1','md3010-Dep2'}];


% model 2 盖层在断层之下
% md = [{'md2010-L0','md2010-L1','md2010-L2','md2010-L12'}];
% md = [{'mk2010-L0','mk2010-L1','mk2010-L2','mk2010-L12'}];


profile = [{'y'},{'z'}];


for ii = 1:length(md)
for jj = 1:2
    fileinv_den = fullfile(invFilepath, md{ii});
    zprofile = 8;
    yprofile = 15;
    
    data = importdata(fileinv_den);
    m = 1;
    for k = 1:nz
        for j = 1:ny
            for i = 1:nx
             cross1(i,j,k) = data(m,1);
             m = m+1;
            end
        end
    end
    
    


    switch profile{jj}
         case 'y'
             a(1:nx,1:nz) = cross1(1:nx,yprofile,1:nz);a=a';     
         case 'z'
             a(1:nx,1:ny) = cross1(1:nx,1:ny,zprofile);a=a';
    end
    Aa{(ii-1)*2 + jj} = a; %Bb{(ii-1)*2 + jj} = b;
    clear a;clear b;
end
end

% boundary_xz1(:,1) = [4.5,8.5,8.5,9.5,9.5,10.5,10.5,11.5,11.5,12.5,12.5,13.5,13.5,...
%                      9.5,9.5,8.5,8.5,7.5,7.5,6.5,6.5,5.5,5.5,4.5,4.5] - 3;
% boundary_xz1(:,2) = [1.5,1.5,2.5,2.5,3.5,3.5,4.5,4.5,5.5,5.5,6.5,6.5,7.5,...
%                      7.5,6.5,6.5,5.5,5.5,4.5,4.5,3.5,3.5,2.5,2.5,1.5]; 
% boundary_xz2(:,1) = [22.5,26.5,26.5,25.5,25.5,24.5,24.5,23.5,23.5,22.5,22.5,21.5,21.5,...
%                      17.5,17.5,18.5,18.5,19.5,19.5,20.5,20.5,21.5,21.5,22.5,22.5] + 4;
% boundary_xz2(:,2) = [1.5,1.5,2.5,2.5,3.5,3.5,4.5,4.5,5.5,5.5,6.5,6.5,7.5,...
%                      7.5,6.5,6.5,5.5,5.5,4.5,4.5,3.5,3.5,2.5,2.5,1.5] ; 
boundary_xz1(:,1) = [9.5,13.5,13.5,12.5,12.5,11.5,11.5,10.5,10.5,9.5,9.5,8.5,8.5,7.5,7.5,...
                     3.5,3.5,4.5,4.5,5.5,5.5,6.5,6.5,7.5,7.5,8.5,8.5,9.5,9.5]-2;
boundary_xz1(:,2) = [5.5,5.5,6.5,6.5,7.5,7.5,8.5,8.5,9.5,9.5,10.5,10.5,11.5,11.5,12.5,...
                     12.5,11.5,11.5,10.5,10.5,9.5,9.5,8.5,8.5,7.5,7.5,6.5,6.5,5.5]-2;
boundary_xz2(:,1) = [18.5,22.5,22.5,23.5,23.5,24.5,24.5,25.5,25.5,26.5,26.5,27.5,27.5,28.5,28.5,...
                     24.5,24.5,23.5,23.5,22.5,22.5,21.5,21.5,20.5,20.5,19.5,19.5,18.5,18.5]+1;
boundary_xz2(:,2) = boundary_xz1(:,2);

boundary_xz3(:,1) = [13.5,18.5,18.5,13.5,13.5];
boundary_xz3(:,2) = [6.5,6.5,14.5,14.5,6.5];

boundary_xy1(:,1) = [3.5,7.5,7.5,3.5,3.5];
boundary_xy1(:,2) = [8.5,8.5,12.5,12.5,8.5];
boundary_xy2(:,1) = [12.5,19.5,19.5,12.5,12.5];
boundary_xy2(:,2) = [6.5,6.5,14.5,14.5,6.5];
boundary_xy3(:,1) = boundary_xy1(:,1)+20 ;
boundary_xy3(:,2) = boundary_xy1(:,2);
% boundary_xz1(:,2) = nz - boundary_xz1(:,2) -1;
% boundary_xz2(:,2) = nz - boundary_xz2(:,2) -1;

label = {'(a)', '(b)', '(c)', '(d)'}; % 标签文本
% 为第一列创建一个新的图形窗口
figure('unit','centimeters','position',[0,5,24,10]);
for ii = 1:length(md)
    row = floor((ii-1)/2); % 计算行
    col = mod(ii-1,2);     % 计算列
    subplot('Position',[0.1+col*0.45 0.6-row*0.45 0.4 0.3]); % 设置位置
    % 提高数据分辨率
    A =  Aa{ii*2-1};
    % if (ii == 2)||(ii == 3)
    % % 对数据进行归一化处理，限制在0-2范围  
    % A_normalized = (A - min(A(:))) ./ (max(A(:)) - min(A(:))) * 1.8;  
    % else
    % A_normalized = min(A, 2);
    % end
    A_normalized = A;

    % [x, y] = meshgrid(1:size(A_normalized, 2), 1:size(A_normalized, 1));  
    % [xi, yi] = meshgrid(linspace(1, size(A_normalized, 2), 30), linspace(1, size(A_normalized, 1), 24));  
    % Ai = interp2(x, y, A_normalized, xi, yi, 'cubic'); 
    Ai = A_normalized;

    Ai = min(Ai, 2.1);Ai = max(Ai, 0);
    % 导出 GRD 文件  
    xsum = linspace(0, 15, size(Ai, 2)); % 假设X轴范围是0-12 km  
    zsum = linspace(0, 6, size(Ai, 1));  % 假设深度范围是0-8 km  
    exportMatrixToGRD(Ai, fullfile(invFilepath, sprintf('XZ_slice_%d.grd', ii)), [0, xsum(end)], [0, zsum(end)]); 
     

    imagesc(Ai); colormap Jet; 
    ax(ii) = gca;
    text(ax(ii).XLim(2)*0.97, ax(ii).YLim(2)*0.97, label{ii}, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom','Color','w');
    set(ax(ii), 'TickDir', 'in');
    xticks([0.001 5 10 15 20 25 30]*2); xticklabels({'0', '2.5', '5', '7.5', '10', '12.5', '15'});
    yticks([0.001 3 6 9 12]*2); yticklabels({'0', '1.5', '3', '4.5', '6'});
    if ii == 3 || ii == 4
        xlabel('X-Distance(km)', 'FontSize', 12, 'FontWeight', 'bold');
    end
    if ii == 1 || ii == 3
        ylabel('Depth(km)','FontSize',12,'FontWeight','bold');
    end
    h = colorbar;xlabel(h, '(g/cm^3)', 'Interpreter', 'tex','Rotation', 0);
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.Label.HorizontalAlignment = 'center'; % 水平居中对齐
    h.Label.VerticalAlignment = 'bottom'; % 与colorbar顶部对齐
    h.Label.Position = [0.60, max(max(Ai))]; % 您可能需要调整这个位置
    hold on;

    plot(boundary_xz1(:, 1), (boundary_xz1(:, 2)), 'w', 'LineWidth', 2.0);
    plot(boundary_xz2(:, 1), (boundary_xz2(:, 2)), 'w', 'LineWidth', 2.0);
    plot(boundary_xz3(:, 1), boundary_xz3(:, 2), 'w', 'LineWidth', 2.0);
    hold off;
%     if ii == 4 
        % caxis([1.8,2.2]);
        % caxis([0,6]);
%     else
        % caxis([0,2.0]);%max(max(A))
%     end
%     setPivot(); 
end

%% 输出txt文件  
% 定义范围  
x_total_min = 0;  
x_total_max = 15;    % 最终范围0-15  
z_total_min = 0;  
z_total_max = 6;     % 最终范围0-6  
y_total_min = 0;  
y_total_max = 10;     % 最终范围0-6  

% 创建输出文件夹（如果不存在）  
if ~exist('boundaries', 'dir')  
    mkdir('boundaries');  
end  

%% 输出 XZ 平面的边界  
% 缩放系数计算  
x_scale = x_total_max/30;  % 原始数据范围约为0-30  
z_scale = z_total_max/30;  % 原始数据范围约为0-12  

% 导出 boundary_xz1  
fid = fopen('boundaries/boundary_xz1.txt', 'w');  
for i = 1:size(boundary_xz1, 1)  
    x_scaled = boundary_xz1(i,1) * x_scale;  
    z_scaled = boundary_xz1(i,2) * z_scale;  
    fprintf(fid, '%7.4f %7.4f\n', x_scaled, z_scaled);  
end  
fclose(fid);  

% 导出 boundary_xz2  
fid = fopen('boundaries/boundary_xz2.txt', 'w');  
for i = 1:size(boundary_xz2, 1)  
    x_scaled = boundary_xz2(i,1) * x_scale;  
    z_scaled = boundary_xz2(i,2) * z_scale;  
    fprintf(fid, '%7.4f %7.4f\n', x_scaled, z_scaled);  
end  
fclose(fid);  

% 导出 boundary_xz3  
fid = fopen('boundaries/boundary_xz3.txt', 'w');  
for i = 1:size(boundary_xz3, 1)  
    x_scaled = boundary_xz3(i,1) * x_scale;  
    z_scaled = boundary_xz3(i,2) * z_scale;  
    fprintf(fid, '%7.4f %7.4f\n', x_scaled, z_scaled);  
end  
fclose(fid);  

%% 输出 XY 平面的边界  
% Y方向缩放系数  
y_scale = y_total_max/20;  % 原始数据范围约为0-12  

% 导出 boundary_xy1  
fid = fopen('boundaries/boundary_xy1.txt', 'w');  
for i = 1:size(boundary_xy1, 1)  
    x_scaled = boundary_xy1(i,1) * x_scale;  
    y_scaled = boundary_xy1(i,2) * y_scale;  
    fprintf(fid, '%7.4f %7.4f\n', x_scaled, y_scaled);  
end  
fclose(fid);  

% 导出 boundary_xy2  
fid = fopen('boundaries/boundary_xy2.txt', 'w');  
for i = 1:size(boundary_xy2, 1)  
    x_scaled = boundary_xy2(i,1) * x_scale;  
    y_scaled = boundary_xy2(i,2) * y_scale;  
    fprintf(fid, '%7.4f %7.4f\n', x_scaled, y_scaled);  
end  
fclose(fid);  

% 导出 boundary_xy3  
fid = fopen('boundaries/boundary_xy3.txt', 'w');  
for i = 1:size(boundary_xy3, 1)  
    x_scaled = boundary_xy3(i,1) * x_scale;  
    y_scaled = boundary_xy3(i,2) * y_scale;  
    fprintf(fid, '%7.4f %7.4f\n', x_scaled, y_scaled);  
end  
fclose(fid);  

fprintf('All scaled boundary files have been saved in the boundaries folder.\n');  
fprintf('Scaling factors used:\n');  
fprintf('X scale: %f \n', x_scale);  
fprintf('Y scale: %f \n', y_scale);
fprintf('Z scale: %f \n', z_scale);

% setPivot(ax(1),0);setPivot(ax(2),0);setPivot(ax(3),0);setPivot(ax(4),0);
%% 为第二列创建另一个新的图形窗口
figure('unit','centimeters','position',[20,5,20,12]);
for ii = 1:length(md)
    row = floor((ii-1)/2); % 计算行
    col = mod(ii-1,2);     % 计算列
    subplot('Position',[0.125+col*0.45 0.55-row*0.45 0.35 0.35]); % 设置位置
%     imagesc(Bb{ii*2}); colormap Jet;
    A = Aa{ii*2};
    % if (ii == 2)||(ii == 3)
    % % 对数据进行归一化处理，限制在0-2范围  
    % A_normalized = (A - min(A(:))) ./ (max(A(:)) - min(A(:))) * 1.8;  
    % else
    A_normalized = min(A, 2.2); % 限制最大
    A_normalized = max(A, 0); % 限制最小
    % end
    A_normalized = A;
    % [x, y] = meshgrid(1:size(A_normalized, 2), 1:size(A_normalized, 1));  
    % [xi, yi] = meshgrid(linspace(1, size(A_normalized, 2), 30), linspace(1, size(A_normalized, 1), 20));  
    % Ai = interp2(x, y, A_normalized, xi, yi, 'cubic');  
    Ai = A_normalized;
    % 导出 GRD 文件  
    % Ai = min(Ai, 2);Ai = max(Ai, 0);
    xsum = linspace(0, 15, size(Ai, 2)); % 假设X轴范围是0-12 km  
    ysum = linspace(0, 10, size(Ai, 1)); % 假设Y轴范围是0-12 km  
    exportMatrixToGRD(Ai, fullfile(invFilepath, sprintf('XY_slice_%d.grd', ii)), [0, xsum(end)], [0, ysum(end)]); 
    

    imagesc(Ai); colormap Jet; 
    ax(ii) = gca;
    text(ax(ii).XLim(2)*0.95, ax(ii).YLim(2)*0.95, label{ii}, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom','Color','w');
    set(ax(ii), 'TickDir', 'in');

    if ii == 3 || ii == 4
        xlabel('X-Distance(km)', 'FontSize', 12, 'FontWeight', 'bold');
    end
    if ii == 1 || ii == 3
        ylabel('Y-Distance(km)','FontSize',12,'FontWeight','bold');
    end
    h = colorbar;xlabel(h, '(g/cm^3)', 'Interpreter', 'tex','Rotation', 0);
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.Label.HorizontalAlignment = 'center'; % 水平居中对齐
    h.Label.VerticalAlignment = 'bottom'; % 与colorbar顶部对齐
    h.Label.Position = [0.60, 1.00*2.0]; % 您可能需要调整这个位置
    hold on;
    plot(boundary_xy1(:, 1), boundary_xy1(:, 2), 'w', 'LineWidth', 2.0);
    plot(boundary_xy2(:, 1), boundary_xy2(:, 2), 'w', 'LineWidth', 2.0);
    plot(boundary_xy3(:, 1), boundary_xy3(:, 2), 'w', 'LineWidth', 2.0);
    hold off;
    % caxis([0,2.0]);%max(max(A))
end
setPivot(ax(1),0);setPivot(ax(2),0);setPivot(ax(3),0);setPivot(ax(4),0);
return
%%
% 保存第一张图 
figure(1);
set(gcf, 'Color', 'white'); % 设置图形背景为白色  
set(gcf, 'Renderer', 'painters'); % 使用矢量渲染  
print('-dtiff', '-r600', fullfile(invFilepath, 'cross_plot_xy_jt.tiff'));  

% 保存第二张图  
figure(2); % 切换到第二张图  
set(gcf, 'Color', 'white');  
set(gcf, 'Renderer', 'painters');  
print('-dtiff', '-r600', fullfile(invFilepath, 'cross_plot_xz_jt.tiff'));
