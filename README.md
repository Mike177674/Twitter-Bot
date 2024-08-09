### Twitter Bot Detection
# Dataset
This Dataset can be found on Kaggle (licensed under CC0: Public Domain).
A significant number of accounts of X (formerly Twitter) are bots. The authors of this data set have collected user-profiles and associated tweet data, along with a binary label indicating whether each user is a bot or not. 
# Objectives
The main objective of this project is to:
***Develop a system that can detect which X accounts are bots from tweet data associated with the account***
To achieve this objective, it was further broken down into four technical sub-objectives:
1. To perform in-depth exploratory data analysis of the dataset
2. To develop new predictive features using this data
3. To develop a logistic regression model that classifies each account into bot or human or gives the probability of being in either group
4. To create an API endpoint for the trained model and deploy it
# Main Insights
From the exploritory data analysis, we found that bot accounts are characterized by:
1. The account not having geography enabled
2. The account not being verified
3. The account using the default profile or default profile image
# Engineered Features
From the provided data set, the following useful features were extracted:
+ desc_space_count - this feature measures how many spaces/words are in the account description, and is generally lower with bots
+ bot_in_descTRUE - this feature measures if the word "bot" is in the account description, and is a marker the account is a bot
+ user_digit_count - this feature measures the number of digits in the accounts username, and is generally higher with bots
+ bot_in_nameTRUE - this feature measures if the word "bot" is in the account username, and is a marker the account is a bot
+ friends_followers_ratio - this feature measures the ratio of friends to followers of an account (active but has lack of value), and is generally higher with bots
As a result of the feature engineering work, the ROC AUC for the final model has increased by (blank) and has increased F-score by (blank).
# Model Selection
Models were compared using ROC AUC since this is a binary classification task. The best performing model is (this one):
Picture of ROC and PR
Explain the picture and benefit
# Model Explainability
Does model look expected or not?
# Businesss Metrics
To determine the achieved business metrics, we first need to set the threshold for our classifier.
Picture
From the threshold analysis, we can see that the maximum F-score we can achieve is X accros a variety of thresholds. For the purpose of this project, we can assume that the business is more interested in obtaining higher blank than black, so we set the threshold at Y which gives us the following metrics:
Chart
(Choose metric that makes most sense for the business)
# Prediction Service
