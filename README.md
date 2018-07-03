# Poisson Image Editing

## Useful references

This technique is explained in a very formal way in the paper:Poisson Image Editing (Patrick Perez et al. Microsoft Research UK)

A really nice and understandable tutorial on the maths behind this is : https://www.youtube.com/watch?v=UcTJDamstdk

## Description
The main goal of this implementation is to seamlessly blend a pieace of an image to another image. Of course the first we can notice is that we cannot do worse than just cropping and pasting the two images.

### First improvement
So a first nice improvement is to solve Poisson equations on the boundary conditions without considering the gradients inside the destination area.
The classic example for this algorithm is to copy and paste the eye in the middle of the hand (very creepy LOL).

![Alt text](./first_attempt.png?raw=true)


### Second improvement
The second improvement is to consider the gradients inside the destination area so that we won't blur the edges.
![Alt text](./second_attempt.png?raw=true)

## Results

### Target image
![Alt text](./results/Screen%20Shot%202018-01-07%20at%2018.53.50.png?raw=true)
### Source image 
![Alt text](./results/Screen%20Shot%202018-01-07%20at%2018.53.56.png?raw=true)
### Result
![Alt text](./results/Screen%20Shot%202018-01-07%20at%2018.53.40.png?raw=true)



# How to execute the code and Usage

I tried to keep the implementations of the different versions of the algorithm separate so that the improvements are more understandable.

To execute the code just run either:
poissonImageEditing.m
poissonImageEditing_MixingGradients.m
