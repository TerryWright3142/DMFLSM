% not really working
classdef  SimpleFWHMScore < Score 
    %takes the total from within a designated rect. Returns -log(total)
    properties  
       x
       y

    end
    
    methods 
        function obj = SimpleFWHMScore(x1, y1)
            obj.x = x1;
            obj.y = y1;
        end
        function val = FindScore(obj, im)
            %move right until get to fwhm
            dx = 50;
            dy = 50;
            image = im((obj.y - dy/2):(obj.y + dy/2), (obj.x - dx/2):(obj.x + dx/2));
 
            L = size(image, 1);
            tot = sum(image(:));
            image = double(image)/tot;
            [Y,X]   = meshgrid(linspace(-1,1,L));
            X2 = image.*(X.^2);
            X1 = image.*X;
            Y2 = image.*(Y.^2);
            Y1 = image.*Y;
            VX = sum(X2(:)) - sum(X1(:))^2;
            VY = sum(Y2(:)) - sum(Y1(:))^2;
            val =  (VX + VY) ;
 
            imagesc(image);
            colormap(gray);
            disp(val);
            drawnow;
        
        end


    end


end