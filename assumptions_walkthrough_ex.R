# Load libs
library("tidyverse")
library("ds4ling")
library("patchwork")


# Fit some models
mod1 <- lm(mpg ~ wt, data = mtcars)
mod2 <- lm(dist ~ speed, data = cars[1:20, ])

summary(mod1)
summary(mod2)

# Assumptions

# 1.
# The regression model is linear in parameters
# Eyeball it

 # For mod2
cars[1:20, ] |>
  ggplot() +
  aes(x = speed, y = dist) +
  geom_point() +
  geom_smooth(method = "lm") +
  coord_cartesian(ylim = c(-10, 50), xlim = c(-15, 15))

 # It looks linear

 # For mod1

mtcars |>
  ggplot() +
  aes(x = wt, y = mpg) +
  geom_point() +
  geom_smooth(method = "lm")

 # It is linear but negative

# 2. 
# The mean of residuals is zero
# How to check?: Check model summary and test manually

mean(mod1$residuals)
mean(mod2$residuals)

# It's basically 0, close enough

# 3.
# Homoskedasticity of residuals or equal variance
# How to check? autoplot, diagnosis functions
# What are you looking for? more or less same 'blob' along x axis

diagnosis(mod1)
diagnosis(mod2)

 # Far left checks homoskedasticity, blob!!

# 4.
# No autocorrelation of residuals (important for time series data)
# When the residuals are autocorrelated, it means that the current value 
# is dependent of the previous values and that there is an unexplained 
# pattern in the Y variable that shows up

#
# How to check? 2 methods
#

# 4a. afc plot
acf(mod1$residuals)   # visual inspection
data(economics)       # bad example
bad_auto <- lm(pce ~ pop, data = economics)
acf(bad_auto$residuals)  # highly autocorrelated from the picture.


# 4b. Durbin-Watson test
# lmtest::dwtest(mod1)
# lmtest::dwtest(bad_auto)

#
# How to fix it?
#

# One option: Add lag1 as predictor and refit model
# econ_data  <- data.frame(economics, resid_bad_auto = bad_auto$residuals)
# econ_data1 <- slide(econ_data, Var = "resid_bad_auto", NewVar = "lag1", slideBy = -1)
# econ_data2 <- na.omit(econ_data1)
# bad_auto2  <- lm(pce ~ pop + lag1, data = econ_data2)

# acf(bad_auto2$residuals)
# lawstat::runs.test(bad_auto2$residuals)
# lmtest::dwtest(bad_auto2)
# summary(bad_auto2)

#
# What happened? Adding the lag variable removes the autocorrelation so now 
# we can interpret the parameter of interest.
#
# (you might never do this... we will learn a better way to deal with this later)
#



# 5. predictor and residuals are not correlated
# How to check? cor.test
cor.test(mtcars$wt, mod1$residuals)

cor.test(cars[1:20, "speed"], mod2$residuals)

# 6. 
# Normality of residuals
# (increasingly bad)
autoplot(mod1, which = 2)
autoplot(mod2, which = 2)
autoplot(bad_auto, which = 2)

diagnosis(mod1)
diagnosis(mod2)

 # The density plot gives us the info about residuals

as_tibble(mod2$residuals) |>
  ggplot() +
  aes(x = value) +
  geom_histogram(bins = 25)

as_tibble(mod1$residuals) |>
  ggplot() +
  aes(x = value) +
  geom_histogram(bins = 25)

 # Instead of looking at the histogram, you can look at the qq plot (far right)

diagnosis(mod1)
diagnosis(mod2)

#
# You can check some assumptions automatically
# (I don't really trust this method)
gvlma::gvlma(mod1)
gvlma::gvlma(mod2)
gvlma::gvlma(bad_auto)




# 0. Create project 'diagnostics'
# 1. add folders "slides", "scripts", "data"
# 2. save mtcars to "data" (write_csv)
# 3. load "mtcars" (read_csv)
# 4. walk through diagnostics in Rscript 
# 5. create xaringan slides
#   - install xaringan
#   - sections
#   - lists
#   - bold, italics
#   - r chunks
# 6. add diagnostics to slides 
# 7. try template
# 8. create repo, push, github pages
