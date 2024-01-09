wd1=1.4;wd2=2; w=0.45; hgt=0.42; 
ymin=0; xmin=1;xmax=180; bar_int=8;
m0=5;
fac1=86400;

start = [1 1 5]; % Start location along each coordinate
count = [360 180 1]; % Read until the end of each dimension

pth0 = ['/scratch1/BMC/gsd-fv3-dev/data_others/gpcp/gpcp_'];
pth1 = ['/scratch1/BMC/wrfruc/Shan.Sun/wfw_wgne_ctrl_exp/COMROOT/noa00/gfs.'];
pth2 = ['/scratch2/BMC/gsd-hpcs/Shan.Sun/clim_togo_exp/COMROOT/clim0/gfs.'];
pth3 = ['/scratch2/BMC/gsd-fv3-test/Shan.Sun/wgne_chem_exp/COMROOT/chm0/gfs.'];
y0=2002;

for mm=1:2
 if (mm==1) mon=5; amon='May';i1=0.04;j1=.9-hgt-.03;end
 if (mm==2) mon=9; amon='Sep';i1=0.53;end
for number=1:1 % total precip only
  if (number==2) i1=.52; end
for yy=2003:2019
 flnm0 = [pth0,num2str(yy,'%04.0f'),num2str(mon,'%02.0f'),'_wk.nc']; 
 flnm1 = [pth1,num2str(yy,'%04.0f'),num2str(mon,'%02i'),'01/00/var_wk_1x1.nc'];
 flnm2 = [pth2,num2str(yy,'%04.0f'),num2str(mon,'%02i'),'01/00/var_wk_1x1.nc'];
 flnm3 = [pth3,num2str(yy,'%04.0f'),num2str(mon,'%02i'),'01/00/var_wk_1x1.nc'];

  if (number==1) 
    f0=ncread(flnm0,'precip',start,count);
    f1=ncread(flnm1,'prate_ave',start,count)*fac1; 
    f2=ncread(flnm2,'prate_ave',start,count)*fac1;
    f3=ncread(flnm3,'prate_ave',start,count)*fac1; end
  if (number==2) 
    f0=ncread(flnm0,'precip',start,count);
    f1=ncread(flnm1,'cprat_ave',start,count)*fac1; 
    f2=ncread(flnm2,'cprat_ave',start,count)*fac1;
    f3=ncread(flnm3,'cprat_ave',start,count)*fac1; end

 znl0=mean(f0,1);
 znl1=mean(f1,1);
 znl2=mean(f2,1);
 znl3=mean(f3,1);

 aer0(:,yy-y0)=znl0;
 aer1(:,yy-y0)=znl1;
 aer2(:,yy-y0)=znl2;
 aer3(:,yy-y0)=znl3;
 
end %yy

 znl0a=mean(aer0,2);
 znl1a=mean(aer1,2);
 znl2a=mean(aer2,2);
 znl3a=mean(aer3,2);

 clat = (-89.5:89.5); % latitude correspond
 wgt=cos(pi/180*clat);

 y0a = sum(znl0a(:).*wgt(:)) / sum(wgt(:))
 y1a = sum(znl1a(:).*wgt(:)) / sum(wgt(:))
 y2a = sum(znl2a(:).*wgt(:)) / sum(wgt(:))
 y3a = sum(znl3a(:).*wgt(:)) / sum(wgt(:))

std0(:)=nanstd(aer0,0,2);
ave0(:)=nanmean(aer0,2); 

std1(:)=nanstd(aer1,0,2);
ave1(:)=nanmean(aer1,2);

std2(:)=nanstd(aer2,0,2);
ave2(:)=nanmean(aer2,2);

std3(:)=nanstd(aer3,0,2);
ave3(:)=nanmean(aer3,2);

xdim=[1:1:length(ave0)];
axes('position',[i1,j1,w,hgt]);

x00=3;
x01=5;
if (number==1) 
q=plot(xdim,ave0,'k',xdim,ave1,'g',xdim,ave2,'b',xdim,ave3,'r'); hold on; 
e=errorbar(xdim(1:bar_int:180),ave0(1:bar_int:180),std0(1:bar_int:180),'k'); hold on; end

if (number==2) 
q=plot(xdim,ave1,'g',xdim,ave2,'b',xdim,ave3,'r'); hold on; end

set(q,'linewidth',wd1)
e.LineStyle = 'none';
e=errorbar(xdim(x01:bar_int:180),ave1(x01:bar_int:180),std1(x01:bar_int:180),'g'); hold on
e.LineStyle = 'none';
e=errorbar(xdim(x00:bar_int:180),ave2(x00:bar_int:180),std2(x00:bar_int:180),'b'); hold on
e.LineStyle = 'none';
e=errorbar(xdim(1:bar_int:180),ave3(1:bar_int:180),std3(1:bar_int:180),'r'); hold on
e.LineStyle = 'none';
grid

  if (number==1) title0=sprintf('%s %s %s',amon);out='znl_aod1_std.png'; 
    ymax=11.; end
  if (number==2) title0=sprintf('%s %s %s','Zonal Mean Convective Precipitation',amon,'2003-2019');out='znl_aod1_std.png'; 
    ymax=11.; end
  title (title0,'Fontsize',12,'Fontweight','normal'); 
  mylbl='';

text(7.,.85*ymax,mylbl,'FontSize',9,'color','k')
xticks([1:30:180])
xticklabels({'','','','','',''})

n0=ymin+(ymax-ymin)*.92;
n1=ymin+(ymax-ymin)*.85;
n2=ymin+(ymax-ymin)*.78;
n3=ymin+(ymax-ymin)*.71;

a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',8)
set(gca,'YTickLabelMode','auto')

sz9=9;
ave = ['GPCP    (ave=',num2str(y0a,'%04.2f'),')'];
if (number==1) text(m0,n0,ave,'FontSize',sz9,'color','k'); end
ave = ['ProgAer (ave=',num2str(y1a,'%04.2f'),')'];
text(m0,n1,ave,'FontSize',sz9,'color','g')
ave = ['ClimAer (ave=',num2str(y2a,'%04.2f'),')'];
text(m0,n2,ave,'FontSize',sz9,'color','r')
ave = ['NoAer   (ave=',num2str(y3a,'%04.2f'),')'];
text(m0,n3,ave,'FontSize',sz9,'color','b')

xticklabels({'','60^oS','30^oS','EQ','30^oN','60^oN'})

axis ([xmin xmax ymin ymax])
end %number
end %mon

axes('position',[0.35 .90 0.3 0.01])
title ('Zonal Mean Precipitation (mm/day) 2003-2019','Fontsize',10,'Fontweight','normal');
axis off

%orient tall
%print -depsc2 fig2_znl_aod1_modis_2runs_std.eps
%print -djpeg fig2_znl_aod5_modis_2runs_std.jpg
out='fig11_znl_1precip_std_3run'
print(out,'-dpng')
print(out,'-depsc2')
