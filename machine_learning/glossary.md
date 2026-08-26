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

## Weight Norm
A single number that represents the overall size of a model's weights. It can be used to see how strongly regularisation has shrunk the weights.

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

## Threshold Tuning
Trying different classification thresholds while keeping the model's predicted probabilities the same. Changing the threshold only changes which predictions become the positive class, which can affect precision and recall.

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

## Euclidean Distance
The straight-line distance between two points. KNN uses it to measure how similar two examples are: smaller distance means the examples are more similar.

## K-Nearest Neighbours (KNN)
A model that predicts using the k most similar stored examples. Classification uses a majority vote, while regression averages their numeric values.

## k
The number of nearest neighbours KNN considers when making a prediction. Small values are more sensitive to individual points, while larger values produce smoother, more averaged predictions.

## Lazy Learner
A model that does little or no training and instead does most of its work when making a prediction. KNN is a lazy learner because it mainly stores the training data.

## Weighted KNN
A version of KNN where closer neighbours have more influence than farther neighbours, usually by giving them a larger weight based on distance.

## Gini Impurity
A measure of how mixed the class labels are in a group. A value of 0 means the group is pure, while higher values mean the labels are more mixed.

## Gain
A measure of how much a split reduces impurity. A larger gain means the split separates the labels more effectively.

## Node
A point in a decision tree where the model either asks a question about a feature or returns a prediction.

## Branch
A path from a node created by one possible answer to the node's question.

## Leaf
The end of a decision tree branch containing the final prediction.

## Max Depth
The maximum number of levels a decision tree is allowed to grow. Limiting depth can reduce overfitting, but if the tree is too shallow it can miss useful patterns and underfit.

## Overfitting
When a model learns the training data too specifically, including noise or accidental patterns, so it performs very well on the training data but may perform poorly on unseen data.

## Numeric Threshold Split
A decision tree split for a numeric feature that sends values on one side of a threshold down one branch and values on the other side down another. The tree tries possible thresholds and keeps the one with the highest gain.