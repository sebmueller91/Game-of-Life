% Designations
% 0 = Empty
% 1 = Grass
% 2 = Rabbit
% 3 = Fox

function GameOfLife
  % Declare paramters
  x_dim = 30; 
  y_dim = x_dim;
  initial_grass_density = 0.7;
  initial_rabbit_density = 0.25;
  initial_fox_density = 0.05;
  number_timesteps = 300000;
  p_death = 10;
  
  % Declare variables
  field = InitializeField(x_dim, y_dim, initial_grass_density, 
                          initial_rabbit_density, initial_fox_density);
  grass_population = zeros(1,number_timesteps+1);
  rabbit_population =  zeros(1,number_timesteps+1);
  fox_population = zeros(1,number_timesteps+1);                          
  
  [grass_population, rabbit_population, fox_population] = CountPopulations(field,
                                                                           grass_population, 
                                                                           rabbit_population, 
                                                                           fox_population,
                                                                           1);
  % Do simulation
  for i=1:number_timesteps
    field = DoTimestep(field, p_death);
    [grass_population, rabbit_population, fox_population] = CountPopulations(field,
                                                                             grass_population, 
                                                                             rabbit_population, 
                                                                             fox_population,
                                                                             i+1);
  end
  
  % Plot results
  x = 1:size(rabbit_population,2);
  
  plot(x,rabbit_population);
  hold on;
  plot(x,fox_population);
  hold on;
  %plot(x,grass_population);
  %hold on;
  legend('rabbits', 'foxes');
  %legend('rabbits', 'foxes', 'grass');
end

function field = InitializeField(x_dim, y_dim, initial_grass_density, 
                                 initial_rabbit_density, initial_fox_density) 
  idx0 = 1;
  idx1 = initial_grass_density * x_dim*y_dim;
  idx2 = idx1 + initial_rabbit_density * x_dim*y_dim; 
  idx3 = x_dim*y_dim; 
     
  indices = randperm(x_dim*y_dim);
  field = zeros(1,x_dim*y_dim);
  
  field(indices(idx0:idx1)) = 1;
  field(indices(idx1:idx2)) = 2;
  field(indices(idx2:idx3)) = 3;
  
  field = reshape(field, [x_dim,y_dim]);
end

function [grass_population, rabbit_population, fox_population] = CountPopulations(field,
                                                                                  grass_population, 
                                                                                  rabbit_population, 
                                                                                  fox_population,
                                                                                  idx)
         
  grass_population(idx) = sum(sum(field == 1));   
  rabbit_population(idx) = sum(sum(field == 2));
  fox_population(idx) = sum(sum(field == 3));
end

function field = DoTimestep(field, p_death)
  x = randperm(size(field,1),1);
  y = randperm(size(field,2),1);
  
  % Cell = Empty
  if (field(x,y) == 0) 
    field(x,y) = 1;
  % Cell = Grass
  elseif (field(x,y) == 1) 
    for i=x-1:x+1
      for j=y-1:y+1
        if (i < 1 || i > size(field,1) ||
            j < 1 || j > size(field,1))
           continue; 
        end
        if (field(i,j) == 0)
          field(i,j) = 1;
        elseif (field(i,j) == 2)
          field(x,y) = 2;
        end
      end
    end
  % Cell = Rabbit
  elseif (field(x,y) == 2) 
    for i=x-1:x+1
      for j=y-1:y+1
        if (i < 1 || i > size(field,1) ||
            j < 1 || j > size(field,1))
           continue; 
        end
        if (field(i,j) == 1)
          field(i,j) = 2;
        elseif (field(i,j) == 3)
          rand = randperm(100,1);
          if (rand >= p_death)
            field(x,y) = 3;      
          end    
          field(i,j) = 0;          
        end
      end
    end
  % Cell = Fox
  else 
    field(x,y) == 0;
    rand = randperm(100,1);
    if (rand >= p_death)
      for i=x-1:x+1
        for j=y-1:y+1
          if (i < 1 || i > size(field,1) ||
              j < 1 || j > size(field,1))
             continue; 
          end
          if (field(i,j) == 2)
            field(i,j) = 3;
          end
        end
      end
    else
      field(x,y) = 0;
    end
  end
end