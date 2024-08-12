## ----setup, include=FALSE--------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(tidyr)
library(tidyverse)
library(dplyr)
library(DescTools)


## --------------------------------------------------------------
bots = read.csv("C:/Users/Owner/Desktop/Data Science Project/Twitter-Bot-Code/archive/twitter_human_bots_dataset.csv")



## --------------------------------------------------------------
head(bots)


## --------------------------------------------------------------
nrow(bots)
bots_without_na = bots %>%
  drop_na()
nrow(bots_without_na)


## --------------------------------------------------------------
empty_char = bots %>%
  filter(str_trim(created_at)== "" | str_trim(default_profile) == "" | str_trim(default_profile_image) == "" | str_trim(geo_enabled) == ""  |  str_trim(screen_name) == "" | str_trim(verified) == "" | str_trim(account_type) == "" )
nrow(empty_char)


## --------------------------------------------------------------
empty_char = bots %>%
  filter(str_trim(description) == "")
nrow(empty_char)

## --------------------------------------------------------------
empty_char = bots %>%
  filter(str_trim(lang) == "")
nrow(empty_char)

## --------------------------------------------------------------
empty_char = bots %>%
  filter(str_trim(location) == "")
nrow(empty_char)

## --------------------------------------------------------------
empty_char = bots %>%
  filter(str_trim(location) == "unknown")
nrow(empty_char)


## --------------------------------------------------------------
class(bots$created_at)
class(bots$default_profile)
class(bots$default_profile_image)
class(bots$description)
class(bots$favourites_count)
class(bots$followers_count)
class(bots$friends_count)
class(bots$geo_enabled)
class(bots$id)
class(bots$lang)
class(bots$location)
class(bots$screen_name)
class(bots$statuses_count)
class(bots$verified)
class(bots$average_tweets_per_day)
class(bots$account_age_days)
class(bots$account_type)
class(bots$split)



## --------------------------------------------------------------
ggplot(data = bots, mapping = aes(favourites_count))+
  geom_boxplot()+
  scale_x_log10()+
  theme_minimal()

ggplot(data = bots, mapping = aes(followers_count))+
  geom_boxplot()+
  scale_x_log10()+
  theme_minimal()

ggplot(data = bots, mapping = aes(friends_count))+
  geom_boxplot()+
  scale_x_log10()+
  theme_minimal()

ggplot(data = bots, mapping = aes(statuses_count))+
  geom_boxplot()+
  scale_x_log10()+
  theme_minimal()

ggplot(data = bots, mapping = aes(average_tweets_per_day))+
  geom_boxplot()+
  scale_x_log10()+
  theme_minimal()

ggplot(data = bots, mapping = aes(account_age_days))+
  geom_boxplot()+
  theme_minimal()


## --------------------------------------------------------------
cleaning_function = function(data) {
  cleaned = data%>%
    # remove unnecessary columns
    select(-X,-profile_image_path,-profile_background_image_path, -profile_background_image_url, -profile_image_url)%>%
   
     # standardize missing location  value
    mutate(
      location = if_else(str_trim(location) == "","unknown",location))%>%
  
    # type cast to correct class
  mutate(
    created_at = ymd_hms(created_at),
    default_profile = as.logical(default_profile),
    default_profile_image = as.logical(default_profile_image),
    geo_enabled = as.logical(geo_enabled),
    verified = as.logical(verified))%>%
    
    # cast and rename account_type
  mutate(
    account_type=if_else(account_type=="bot",1,0))%>%
  rename(is_bot=account_type)%>%
    
    # transform and winsorize outliers
    mutate(
      # log(x+1) to avoid "-inf"
      log_favourites_count = log10(favourites_count+1),
      log_followers_count = log10(followers_count+1),
      log_friends_count = log10(friends_count+1),
      log_statuses_count = log10(statuses_count+1),
      log_avg_tweets_per_day = log10(average_tweets_per_day+1)
    )%>%
    mutate(
      log_favourites_count= Winsorize(log_favourites_count),
      log_followers_count = Winsorize(log_followers_count),
      log_friends_count = Winsorize(log_friends_count),
      log_statuses_count = Winsorize(log_statuses_count),
      log_avg_tweets_per_day = Winsorize(log_avg_tweets_per_day)
    )%>%
  
  # remove old columns
  select(-favourites_count,-followers_count,-friends_count, -statuses_count, -average_tweets_per_day)
  return(cleaned)
}

bots_cleaned = cleaning_function(bots)

