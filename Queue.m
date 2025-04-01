classdef Queue < handle
    properties (Access = protected)
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
            if obj.isEmpty()
            error('Queue:EmptyQueue', 'Cannot dequeue from an empty queue');
            end
            value = obj.elements{1};
            obj.elements(1) = []; % Correctly remove the first element
        end

        function latest = getLatest(obj)
            %GETLATEST Returns the latest element of the queue
            if obj.isEmpty()
                error('Queue:EmptyQueue', 'Cannot get latest from an empty queue');
            end
            latest = obj.get(obj.length());
        end

        function el = get(obj, n)
            %GET Returns the nth element of the queue
            if n > length(obj.elements) || n < 1
                error('Queue:IndexOutOfBounds', 'Index out of bounds');
            end
            el = obj.elements{n};
        end

        function res = isEmpty(obj)
            %ISEMPTY Returns true if the queue is empty
            res = isempty(obj.elements);
        end


        function dispQueue(obj)
            %DISPQUEUE Displays the queue
            disp(obj.elements);
        end


        function toMat = toMatrix(obj)
            %TOMATRIX Converts the queue to a matrix
            if isempty(obj.elements)
                toMat = [];
            elseif length(obj.elements) == 1
                toMat = obj.elements{1}(:); % Ensure column format for a single element
            else
                toMat = vertcat(obj.elements{:})';
            end
        end

        function queueFromMtrx(obj, mtrx)
            %QUEUEFROMMTRX Converts a matrix to a queue
            if isempty(mtrx)
                obj.elements = {};
            elseif size(mtrx, 1) == 1
                obj.elements = cell2mat(mtrx);
            else
                obj.elements = cell2mat(mtrx', 1);
            end
        end


        function len = length(obj)
            %LENGTH Returns the length of the queue
            len = length(obj.elements);
        end
    end
end