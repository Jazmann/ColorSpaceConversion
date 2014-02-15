xyBin_JHands_masked

ind = [min(xyBin_JHands_masked.subs(:,1)),max(xyBin_JHands_masked.subs(:,1));min(xyBin_JHands_masked.subs(:,2)),max(xyBin_JHands_masked.subs(:,2))];
            xdata = zeros(ind(1,2) - ind(1,1)+1,ind(2,2) - ind(2,1)+1,2);
            [ xdata(:,:,1), xdata(:,:,2)] =  meshgrid(xyBin_JHands_masked.vals{2}(ind(2,1):ind(2,2)),xyBin_JHands_masked.vals{1}(ind(1,1):ind(1,2)) );
            x0 = [1.0, xyBin_JHands_masked.a(1),xyBin_JHands_masked.aScale(1)/4.0,xyBin_JHands_masked.a(2),xyBin_JHands_masked.aScale(2)/4.0,0.0]; % Inital guess parameters
            lb = [0.9,xyBin_JHands_masked.vals{2}(1),3.0 * xyBin_JHands_masked.aScale(1)/xyBin_JHands_masked.nBins(1), xyBin_JHands_masked.vals{1}(1),3.0 * xyBin_JHands_masked.aScale(2)/xyBin_JHands_masked.nBins(2),-pi/4];
            ub = [1.0,xyBin_JHands_masked.vals{2}(end),xyBin_JHands_masked.aScale(1),xyBin_JHands_masked.vals{1}(end),xyBin_JHands_masked.aScale(2),pi/4];
            [x,resnorm,residual,exitflag] = lsqcurvefit(@D2GaussFunctionRot,x0,xdata,xyBin_JHands_masked.fBin(ind(1,1):ind(1,2),ind(2,1):ind(2,2)),lb,ub);
            
            
            
xdata = zeros(xyBin_JHands_masked.nBins(1),xyBin_JHands_masked.nBins(2),2);
[ xdata(:,:,1), xdata(:,:,2)] =  meshgrid(xyBin_JHands_masked.vals{2},xyBin_JHands_masked.vals{1});
x0 = [1.0, xyBin_JHands_masked.a(1),xyBin_JHands_masked.aScale(1)/4.0,xyBin_JHands_masked.a(2),xyBin_JHands_masked.aScale(2)/4.0,0.0]; % Inital guess parameters
lb = [0.9,xyBin_JHands_masked.vals{2}(1),3.0 * xyBin_JHands_masked.aScale(1)/xyBin_JHands_masked.nBins(1), xyBin_JHands_masked.vals{1}(1),3.0 * xyBin_JHands_masked.aScale(2)/xyBin_JHands_masked.nBins(2),-pi/4];
ub = [1.0,xyBin_JHands_masked.vals{2}(end),xyBin_JHands_masked.aScale(1),xyBin_JHands_masked.vals{1}(end),xyBin_JHands_masked.aScale(2),pi/4];
[x,resnorm,residual,exitflag] = lsqcurvefit(@D2GaussFunctionRot,x0,xdata,xyBin_JHands_masked.fBin,lb,ub);