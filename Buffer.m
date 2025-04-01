classdef Buffer < Queue
    properties (Access = protected)
        capacity
        el_dim % Dimension of the elements in the buffer
    end

    methods
        function obj = Buffer(capacity, el_dim)
            %BUFFER Construct an instance of a buffer
            if nargin < 1
                capacity = 10;
            end
            obj.capacity = capacity;

            if nargin < 2
                el_dim = 1;
            end
            obj.el_dim = el_dim;

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


        function cap = getCapacity(obj)
            %GETCAPACITY Returns Buffer()'s capacity
            cap = obj.capacity;
        end


        function q = pad(obj, value, direction)
            %PAD Pads the buffer with a specified value
            if obj.isFull()
                q = obj; % returns 
                return;
            else
                padding = value * ones(obj.el_dim, obj.capacity - obj.length());
                
                if obj.isEmpty()
                    q = Buffer.queueFromMtrx(padding, obj.capacity, obj.el_dim);
                    return
                end
                
                if direction == "left"
                    mtrx = [padding, obj.toMatrix()];
                elseif direction == "right"
                    mtrx = [obj.toMatrix(), padding];
                else
                    error('Buffer:InvalidDirection', 'Direction must be "left" or "right"');
                end
                
                q = Buffer.queueFromMtrx(mtrx, obj.capacity, obj.el_dim);
            end

        end
    end

    methods (Static)
        function obj = queueFromMtrx(mtrx , capacity, el_dim)
            %QUEUEFROMMTRX Converts a matrix to a buffer
            %  mtrx: Matrix of queue elements. Each element of the queue is a column of the matrix

            obj = Buffer(capacity, el_dim);

            if isempty(mtrx)
                return;
            end

            if size(mtrx, 1) == 1 
                elements = num2cell(mtrx);
            else
                elements = num2cell(mtrx, 1);
            end

            if size(mtrx, 2) > obj.capacity
                disp('Buffer:ExceedingCapacity', 'Matrix exceeds buffer capacity. Truncating.');
            elseif size(mtrx, 2) < obj.capacity
                disp('Buffer:UnderCapacity', 'Matrix is smaller than buffer capacity. Padding with zeros.');
            end

            obj.elements = elements(end - obj.capacity + 1:end);
            obj.pad(0, "left");

        end
    end
end
