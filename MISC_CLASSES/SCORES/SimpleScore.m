classdef  SimpleScore < Score 
    %takes the total from within a designated rect. Returns -log(total)
    properties  
       x
       y
       dx
       dy
       im
    end
    
    methods 
        function obj = SimpleScore(x1, y1, dx1, dy1)
            obj.x = x1;
            obj.y = y1;
            obj.dx = dx1;
            obj.dy = dy1;
        end
        function val = FindScore(obj, image)
            subImage = image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2)));
            val = entropy(double(subImage));
            obj.im = subImage;
      
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


