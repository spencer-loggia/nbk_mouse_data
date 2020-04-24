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
        function obj=MouseData(name, correct, incorrect, missed, total, accuracy, pokeUpCorrect, pokeDownCorrect)
            obj.name = name;
            obj.correct = correct;
            obj.total = total;
            obj.pokeUpCorrect = pokeUpCorrect;
            
            obj.incorrect = incorrect;
            obj.accuracy = accuracy;
            obj.pokeDownCorrect = pokeDownCorrect;
            obj.waterUsed = correct/100;
        end
        
        function data = toColumn(obj)
            data = [obj.correct; obj.incorrect; obj.total; obj.accuracy; obj.pokeUpCorrect; obj.pokeDownCorrect; obj.waterUsed];
        end
        
    end
end