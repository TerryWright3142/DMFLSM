classdef  MultiMode < Score 
    %returns the kurtosis score from the image (background corrected)
    properties  
       score1;
       score2;
       score3;
       score4;
       score;
    end
    
    methods 
        function obj = MultiMode()
 
        obj.score1 = Mode(90,1030, 50, 50);     
        obj.score2 = Mode(1770,1040, 50, 50);
        obj.score3 = Mode(1020,1780, 50, 50);
        obj.score4 = Mode(1020,110, 50, 50);
        obj.score = Mode(1020,1010, 50, 50);

        end

        function val = FindScore(obj, image)
            val = obj.score.FindScore(image) + obj.score1.FindScore(image) +obj.score2.FindScore(image)+obj.score3.FindScore(image)+obj.score4.FindScore(image);
   
        end

    end


end