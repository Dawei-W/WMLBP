
x=1:1:7;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
a=[99.58,98.67,89.84,99.84,99.04,97.21,98.67]; %tc10
b=[98.31,97.92,85.90,98.56,95.97,95.21,95.86]; %tc12-tl84
c=[96.92,97.48,89.58,97.80,95.92,95.69,95.90];%tc-12-hor
d=[97.79,96.84,90.21,98.17,96.56,95.88,96.88];%CURet
e=[98.29,97.38,96.54,98.54,97.49,96.31,97.44];%KTH

plot(x,a,'-or','LineWidth',1,'MarkerFaceColor','r') %线性，颜色，标记
hold on 
plot(x,b,'-squareg','LineWidth',1,'MarkerFaceColor','g')
plot(x,c,'-diamondb','LineWidth',1,'MarkerFaceColor','b')
plot(x,d,'-^m','LineWidth',1,'MarkerFaceColor','m')
plot(x,e,'-vc','LineWidth',1,'MarkerFaceColor','c')

axis([0.5,7.5,85,100])  %确定x轴与y轴框图大小
set(gca,'XTick',[1:1:7],'XTickLabel',{'1','2','3','(1,2)','(1,3)','(2,3)','(1,2,3)'}) %x轴范围1-6，间隔1
% set(subplot1,'XTick',[1,2,3,(1,2),(1,3),(2,3)]);

set(gca,'YTick',[85:5:100]) %y轴范围0-700，间隔100
legend('TC10','TC12-t','TC12-H','CUReT','KTH-TIPS','Location','southeast');   %右上角标注
xlabel('The scale of stationary wavelet transform','FontName','Times New Roman','FontSize',16)  %x轴坐标描述
ylabel('Classification Accuracy (%)','FontName','Times New Roman','FontSize',16) %y轴坐标描述
