### Twitter Bot Detection
# Dataset
This Dataset can be found on Kaggle (licensed under CC0: Public Domain).
A significant number of accounts of X (formerly Twitter) are bots. The authors of this data set have collected user-profiles and associated tweet data, along with a binary label indicating whether each user is a bot or not. 
# Objectives
The main objective of this project is to:
***Develop a system that can detect which X accounts are bots from tweet data associated with the account***
To achieve this objective, it was further broken down into five technical sub-objectives:
1. To perform in-depth exploratory data analysis of the dataset
2. To develop new predictive features using this data
3. To develop a logistic regression model that classifies each account into bot or human
4. To recommend a threshold with the highest f-score
5. To create an API endpoint for the trained model and deploy it
# Main Insights
From the exploritory data analysis, we found that bot accounts are characterized by:
1. a
2. b
3. c
# Engineered Features
From the provided data set, the following features were extracted:
+a
+b
+c
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
