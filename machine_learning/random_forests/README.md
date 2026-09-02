# Random Forests

A small Ruby implementation of bagging and random forests from scratch.

A random forest combines many decision trees. Each tree trains on a bootstrap sample of the data and only considers a random subset of features at each split. Their predictions are then combined to make the final prediction.

## Concepts covered

- Bagging
- Bootstrap sampling
- Random forests
- Ensembles
- Random feature subsets
- Max features
- Voting across trees
- Out-of-bag rows
- Out-of-bag accuracy
- Accuracy and stability

## Running the experiments

```sh
ruby machine_learning/random_forests/random_forest_experiments.rb
```

## Running the tests

```sh
rspec machine_learning/random_forests/random_forest_spec.rb
```

## Random forest experiments

The experiments demonstrate how bootstrap sampling creates different training sets, how a forest compares with a single decision tree, how performance changes as more trees are added, how `max_features` affects tree diversity, and how out-of-bag rows can be used to estimate performance on unseen data.

### Bootstrap sampling

A bootstrap sample has the same number of rows as the original dataset, but rows are chosen with replacement. This means some rows can appear more than once while others are left out.

With only five original values, the expected fraction that appears in one bootstrap sample is about 0.672. As the dataset gets larger, this approaches about 0.632, or 63%.

### One tree vs the forest

A single decision tree and a 100 tree random forest are trained several times using reshuffled train/test splits.

The experiment records the test accuracy for each run and compares both the average accuracy and the spread between the best and worst results.

The forest is usually more accurate on average because many different trees contribute to the final prediction instead of relying on one tree.

### Watching the crowd grow

Forests are trained with:

- 1 tree
- 5 trees
- 25 trees
- 100 trees

Each forest size is trained several times and its average test accuracy is printed.

The experiment shows how adding more trees can improve performance, while the gains usually become smaller as the forest grows and performance starts to stabilise.

### Turning the diversity dial

The experiment varies `max_features` from 1 up to all available features.

If `max_features` is small, each split is more likely to randomly look at different features, so the trees grow differently. If it is large, the same high gain features are more likely to be available and chosen by different trees, which can make the trees more similar.

The average accuracies are compared to look for a useful balance between strong individual trees and diversity across the forest.

### Out-of-bag score

Each bootstrap sample leaves some training rows out. Those rows are out of bag for that tree.

For each training row, the OOB score only uses trees that didn't see that row during training. This gives another estimate of how well the forest handles unseen data.

The experiment compares OOB accuracy with normal test set accuracy.

### Limitation

Random forests are usually more stable than a single decision tree and can reduce overfitting by averaging many different trees. They are harder to interpret than one decision tree, and training many trees requires more computation.
