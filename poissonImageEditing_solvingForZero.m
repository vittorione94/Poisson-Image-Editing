function blended_image = poissonImageEditing_solvingForZero( source, target, source_mask, target_mask )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    source = double(source);
    target = double(target);

    blended_image = target;
    [~, ~, channels] = size(source);
    % LET'S BUILD THE A MATRIX
    [~, xCoordinatesTarget] = find(target_mask);
    [~, xCoordinatesSource] = find(source_mask);
    
    n = length(xCoordinatesTarget);
    
    loc = target_mask(:);
    grid = zeros(size(target_mask));
    grid(loc) = 1:n;
    
    for channel = 1:channels
        [x, y] = find(grid);
        
        A = zeros(n,n);
        B = zeros(n,1);
        for i = 1:n %for every pixel in the mask 
            A(i, i) = 4;
            
            if target_mask(x(i)-1, y(i))  ~= 0 % if the pixel in the mask belongs to Omega
                A(i, grid(x(i)-1, y(i)) ) = -1; 
            else                        % if it doesn't add to B the target
                B(i) = target(x(i)-1, y(i),channel);
            end
            
            if target_mask(x(i)+1, y(i)) ~= 0
                A(i, grid(x(i)+1, y(i)) )  = -1;
            else
                B(i) = B(i) + target(x(i)+1, y(i),channel);
            end
            
            if target_mask(x(i), y(i)+1) ~= 0
                A(i, grid(x(i), y(i)+1) )  = -1;
            else
                B(i) = B(i) + target(x(i), y(i)+1,channel);
            end
            
            if target_mask(x(i), y(i)-1) ~= 0
                A(i, grid(x(i), y(i)-1) )  = -1;
            else
                B(i) = B(i) + target(x(i), y(i)-1,channel);
            end

        end

        A = sparse(A);
        X=A\B;
        
        for index=1:length(X)
            [x,y] = find(grid==index);
            blended_image(x,y,channel)=X(index);
        end
    end
    blended_image = uint8(blended_image);
end

