classdef  CovarianceScore < Score 
    %takes the total from within a designated rect. Returns -log(total)
    properties  
       x
       y
       im

    end
    
    methods 
         function DrawImage(obj)
            if size(obj.im, 1)>0
                imagesc(obj.im);
                colormap(gray);
                drawnow;
             
            end
        end
        function obj = CovarianceScore(x1, y1)
            obj.x = x1;
            obj.y = y1;
        end
        function val = FindScore(obj, im)
            %move right until get to fwhm
            dx = 40;
            dy = 40;
            image = im((obj.y - dy/2):(obj.y + dy/2), (obj.x - dx/2):(obj.x + dx/2));
            obj.im = image;
            L = size(image, 1);
            tot = sum(image(:));
            image = double(image)/tot;
            [Y,X]   = meshgrid(linspace(-1,1,L));
 
            XY = image.*(X.*Y);

            X1 = image.*X;
 
 
            Y1 = image.*Y;
            CXY = sum(XY(:)) - sum(X1(:))*sum(Y1(:));
 
            val = abs(CXY);
%  
%             imagesc(image);
%             colormap(gray);
            disp(val);
%             drawnow;
        
        end


    end


end