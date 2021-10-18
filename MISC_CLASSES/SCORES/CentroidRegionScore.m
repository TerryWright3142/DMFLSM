classdef  CentroidRegionScore < Score 
    %returns the score from the image (background corrected
    properties  
       x
       y
       dx
       dy
       centroid_x;
       centroid_y;
       im
       background;
    end
    
    methods 
        function obj = CentroidRegionScore(x1, y1, dx1, dy1)
            %%define the rectangle to find the centroid
            obj.x = x1;
            obj.y = y1;
            obj.dx = dx1;
            obj.dy = dy1;
            obj.centroid_x = 0;
            obj.centroid_y = 0;
        end
        function SetBackground(obj, background)
            %%check this c++ like syntax
            obj.background = background;
        end
        function val = FindScore(obj, image)
             image = image - obj.background;
             image(image<0)=0;
            [Y,X]   = meshgrid(1:size(image, 2), 1:size(image, 1) );
            mask = zeros(size(image));
            mask((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2))) = 1;
        
            subimage = mask.*double(image);

             tot = sum(subimage(:));

             Xmoment = X.*subimage;
             obj.centroid_x = sum(Xmoment(:))/tot;
             Ymoment = Y.*subimage;
             obj.centroid_y = sum(Ymoment(:))/tot;
             disp(strcat(string(round(obj.centroid_x)), ",", string(round(obj.centroid_y))));
             val = 0;
             for i = -1:1:1
                 for j = -1:1:1
             
                    val = val -double(image( i + round(obj.centroid_x), j + round(obj.centroid_y)));
                 end
             end
             obj.im = image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2)));
             disp(strcat('score = ', string(val)));
             drawnow;

      
        end
        function DrawImage(obj)
            if size(obj.im, 1)>0
                imagesc(obj.im);
                colormap(gray);
                drawnow;
             
            end
        end

    end


end