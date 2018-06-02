function [ resulting_image ] = flattening( source_image,source_mask )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    source = double(source_image);
    resulting_image = source;
    
    [~, ~, channels] = size(source);
    
    [~, xCoordinatesTarget] = find(source_mask);
    n = length(xCoordinatesTarget);
    loc = source_mask(:);
    grid = zeros(size(source_mask));
    grid(loc) = 1:n;
    for channel = 1:channels
        [x, y] = find(grid);
        A = zeros(n,n);
        B = zeros(n,1);        
        s = source(:,:,channel);
        
        edge_detected = edge(s,'canny', 0.01);
        for i = 1:n %for every pixel in the mask
            
            A(i,i) = 4;
            
            if source_mask(x(i)-1, y(i))  ~= 0 % if the pixel in the mask belongs to Omega
                A(i, grid(x(i)-1, y(i)) ) = -1; 
            else
                % if it doesn't add to B the target
                B(i) = s(x(i)-1, y(i));  
            end
            
            if source_mask(x(i)+1, y(i)) ~= 0
                A(i, grid(x(i)+1, y(i)) )  = -1;
            else
                B(i) = B(i) + s(x(i)+1, y(i));
            end
            
            if source_mask(x(i), y(i)+1) ~= 0
                A(i, grid(x(i), y(i)+1) ) = -1;
            else
                B(i) = B(i) + s(x(i), y(i)+1);
            end
            
            if source_mask(x(i), y(i)-1) ~= 0
                A(i, grid(x(i), y(i)-1) )  = -1;
            else
                B(i) = B(i) + s(x(i), y(i)-1);
            end            
            
            v=0;
            center = s(x(i), y(i)) ;
            
            %NORTH
            if ~(edge_detected(x(i), y(i)) || edge_detected(x(i), y(i)+1) )
                v = v + 0;
            else
                v = v + center - s(x(i), y(i)+1);
            end
            %SOUTH
            if ~(edge_detected(x(i), y(i)) || edge_detected(x(i), y(i)-1))
                v = v + 0;
            else
                v = v + center - s(x(i), y(i)-1);
            end
            %OVEST
            if ~(edge_detected(x(i), y(i)) || edge_detected(x(i)+1, y(i)) )
                v = v + 0;
            else
                v = v + center - s(x(i)+1, y(i));
            end
            %EAST
            if ~(edge_detected(x(i), y(i)) || edge_detected(x(i)-1, y(i)))
                v = v + 0;
            else
                v = v + center - s(x(i)-1, y(i));
            end
            
            B(i)= B(i) + v;
            
        end 
        
        A = sparse(A);
        X=A\B;
        
        for index=1:length(X)
            [x,y] = find(grid==index);
            resulting_image(x,y,channel)=X(index);
        end
    end
    resulting_image = uint8(resulting_image);
        
end

