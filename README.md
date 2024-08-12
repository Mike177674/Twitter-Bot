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
From the provided data set, the following statistically significant features were extracted:
+ desc_space_count - this feature measures how many spaces/words are in the account description, and is generally lower with bots
+ bot_in_descTRUE - this feature measures if the word "bot" is in the account description, and is a marker the account is a bot
+ user_digit_count - this feature measures the number of digits in the accounts username, and is generally higher with bots
+ bot_in_nameTRUE - this feature measures if the word "bot" is in the account username, and is a marker the account is a bot
+ friends_followers_ratio - this feature measures the ratio of friends to followers of an account (active but has lack of value), and is generally higher with bots
# Model Selection
Models were compared using ROC AUC and accuracy since this is a binary classification task. The best-performing model selected by the LASSO regression algorithm is this one:
Picture of ROC and PR
<img src="https://github.com/user-attachments/assets/bace5bac-374c-4c57-9810-76b63b6531d3" width="450" alt="Description">
<img src="https://github.com/user-attachments/assets/90497e85-87fe-486f-b899-3608d3934802" width="450" alt="Description">
<img src="https://github.com/user-attachments/assets/d52594bc-0e26-4c20-8af8-b1b8a20e9bb4" width="450" alt="Description">


This chosen model is close to the full model (with all features). The final AUC for both is around 0.85, and the accuracy is around 81%. However, the LASSO regression gives confidence that this model is not overfitted. The two variables with the most considerable impact on the logistic model are bot_in_descTRUE and bot_in_nameTRUE, which means that the feature engineering was successful.
# Businesss Metrics
To determine the achieved business metrics, we first need to set the threshold for our classifier.
![image](https://github.com/user-attachments/assets/9a56b5c9-671a-4718-9765-9a95e3575928)
From the threshold analysis, we can see that the maximum accuracy we can achieve is 0.812 at a threshold of 0.46. For this project, we can assume that the business is more interested in obtaining higher accuracy than any other metric, so we set the threshold at 0.46 which gives us the following metrics:
![image](https://github.com/user-attachments/assets/9860f468-2778-4c09-8e79-6a0fd1f6e155)
# Prediction Service
