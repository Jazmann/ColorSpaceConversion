classdef colorSpace
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        g; uC; uT;
        sMin; sMax; sRange;
        dMin; dMax; dRange;
        ErfA; ErfB; ErfAB;
        shift; scale; sUnitGrad; sLowHigh; dUnitGrad;
        linearConstant; shiftednErfConstant; dMaxShifted;
        cubeSkin;
    end
    
    methods
        function obj = colorSpace(theta, sigma, c, sig, cubeSkin, sMin, sMax, dMin, dMax, cInRGB)
            
            obj.sMin = sMin; obj.sMax = sMax; obj.sRange = (sMax - sMin);
            obj.dMin = dMin; obj.dMax = dMax; obj.dRange = (dMax - dMin);
            obj.cubeSkin = cubeSkin;
            
            obj.g = [ 1./(sqrt(2) .* sig(1) .* sigma(1)), 1./(sqrt(2) .* sig(2) .* sigma(2)), 1./(sqrt(2) .* sig(3) .* sigma(3))];
            obj.uT = transformationMatrixLAB(theta);
            
            if cInRGB
                obj.uC = (c ./ obj.sRange) * obj.uT';
            else
                obj.uC = c ./ obj.dRange;
            end
            obj.C = obj.uC .* obj.dRange;
            obj.ErfA = erf((obj.g.*(obj.uC - sMin))./obj.sRange);
            obj.ErfB = erf((obj.g.*(sMax - obj.uC))./obj.sRange);
            obj.ErfAB = obj.ErfB + obj.ErfA;
            obj.shift = dMin + obj.dRange .* obj.ErfA ./ obj.ErfAB;
            obj.scale = obj.dRange ./ obj.ErfAB;
            obj.sUnitGrad = [floor(obj.uC - (obj.sRange .* sqrt(log((2*obj.dRange .* obj.g)./(obj.ErfAB.*sqrt(pi) .* obj.sRange))))./obj.g); ceil(obj.uC + (obj.sRange .* sqrt(log((2*obj.dRange .* obj.g)./(obj.ErfAB .* sqrt(pi) .* obj.sRange))))./obj.g)];
            obj.sLowHigh = [obj.uC + (obj.sRange .* erfinv((1 + dMin - obj.shift)./obj.scale))./obj.g; obj.uC + (obj.sRange .* erfinv((-1 + dMax - obj.shift)./obj.scale))./obj.g];
            
            obj.dUnitGrad(1,:) = obj.shift(:) + obj.scale(:) .* erf( obj.g(:) .* (obj.sUnitGrad(1,:)' - obj.uC(:)) ./ obj.sRange);
            obj.dUnitGrad(2,:) = obj.shift(:) + obj.scale(:) .* erf( obj.g(:) .* (obj.sUnitGrad(2,:)' - obj.uC(:)) ./ obj.sRange);
            
            obj.linearConstant = obj.dUnitGrad(1,:) - obj.sUnitGrad(1,:);
            obj.shiftednErfConstant = obj.sUnitGrad(2,:) + obj.dUnitGrad(1,:) - obj.sUnitGrad(1,:) - obj.dUnitGrad(2,:);
            obj.dMaxShifted = (obj.shift(:) + obj.scale(:) .* erf( obj.g(:) .* (sMax - obj.uC(:)) ./ obj.sRange) + obj.shiftednErfConstant')';
            
        end % function
        
        function img = toScaled(obj, rgbImage)
            %# First convert the RGB image to double precision, scale its values to the
            %#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
            img = reshape(double(rgbImage),[],3);
            %# Shift each color plane (stored in each column of the N-by-3 matrix):
            img(:,1) = obj.shift(1) + obj.scale(1) * erf( obj.g(1) * (img(:,1) - obj.uC(1)) ./ obj.sRange);
            img(:,2) = obj.shift(2) + obj.scale(2) * erf( obj.g(2) * (img(:,2) - obj.uC(2)) ./ obj.sRange);
            img(:,3) = obj.shift(3) + obj.scale(3) * erf( obj.g(3) * (img(:,3) - obj.uC(3)) ./ obj.sRange);
            
            %# Convert back to type uint8 and reshape to its original size:
            img = reshape(uint8(img),size(rgbImage));
        end % function
        
        function outImage = rgbToSkinTotal(obj, img)
            
            [rows, cols, chans] = size(img);
            
            uImage = reshape(double(img)./obj.sRange,[],3);
            uRotImage = uImage * obj.uT';
            %# Shift each color plane (stored in each column of the N-by-3 matrix):
            uRotImage(:,1) =  uRotImage(:,1);
            uRotImage(:,2) = (uRotImage(:,2) + 0.5);
            uRotImage(:,3) = (uRotImage(:,3) + 0.5);
            %# Shift each color plane (stored in each column of the N-by-3 matrix):
            scaledImage(:,1) = obj.shift(1) + obj.scale(1) * erf( obj.g(1) * (uRotImage(:,1) - obj.uC(1)).* obj.dRange );
            scaledImage(:,2) = obj.shift(2) + obj.scale(2) * erf( obj.g(2) * (uRotImage(:,2) - obj.uC(2)).* obj.dRange );
            scaledImage(:,3) = obj.shift(3) + obj.scale(3) * erf( obj.g(3) * (uRotImage(:,3) - obj.uC(3)).* obj.dRange );
            
            uProb = zeros(rows * cols, 2);
            uProb(:,1) = uImage(:,1)<(obj.sMax-obj.cubeSkin)/obj.sMax & uImage(:,2)<(obj.sMax-obj.cubeSkin)/obj.sMax & uImage(:,3)<(obj.sMax-obj.cubeSkin)/obj.sMax & uImage(:,1)>(obj.cubeSkin + obj.sMin)/obj.sMax & uImage(:,2)>(obj.cubeSkin + obj.sMin)/obj.sMax & uImage(:,3)>(obj.cubeSkin + obj.sMin)/obj.sMax;
            uProb(:,2) = 1. ./ ( exp((uRotImage(:,2) - obj.uC(2)).^2 ./ ( 2. * (sig(2) * sigma(2)/obj.sRange)^2)) .* exp((uRotImage(:,3) - obj.uC(3)).^2 ./ ( 2. * (sig(3) * sigma(3)/obj.sRange)^2)));
            
            %# Convert back to type uint8 and reshape to its original size:
            outImage = reshape(horzcat(uint8(uImage.* obj.dRange),uint8(scaledImage),uint8(uProb.* obj.dRange)),[rows, cols, chans+5]);
            
        end % function
        
        function pixelOut = compactScaledPoint(obj, point)
            pixelOut = zeros(size(point));
            for i=1:length(point)
                if point(i) < obj.sLowHigh(1,i)
                    pixelOut(i) = obj.dMin;
                elseif obj.sLowHigh(1,i) < point(i) <= obj.dUnitGrad(1,i)
                    pixelOut(i) = obj.shift(i) + obj.scale(i) * erf( obj.g(i) * (point(i) - obj.C(i)) );
                elseif obj.dUnitGrad(1,i) < point(i) <= obj.dUnitGrad(2,i)
                    pixelOut(i) = pixelOut(i) + obj.linearConstant;
                elseif obj.dUnitGrad(2,i) < point(i) <= obj.sLowHigh(2,i)
                    pixelOut(i) = obj.shift(i) + obj.scale(i) * erf( obj.g(i) * (point(i) - obj.C(i)) ) + obj.shiftednErfConstant;
                elseif obj.sLowHigh(2,i) < point(i)
                    pixelOut(i) = obj.dMaxShifted;
                end
            end
        end % function
        
        function pixelOut = scaledPoint(obj, point)
            pixelOut = zeros(size(point));
            for i=1:length(point)
                    pixelOut(i) = obj.shift(i) + obj.scale(i) * erf( obj.g(i) * (point(i) - obj.C(i)) );
            end
        end % function
        
        function unit = srcToUnit(obj, point)
            unit = (point - obj.sMin)./obj.sRange;
        end % function
        
        function unit = dstToUnit(obj, point)
            unit = (point - obj.dMin)./obj.dRange;
        end % function
        
        function src = unitToSrc(obj, point)
            src = point.*obj.sRange + obj.sMin;
        end % function
        
        function dst = unitToDst(obj, point)
            dst = point.*obj.dRange + obj.dMin;
        end % function
        
    end
    
end

