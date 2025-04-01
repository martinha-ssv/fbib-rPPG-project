classdef BufferWithStorage < Buffer
    properties (Access = protected)
        storage
    end

    methods
        function obj = BufferWithStorage(capacity)
            %BUFFER Construct an instance of a buffer
            obj.storage = {};
        end

        
        function enqueue(obj, value)
            %ENQUEUE Adds an element to the end of the buffer
            if length(obj.elements) == obj.capacity
                dequeued = obj.dequeue();
                obj.storage{end+1} = dequeued;
            end
            obj.elements{end+1} = value;
        end

        
        function storedElements = getStorage(obj)
            %GETSTORAGE Returns the storage
            storedElements = obj.storage;
            storedElements = vertcat(storedElements{:});
        end
    
    end
end