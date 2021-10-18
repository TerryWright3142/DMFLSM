classdef  KurtosisScoreRevised < Score 
    %returns the kurtosis score from the image (background corrected)
    properties  
       x
       y
       dx
       dy
       centroid_x;
       centroid_y;
       im
    end
    
    methods 
        function obj = KurtosisScoreRevised(x1, y1, dx1, dy1)
            %define the rectangle to find the centroid
            obj.x = x1;
            obj.y = y1;
            obj.dx = dx1;
            obj.dy = dy1;
            obj.centroid_x = 0;
            obj.centroid_y = 0;
        end
        function SetBackground(obj, background)
            %%check this c++ like syntax
            disp('not used');
        end
        function val = FindScore(obj, image)
            image = medfilt2(image);  %median fliter
            subimage = double(image( obj.y:(obj.y + obj.dy), obj.x:(obj.x + obj.dx)));
            imagesc(subimage);
            drawnow;
%             brighten = 65000/(1.0*max(subimage(:))); % stretch out dynamic range
%             imwrite(brighten*subimage, sz);
            totPhotons = sum(subimage(:));
            [X,Y]   = meshgrid(1:size(subimage, 2), 1:size(subimage, 1) );
            Xmoment = X.*subimage;
            obj.centroid_x = sum(Xmoment(:))/totPhotons;
            Ymoment = Y.*subimage;
            obj.centroid_y = sum(Ymoment(:))/totPhotons;            
            R2 = (X - obj.centroid_x).^2 + (Y - obj.centroid_y).^2 ; 
            R2moment = R2.*subimage; %using pixel value as frequency
            val = sqrt(sum(R2moment(:))/totPhotons);
            Z = sqrt(R2)/val;
            Z4 = Z.^4;
            val = sum(Z4(:))/totPhotons;


      
        end
        function DrawImage(obj)
            disp('not used');
        end

    end


end