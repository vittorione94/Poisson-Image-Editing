function resulting_image = localIlluminationChange( source, source_mask)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    source = double(source);
    resulting_image = source;
    
    [~, ~, channels] = size(source);
    % LET'S BUILD THE A MATRIX
    [~, xCoordinatesTarget] = find(source_mask);
    
    n = length(xCoordinatesTarget);
    
    loc = source_mask(:);
    grid = zeros(size(source_mask));
    grid(loc) = 1:n;
    
    beta = 0.1;
    laplacian_kernel=[0 -1 0; -1 4 -1; 0 -1 0];
    for channel = 1:channels
        [x, y] = find(grid);
        A = zeros(n,n);
        B = zeros(n,1);        
        s = (source(:,:,channel));
        
        lap=conv2(s,laplacian_kernel,'same');
        %lap = lap.*not_sourceMask;
        alpha = 0.25 * norm(lap.*source_mask)/n; 
        %alpha = 0.09 * sum(sum(tmp))/n; 
        %nan_mask = isnan(lap);
        %lap(nan_mask) = 0;
        for i = 1:n %for every pixel in the mask
            
            A(i,i) = 4;
            
            if source_mask(x(i)-1, y(i))  ~= 0 % if the pixel in the mask belongs to Omega
                A(i, grid(x(i)-1, y(i)) ) = -1; 
            else                               % if it doesn't add to B the target
                B(i) = source(x(i)-1, y(i),channel);
            end
            
            if source_mask(x(i)+1, y(i)) ~= 0
                A(i, grid(x(i)+1, y(i)) )  = -1;
            else
                B(i) = B(i) + source(x(i)+1, y(i),channel);
            end
            
            if source_mask(x(i), y(i)+1) ~= 0
                A(i, grid(x(i), y(i)+1) ) = -1;
            else
                B(i) = B(i) + source(x(i), y(i)+1,channel);
            end
            
            if source_mask(x(i), y(i)-1) ~= 0
                A(i, grid(x(i), y(i)-1) )  = -1;
            else
                B(i) = B(i) + source(x(i), y(i)-1,channel);
            end            
            
            if magnitude(lap(x(i), y(i))) ~= 0
                B(i) = B(i) + alpha^beta * (norm(lap(x(i), y(i)))^(-beta)) *lap(x(i), y(i));
            end
            
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

