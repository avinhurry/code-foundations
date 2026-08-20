

# K-Nearest Neighbours

A small Ruby implementation of K-Nearest Neighbours from scratch.

KNN predicts by finding the k most similar stored examples. For classification, the nearest neighbours vote on the label. For regression, their numeric target values are averaged.

## Concepts covered

- K-Nearest Neighbours
- Euclidean distance
- Classification
- Regression
- Choosing k
- Feature scaling (standardisation)
- Train/test splitting
- Test accuracy
- Weighted KNN
- Lazy learning

## Running the experiments

```sh
ruby machine_learning/k_nearest_neighbours/k_nearest_neighbours_experiments.rb
```

## Running the tests

```sh
rspec machine_learning/k_nearest_neighbours/k_nearest_neighbours_spec.rb
```

## KNN experiments

The experiments demonstrate how KNN behaves for both classification and regression, why feature scaling matters, how to tune k on held-out data, and how weighted voting can change a prediction.

### Classification

Using the same query with different values of k showed that the prediction can change depending on how many neighbours are allowed to vote.

- k = 1 predicted A
- k = 3 predicted B
- k = 5 predicted B

### Regression

For a query size of 4.5:

- k = 1 predicted 22
- k = 3 predicted 29

KNN regression makes a numeric prediction by averaging the target values of the nearest neighbours.

### Feature scaling

The income and age example showed why scaling is especially important for KNN.

Without standardisation, income dominated the distance calculation because its values were much larger than age values, leading to the wrong prediction of `premium`.

After standardisation, both features were on a comparable scale and the prediction changed to the correct `basic` label.

### Tuning k

The training and test example compared k values of 1, 3, 5 and 7 using held-out test accuracy.

- k = 1: 0.75 accuracy
- k = 3: 1.0 accuracy
- k = 5: 0.75 accuracy
- k = 7: 0.75 accuracy

The best value was k = 3. With 9 training examples, this also matched the common starting rule of thumb `k ≈ √n`, since √9 = 3.

### Weighted KNN

Plain KNN gives each neighbour an equal vote. Weighted KNN gives closer neighbours more influence.

In the weighted voting example:

- plain KNN predicted B
- weighted KNN predicted A

The weighted prediction was more convincing because the A neighbour was much closer to the query than the two B neighbours.

### Limitation

KNN stores the training data and does most of its work at prediction time. It can become slow on large datasets, is sensitive to irrelevant or unscaled features, and tends to work poorly when there are many dimensions.