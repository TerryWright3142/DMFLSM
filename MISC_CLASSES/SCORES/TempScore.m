classdef  TempScore < Score 
% this is a score that will be given the location of a pinhole and will
% take a radius (fixed size) around that point. Or rather it will
% mask off those points. It will then find the max of those points
% it will find the total and then divide to find the brightness relative
% to the total incoming energy
    properties  
       x
       y
       r
       im
       background
    end
    
    methods 
        function obj = TempScore(r)
            obj.r = r;
        end
        function SetBackground(obj, background)
            obj.background = background;
        end
        function val = FindScore(obj, image, x, y)
            %remove the background light
            image = double(image) - double(obj.background);
            [height, width] = size(image);
            x = round(x);
            y = round(y);
            y_sub = max(1, y - obj.r) : min(y + obj.r, height);
            x_sub = max(1, x - obj.r) : min(x + obj.r, width);
            obj.im = image(y_sub, x_sub);
            [Y, X] = meshgrid(y_sub, x_sub);
            R = sqrt((Y - y).^2 + (X - x).^2);
            im_inside_circle = obj.im(R <= obj.r);
            val = max(im_inside_circle)/sum(im_inside_circle);         
        end
        function DrawImage(obj)
            if size(obj.im, 1)>0
                imagesc(obj.im);         
                drawnow;          
            end
        end

    end


end