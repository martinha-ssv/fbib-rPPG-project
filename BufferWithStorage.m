classdef BufferWithStorage < Buffer
    properties (Access = private)
        storage
    end

    methods
        function obj = BufferWithStorage(capacity)
            %BUFFER Construct an instance of a buffer
            if nargin < 1
                capacity = 10;
            end
            obj.capacity = capacity;
            obj.storage = {};
        end

        
        function enqueue(obj, value)
            %ENQUEUE Adds an element to the end of the buffer
            if length(obj.elements) == obj.capacity
                dequeued = obj.dequeue();
            end
            obj.elements{end+1} = value;
            obj.storage{end+1} = dequeued;
        end

        function storedElements = getStorage(obj)
            %GETSTORAGE Returns the storage
            storedElements = obj.storage;
        end
    
    end
end