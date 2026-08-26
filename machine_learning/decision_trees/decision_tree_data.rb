module DecisionTreeData
  CATEGORICAL_ROWS = [
    { outlook: "overcast", wind: "weak", play: "yes" },
    { outlook: "overcast", wind: "strong", play: "yes" },
    { outlook: "sunny", wind: "weak", play: "no" },
    { outlook: "sunny", wind: "strong", play: "no" },
    { outlook: "rainy", wind: "weak", play: "yes" },
    { outlook: "rainy", wind: "weak", play: "yes" },
    { outlook: "rainy", wind: "strong", play: "no" },
    { outlook: "rainy", wind: "strong", play: "no" }
  ].freeze

  NUMERIC_ROWS = [
    { studied: 1.0, result: "fail" },
    { studied: 2.0, result: "fail" },
    { studied: 3.0, result: "fail" },
    { studied: 4.0, result: "fail" },
    { studied: 5.0, result: "pass" },
    { studied: 6.0, result: "pass" },
    { studied: 7.0, result: "pass" },
    { studied: 8.0, result: "pass" }
  ].freeze
end
