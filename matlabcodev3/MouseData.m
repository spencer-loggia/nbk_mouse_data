classdef MouseData
    properties
        name
        correct
        incorrect
        total
        accuracy
        pokeUpCorrect
        pokeDownCorrect
        waterUsed
    end
    
    methods
        function obj=MouseData(name, correct, total, pointUpCorrect)
            obj.name = name;
            obj.correct = correct;
            obj.total = total;
            obj.pokeUpCorrect = pointUpCorrect;
            
            obj.incorrect = total - correct;
            obj.accuracy = correct/total;
            obj.pokeDownCorrect = total - pointUpCorrect;
            obj.waterUsed = correct/100;
        end
        
        function data = toColumn(obj)
            data = [obj.correct; obj.incorrect; obj.total; obj.accuracy; obj.pokeUpCorrect; obj.pokeDownCorrect; obj.waterUsed];
        end
        
    end
end