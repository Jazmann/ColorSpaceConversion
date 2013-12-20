function transformMatrix = transformationMatrix(Kb, Kr, theta, yScale, bScale, rScale)
% Matrix multiplication with RGB 0:1 gives YCbCr 0:1 -0.5:0.5 -0.5:0.5
A = [Kr.*yScale,                             (1+(-1).*Kb+(-1).*Kr).*yScale,                             Kb.*yScale;...
     (-1/2).*bScale.*(1+(-1).*Kb).^(-1).*Kr, (-1/2).*bScale.*(1+(-1).*Kb).^(-1).*(1+(-1).*Kb+(-1).*Kr), (1/2).*bScale;...
     (1/2).*rScale,                          (-1/2).*(1+(-1).*Kr).^(-1).*(1+(-1).*Kb+(-1).*Kr).*rScale, (-1/2).*Kb.*(1+(-1).*Kr).^(-1).*rScale ]; 
transformMatrix = A' * [ 1, 0, 0; 0, cos(theta), sin(theta); 0, -sin(theta), cos(theta)]';
end

