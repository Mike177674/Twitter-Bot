## ----setup, include=FALSE-----------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(corrplot)


## -----------------------------------------------------------------
source("cleaning_function.R")


## -----------------------------------------------------------------
uncleaned_bots = read.csv("C:/Users/Owner/Desktop/Data Science Project/Twitter-Bot-Code/archive/twitter_human_bots_dataset.csv")


## -----------------------------------------------------------------
bots_cleaned = cleaning_function(uncleaned_bots)
# applying EDA recommendations
bots_FE = bots_cleaned%>%
  select(-split)%>%
  filter(account_age_days>500)%>%
  mutate(is_bot=as.logical(is_bot))


## -----------------------------------------------------------------
with_features = bots_FE%>%
  mutate(has_desc=str_length(description)!=0)%>%
  mutate(desc_length=str_length(description))%>%
  mutate(desc_space_count=str_count(description,"\\s"))%>%
  mutate(desc_period_count=str_count(description,"\\."))%>%
  mutate(desc_punct_count=str_count(description,"[:punct:]"))%>%
  mutate(bot_in_desc=str_detect(`description`,"bot"))


## -----------------------------------------------------------------
with_features = with_features%>%
  mutate(username_length=str_length(screen_name))%>%
  mutate(user_digit_count=str_count(screen_name,"\\d"))%>%
  mutate(user_punct_count=str_count(description,"[:punct:]"))%>%
  mutate(bot_in_name=str_detect(`screen_name`,"bot"))


## -----------------------------------------------------------------
with_features = with_features%>%
  mutate(friends_followers_ratio=log_friends_count/log_followers_count)


## -----------------------------------------------------------------
with_features = with_features%>%
  mutate(unknown_loc=str_detect(location,"unknown"))


## -----------------------------------------------------------------
with_features = with_features%>%
  mutate(missing_lang = lang == "")
head(with_features)


## -----------------------------------------------------------------
only_new_features=with_features%>%
  select(desc_length,desc_space_count,desc_period_count,desc_punct_count,bot_in_desc,username_length,user_digit_count,bot_in_name,friends_followers_ratio,unknown_loc,missing_lang,is_bot)

colnames(only_new_features)


## -----------------------------------------------------------------
missing_rows_df=only_new_features%>%
  mutate(missing_rows = rowSums(is.na(.)) > 0)%>%
  filter(missing_rows==TRUE)
nrow(missing_rows_df)


## -----------------------------------------------------------------
correlation = cor(only_new_features)
corrplot(correlation, method = 'color', type = "lower")


## -----------------------------------------------------------------
cor_feature = only_new_features%>%
  select(-bot_in_desc,-username_length,-user_digit_count,-bot_in_name,-friends_followers_ratio)

correlation2 = cor(cor_feature)
corrplot(correlation2, method = 'number', type = "lower")


## -----------------------------------------------------------------
ggplot(data = bots_FE, mapping = aes(x=str_length(description)!=0,fill=is_bot))+
  geom_histogram(stat="count",color = "black")+
  ggtitle("Accounts with Description")+
  xlab("Has a Description")+
  ylab("Count")+
  theme_minimal()


has_description_model = glm(is_bot~has_desc, data = with_features, family = binomial)

summary(has_description_model)


## -----------------------------------------------------------------
ggplot(data = bots_FE, mapping = aes(x=str_length(description),fill=is_bot))+
  geom_histogram()+
  ggtitle("Description Length Histogram")+
  xlab("Description Length")+
  ylab("Count")+
  theme_minimal()

model = glm(is_bot~str_length(description),data=bots_FE,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = bots_FE%>%filter(description!=""), mapping = aes(str_count(description,"\\s"),fill=is_bot))+
  geom_histogram()+
  ggtitle("Space Count Histogram")+
  xlab("Space Count")+
  ylab("Count")+
  theme_minimal()

model = glm(is_bot~str_count(description,"\\s"),data=bots_FE,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = bots_FE%>%filter(description!=""), mapping = aes(str_count(description,"\\."),fill=is_bot))+
  geom_histogram()+
  ggtitle("Description Period Count")+
  xlab("Number of Periods in Description")+
  ylab("Count")+
  theme_minimal()

