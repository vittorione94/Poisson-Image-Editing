function blended_image = poissonImageEditing( source, target, source_mask, target_mask )
% In this file we want to blend a region of a source image 
% to a region in the target image.
% In this function we achive this by importing the gradients gradients 
% of the source image into the target image.
% This is done solving a system of differential equations.
% So this system is built with two matricies: A and b
% A will be a sparse matrix (meaning there a re a lot of zeros, some -1 and 4's on the 
% diagonal). There will be a -1 if the neighbour pixel we're examining is
% in the mask otherwise we add the intensity of that neighbour pixel to b.
% We're not done yet we need to subtract the second order derivative of the
% source image in the matching location in the Omega area (in the code is much more clear).
% how we take the second order derivtive in the x and y direction in an
% image ? with the laplacian operator which can be approximated by the
% kernel : [0 1 0; 1 -4 1; 0 1 0].
% Now we need to solve the system we can use the '\' Matlab operator to do
% so.
% Now we need to plug the solutions in the correct matching pixels in the
% area.
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
    % grid is like a map and what I mean by that is we'll have non zeros
    % values only where the mask is applied, and the values in these are
    % will be numbered from 1 to n (which is the number of pixels in the
    % mask).
    grid(loc) = 1:n;
    
    n = length(xCoordinatesSource);
    loc = source_mask(:);
    gridSource = zeros(size(source_mask));
    gridSource(loc) = 1:n;
    
    laplacian_kernel=[0 1 0; 1 -4 1; 0 1 0];
        
    for channel = 1:channels
        [x, y] = find(grid);
        
        A = zeros(n,n);
        B = zeros(n,1);
        lap=conv2(source(:,:,channel),laplacian_kernel);
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
            [x_source, y_source] = find(gridSource == grid(x(i), y(i)));
            B(i)=B(i)-lap(x_source, y_source);
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

