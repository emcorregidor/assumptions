library(tidyverse)

 # How to save a csv

write_csv(x = mtcars, file = "./data/my_cars.csv")

 # How to load a csv

mycar <- read_csv("./data/my_cars.csv")

