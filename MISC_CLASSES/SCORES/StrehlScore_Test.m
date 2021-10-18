classdef  StrehlScore_Test < Score 
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
        function obj = StrehlScore_Test(x, y, r)
            obj.x = x;
            obj.y = y;
            obj.r = r;
        end
        function SetBackground(obj, background)
            obj.background = background;
        end
        function val = FindScore(obj, image)
            %remove the background light
            image = double(image) - double(obj.background);
            [height, width] = size(image);
            y_sub = max(1, obj.y - obj.r) : min(obj.y + obj.r, height);
            x_sub = max(1, obj.x - obj.r) : min(obj.x + obj.r, width);
            obj.im = image(y_sub, x_sub);
            [Y, X] = meshgrid(y_sub, x_sub);
            R = sqrt((Y - obj.y).^2 + (X - obj.x).^2);
            im_inside_circle = obj.im(R <= obj.r);
            val = max(im_inside_circle)/sum(im_inside_circle);
            %obj.DrawImage(); % this will give the real time score
        end
        function DrawImage(obj)
            if size(obj.im, 1)>0
                imagesc(obj.im);         
                drawnow;          
            end
        end

    end


end