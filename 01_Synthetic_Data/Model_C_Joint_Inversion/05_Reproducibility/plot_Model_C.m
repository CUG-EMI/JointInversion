close;clc;clear
currentFilePath = mfilename('fullpath');mFilePath = fileparts(currentFilePath);
invFilepath = fullfile(mFilePath, 'model_5b_0921/joint_20250929'); %联合50；单独30;test

type = 'single_newread';%joint/single
% filefwd_den ='model3_fwd_den.ws';
fileinv_den =fullfile(invFilepath, 'md010.ws');
fileinv_m   =fullfile(invFilepath, 'mk010.ws');
fileinv_rho =fullfile(invFilepath, '5BLOCKs_NLCG_010.rho');
profile = 'y';  %  y, z


[xLen1, yLen1, zLen1, cross1, origin1 ]= readMG3DModel(fileinv_den);
nx=length(xLen1); ny=length(yLen1); nz=length(zLen1);
zprofile = 5; yprofile = 20;

[xLen2, yLen2, zLen2, cross2, origin2 ]= readMG3DModel(fileinv_m);


[xLen3, yLen3, zLen3, rho3, origin3 ]= readModEM3DModel(fileinv_rho);

 switch profile
     case 'y'
         a(1:nx,1:nz) = cross1(1:nx,yprofile,1:nz);a=a';
         b(1:nx,1:nz) = cross2(1:nx,yprofile,1:nz);b=b';
         e(1:nx,1:nz) = rho3(7:nx+6,yprofile+6,1:nz);e=e';%e = 10.^e
     case 'z'
         a(1:nx,1:ny) = cross1(1:nx,1:ny,zprofile);a=a';
         b(1:nx,1:ny) = cross2(1:nx,1:ny,zprofile);b=b';
         e(1:nx,1:ny) = rho3(7:nx+6,7:ny+6,zprofile);e=e';
 end

pic={a,b,e};title = [{'Den(g/cm^{3})'},{'K'},{'Log\rho(\Omega.m)'}];
pic{2} = pic{2}/1000;
% %----平滑处理---
% %  定义高斯核
% sigma = 1; % 高斯核的标准差
% sz = 1.9 * sigma; % 核大小
% [x, y] = meshgrid(-floor(sz/2):floor(sz/2), -floor(sz/2):floor(sz/2));
% gaussKernel = exp(-(x.^2 + y.^2) / (2*sigma^2));
% gaussKernel = gaussKernel / sum(gaussKernel(:)); % 归一化
% % 使用高斯核对每个图像进行卷积
% a_smooth = conv2(a, gaussKernel, 'same');
% b_smooth = conv2(b, gaussKernel, 'same');
% e_smooth = conv2(e, gaussKernel, 'same');
% % 使用平滑后的数据替换原始数据
% pic={a_smooth, b_smooth, e_smooth};

 % Yx1 = [8.5,11.5,11.5,8.5,8.5]; Yz = [2.5,2.5,5.5,5.5,2.5]; Yx2= Yx1+5; Yx3= Yx2+5; Yx4= Yx3+5; Yx5= Yx4+5;
 % Zx1 = [8.5,11.5,11.5,8.5,8.5]; Zy = [18,18,22,22,18]; Zx2= Zx1+5; Zx3= Zx2+5; Zx4= Zx3+5; Zx5= Zx4+5;
figure
for i=1:3
 subplot(3,1,i)
 imagesc(pic{i});
 colormap("jet");
 hold on 
 set(gca,'xaxislocation','top');
 % if profile == 'y'
 %    ylabel('nz','FontSize',12,'FontWeight','bold');
 %    xlabel('nx','position',[nx/2,nz+3],'FontSize',12,'FontWeight','bold');
 %    plot( Yx1, Yz,'k',LineWidth=1.2);plot( Yx2, Yz,'k',LineWidth=1.2);
 %    plot( Yx3, Yz,'k',LineWidth=1.2);plot( Yx4, Yz+1,'k',LineWidth=1.2);
 %    plot( Yx5, Yz,'k',LineWidth=1.2);
 % elseif profile == 'z'
 %    xlabel('nx','position',[nx/2,ny*1.1],'FontSize',12,'FontWeight','bold');
 %    ylabel('ny','FontSize',12,'FontWeight','bold');
 %    plot( Zx1, Zy,'k',LineWidth=1.2);plot( Zx2, Zy,'k',LineWidth=1.2);
 %    plot( Zx3, Zy,'k',LineWidth=1.2);plot( Zx4, Zy,'k',LineWidth=1.2);
 %    plot( Zx5, Zy,'k',LineWidth=1.2);
 % end
 % hold off
%  if mod(i,2) == 0
    cb = colorbar;ax = gca;
    axpos = ax.Position;cb.Position(3) = 0.5*cb.Position(3);ax.Position = axpos;ax.Position(3) = 0.65; 
    cb.LineWidth =1.0;
    set(get(cb,'ylabel'),'string',strjoin(title(i)),'FontSize',11);
%  end
%  title(titlename(i),'FontSize',9);
  set(gca, 'LineWidth', 1.6);
end

% axes_handle = subplot(3, 2, 3);
% % caxis(axes_handle, [0, 2]);
% 
 set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
 set(gcf, 'defaultAxesLooseInset', [0.01, 0.01, 0.01, 0.01]);
 if profile == 'y'
    set(gcf,'unit','centimeters','position',[10,5,10,12]);
 elseif profile == 'z'
    set(gcf,'unit','centimeters','position',[10,0,10,22]);
 end


  filename = [{'G'},{'M'},{'EM'}];
  switch profile
      case 'y'
          for i = 1:3
            exportMatrixToGRD(pic{i}, [filename{i},'_yprofile_5b_',type,'_',profile,'.grd'], [-20000,20000], [10,12000]);
          end
      case 'z'
          for i = 1:3
%             aa = pic{i}(6:end-5,6:end-5);
            exportMatrixToGRD(pic{i}, [filename{i},'_zprofile_5b_',type,'_',profile,'.grd'], [-20000,20000], [-20000,20000]);
          end
  end
