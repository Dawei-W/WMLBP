%% tc10-linear r1 
C=[ 
    97.5    98.49   98.93   98.91   98.93
    97.76   98.44   98.80   99.06   98.98
    98.65   99.22   99.51   99.35   99.35
    98.49   99.22   99.84   99.58   99.56
];
% C=[92 94 96 98]
C=C-90;


shit=bar3(C);
xlabel('\itN');
ylabel('\itR');
zlabel('Classification Accuracy (%)');
 title('TC10','FontName','Times New Roman','Fontsize',20)
% set(t,'position', [1, 8])
% set(gca,'XTick',[1 2 3 4 5 ]); %%%%%坐标刻度的位置,可手动设置也可自动设置
% set(gca,'XTickLabel',1:1:5); %%%%%坐标刻度的标签,可手动设置也可自动设置
% set(get(gca, 'XLabel'), 'Rotation', 23,'fontsize',14,'fontname','Times New Roman');%%%%坐标的标签：平行,字号,字型,字体
set(gca,'XTick',[1:1:5],'fontsize',14,'fontname','Times New Roman'); 
xlim([0 6]);%%%%留白问题

% set(gca,'YTick',[ 1 2 3 4]);
set(gca,'YTick',[1:1:4],'YTickLabel',{'1','2','3','3-th'}, 'fontname','Times New Roman'); 
% set(get(gca, 'YLabel'), 'Rotation', -35,'fontsize',14,'fontname','Times New Roman');
ylim([0 5]);

% set(gca,'ZTick',[0 2 4 6 8]);
% set(gca,'ZTickLabel',90:2:100); 
% set(gca,'ZTick',[90:2:100], 'fontsize',14,'fontname','Times New Roman');
set(gca,'ZTick',[0:2:10],'ZTickLabel',90:2:100,'fontsize',14,'fontname','Times New Roman')
zlim([0 10])
set(gca,'fontsize',20,'fontname','Times New Roman','LineWidth',1); 
% set(gcf, 'position', [0 0 700 600]);

% set(gca,'FontName','Times New Roman','FontSize',30,'LineWidth',1);

for n=1:numel(shit)
    cdata=get(shit(n),'zdata');
    cdata=repmat(max(cdata,[],2),1,4);
    set(shit(n),'cdata',cdata,'facecolor','flat','LineWidth',2);
end 

% set(colorbar,'fontsize',23,'fontweight','bold','fontname','Times New Roman','LineWidth',2,'ytick',90:1:100);

colormap(bone)
% set(colorbar,'fontsize',26,'fontname','Times New Roman','YTickLabel',92:1:100);