model = glm(is_bot~str_count(description,"\\."),data=bots_FE,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = bots_FE%>%filter(description!=""), mapping = aes(str_count(description,"[:punct:]"), fill=is_bot))+
  geom_histogram()+
  ggtitle("Description Punctuation Count")+
  xlab("Number of Punctuation in Description")+
  ylab("Count")+
  theme_minimal()

model = glm(is_bot~str_count(description,"[:punct:]"),data=bots_FE,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(bot_in_desc, fill=is_bot))+
  geom_bar()+
  ggtitle("Bot in description vs being bot")+
  xlab("Word bot in Description")+
  ylab("Count")+
  scale_y_log10()+
  theme_minimal()

model = glm(is_bot~bot_in_desc,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(username_length, fill=is_bot))+
  geom_histogram()+
  ggtitle("Username Length")+
  xlab("Number of Characters in Username")+
  ylab("Count")+
  theme_minimal()

model = glm(is_bot~username_length,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(user_digit_count, fill=is_bot))+
  geom_histogram()+
  ggtitle("Username Digits")+
  xlab("Number of Digits in Username")+
  ylab("Count")+
  theme_minimal()

model = glm(is_bot~user_digit_count,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(user_punct_count, fill=is_bot))+
  geom_histogram()+
  ggtitle("Username Punctuation")+
  xlab("Number of Punctuation in Username")+
  ylab("Count")+
  theme_minimal()

model = glm(is_bot~user_punct_count,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(bot_in_name, fill=is_bot))+
  geom_bar()+
  ggtitle("Bot in name vs being bot")+
  xlab("Word bot in Username")+
  ylab("Count")+
  scale_y_log10()+
  theme_minimal()

model = glm(is_bot~bot_in_name,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(friends_followers_ratio, fill=is_bot))+
  geom_histogram()+
  ggtitle("Friends to Followers Ratio")+
  xlab("Ratio")+
  ylab("Count")+
  scale_y_log10()+
  theme_minimal()

model = glm(is_bot~friends_followers_ratio,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(unknown_loc, fill=is_bot))+
  geom_bar()+
  ggtitle("Unkown Location")+
  xlab("Unkown Location")+
  ylab("Count")
  theme_minimal()

model = glm(is_bot~unknown_loc,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
ggplot(data = with_features, mapping = aes(missing_lang, fill=is_bot))+
  geom_bar()+
  ggtitle("Missing Language")+
  xlab("Missing Language")+
  ylab("Count")
  theme_minimal()

model = glm(is_bot~missing_lang,data=with_features,family = binomial)
summary(model)


## -----------------------------------------------------------------
final_df = with_features%>%
  select(-username_length)
colnames(final_df)


## -----------------------------------------------------------------
feature_function = function(data){
  # run data cleaning function
  cleaned = data%>%
   #  remove unnecessary columns
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
    
     #cast and rename account_type
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
  
  
  
  final = cleaned %>% 
    # apply EDA recommendations
    select(-split)%>%
    filter(account_age_days>500)%>%
    # add new features
    mutate(is_bot=as.logical(is_bot))%>%
    mutate(has_desc=str_length(description)!=0)%>%
    mutate(desc_length=str_length(description))%>%
    mutate(desc_space_count=str_count(description,"\\s"))%>%
    mutate(desc_period_count=str_count(description,"\\."))%>%
    mutate(desc_punct_count=str_count(description,"[:punct:]"))%>%
    mutate(bot_in_desc=str_detect(`description`,"bot"))%>%
    mutate(user_digit_count=str_count(screen_name,"\\d"))%>%
    mutate(user_punct_count=str_count(description,"[:punct:]"))%>%
    mutate(bot_in_name=str_detect(`screen_name`,"bot"))%>%
    mutate(friends_followers_ratio=log_friends_count/log_followers_count)%>%
    mutate(unknown_loc=str_detect(location,"unknown"))%>%
    mutate(missing_lang = lang == "")
  
  return(final)
}

