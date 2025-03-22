classdef Queue < handle
    properties (Access = private)
        elements
    end



    methods
        function obj = Queue()
            %QUEUE Construct an instance of a queue
            obj.elements = {};
        end


        function enqueue(obj, value)
            %ENQUEUE Adds an element to the end of the queue
            obj.elements{end+1} = value;
        end


        function value = dequeue(obj)
            %DEQUEUE Removes the first element from the queue and returns it
            if obj.isempty()
                error('Queue:EmptyQueue', 'Cannot dequeue from an empty queue');
            end
            value = obj.elements{1};
            obj.elements{1} = [];
        end


        function isEmpty = isempty(obj)
            %ISEMPTY Returns true if the queue is empty
            isEmpty = isempty(obj.elements);
        end


        function dispQueue(obj)
            %DISPQUEUE Displays the queue
            disp(obj.elements);
        end

        
        function toMat = toMatrix(obj)
            %TOMATRIX Converts the queue to a matrix
            toMat = cell2mat(obj.elements);
        end

    end
end