from pyod.utils.data import generate_data
import matplotlib.pyplot as plt
from pyod.models.knn import KNN
from sklearn.metrics import confusion_matrix, balanced_accuracy_score, roc_curve
import numpy as np


# Ex. 1
X_train, X_test, y_train, y_test = generate_data(n_train=400, n_test=100, n_features=2, contamination=0.1)

inliers = X_train[y_train == 0]
outliers = X_train[y_train == 1]

# plt.scatter(inliers[:, 0], inliers[:, 1], color='blue', label='Inliers')
# plt.scatter(outliers[:, 0], outliers[:, 1], color='red', label='Outliers')

# plt.legend()
# plt.show()

# Ex. 2
clf = KNN(contamination=0.1)
clf.fit(X_train)

X_pred_train = clf.predict(X_train)
X_pred_test = clf.predict(X_test)

CM_train = confusion_matrix(y_train, X_pred_train)
CM_test = confusion_matrix(y_test, X_pred_test)

TPR_train = CM_train[1, 1] / (CM_train[1, 1] + CM_train[1, 0])
TNR_train = CM_train[0, 0] / (CM_train[0, 0] + CM_train[0, 1])
BA_train = (TPR_train + TNR_train) / 2

TPR_test = CM_test[1, 1] / (CM_test[1, 1] + CM_test[1, 0])
TNR_test = CM_test[0, 0] / (CM_test[0, 0] + CM_test[0, 1])
BA_test = (TPR_test + TNR_test) / 2

fpr, tpr, thresholds = roc_curve(y_test, clf.decision_function(X_test))

plt.plot(fpr, tpr)
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.show()

# Ex. 3
X_train, X_test, y_train, y_test = generate_data(n_train=1000, n_test=1, n_features=1, contamination=0.1)

mean = np.mean(X_train)
std = np.std(X_train)

z_scores = (X_train - mean) / std

z_threshold = np.quantile(np.abs(z_scores), 1 - 0.1)

y_pred = (np.abs(z_scores) > z_threshold).astype(int)

balanced_acc = balanced_accuracy_score(y_train, y_pred)

print(balanced_acc)


