# Machine Learning Glossary

## Feature
An input value the model uses to make a prediction. For example, house size or number of bedrooms.

## Target
The value the model is trying to predict during training.

## Prediction
The model's estimated output for a given set of features.

## Model
The learned mathematical relationship used to make predictions.

## Training
The process of learning a model’s parameters from training data.

## Training Data
The collection of features and target values used to train a model.

## Weight
A learned value that determines how much influence a feature has on a prediction.

## Coefficient
Another name for a weight in linear models such as linear regression. In simple linear regression, the coefficient is 
also called the slope because it describes how much the prediction changes when the feature increases by one unit.

## Bias
A learned constant added to every prediction, also known as the intercept.

## Loss
A measure of how wrong a model's predictions are. Training aims to minimise the loss.

## Mean Squared Error (MSE)
A common regression loss that measures the average squared difference between predictions and target values.

## Iteration
A single update of a model's parameters during training.

## Gradient Descent
An optimisation algorithm that repeatedly adjusts a model's parameters to reduce the loss.

## Learning Rate
How large each gradient descent update should be.

## Feature Scaling
Transforming features so they have similar ranges, often improving optimisation.

## RMSE
A regression metric measuring the typical prediction error in the original units.

## Residual
The difference between a model's prediction and the actual target value for a single training example.

## Residual Analysis
The process of examining a model's residuals to look for patterns in its prediction errors. Randomly scattered residuals suggest the model is capturing the relationship well, while clear patterns may indicate the model is missing something.

## R² (Coefficient of Determination)
A regression metric that measures how well a model explains the variation in the target values. An R² of 1 means the model predicts the data perfectly.

## Adjusted R²
A version of R² that accounts for the number of features in a model. It penalises unnecessary features, making it fairer to compare models with different numbers of features.

## Regularisation
A technique that discourages a model from learning unnecessarily large weights. This can reduce overfitting and help the model make better predictions on unseen data.

## Ridge Regression
A type of regularisation that adds a penalty based on the squared size of the model's weights during training. It encourages smaller weights while still fitting the training data.

## Lambda (λ)
The regularisation strength used by ridge regression. A value of 0 applies no regularisation, while larger values shrink the weights more strongly.

## Logistic Regression
A classification model that predicts the probability of one of two possible outcomes.

## Binary Classification
A prediction problem with two possible classes, such as churned/stayed or fraud/not fraud.

## Sigmoid
A function that converts a model's raw score into a value between 0 and 1 that can be treated as a probability.

## Log Loss
A classification loss that measures how good a model's predicted probabilities are. It penalises confident wrong predictions more heavily.

## Classification Threshold
The cutoff used to turn a predicted probability into a class. For example, with a threshold of 0.5, probabilities of 0.5 or higher become 1.

## Decision Boundary
The point or boundary where the model switches from predicting one class to the other. With a 0.5 threshold, this is where the predicted probability is exactly 0.5.

## Positive Class / Negative Class
In binary classification, the positive class is the outcome represented by 1 that the model is trying to detect. The negative class is the opposite outcome, represented by 0.

## Accuracy
The proportion of predictions the model got correct overall.

## Confusion Matrix
A breakdown of binary classification predictions into true positives, false positives, true negatives, and false negatives.

## Precision
Of everything the model predicted as positive, the proportion that was actually positive.

## Recall
Of everything that was actually positive, the proportion the model correctly identified.

## F1 Score
A score that combines precision and recall, with a low value in either one pulling the F1 score down.

## AUC (Area Under the ROC Curve)
A classification metric that measures how well the model ranks positive cases above negative cases. A value of 0.5 is roughly equivalent to random ranking, while 1.0 is perfect.