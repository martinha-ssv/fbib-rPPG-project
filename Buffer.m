classdef Buffer < Queue
    properties (Access = private)
        capacity
    end

    methods
        function obj = Buffer(capacity)
            %BUFFER Construct an instance of a buffer
            if nargin < 1
                capacity = 10;
            end
            obj.capacity = capacity;
        end

        
        function enqueue(obj, value)
            %ENQUEUE Adds an element to the end of the buffer
            if length(obj.elements) == obj.capacity
                obj.dequeue();
            end
            obj.elements{end+1} = value;
        end


        function isFull = isFull(obj)
            %ISFULL Returns true if the buffer is full
            isFull = length(obj.elements) == obj.capacity;
        end

    end
end
