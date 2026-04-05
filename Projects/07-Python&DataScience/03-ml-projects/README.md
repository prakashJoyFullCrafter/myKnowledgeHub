# Machine Learning Projects - Curriculum

End-to-end ML projects covering the full pipeline: data -> model -> evaluation -> deployment.

---

## Project 01: Regression
- [ ] **House Price Prediction** (Ames Housing dataset)
  - [ ] EDA and feature engineering
  - [ ] Linear Regression, Ridge, Lasso comparison
  - [ ] Random Forest and XGBoost
  - [ ] Hyperparameter tuning with GridSearchCV
  - [ ] RMSE, MAE, R-squared evaluation
  - [ ] Feature importance analysis

## Project 02: Classification
- [ ] **Customer Churn Prediction** (Telco dataset)
  - [ ] Handle class imbalance (SMOTE, class weights)
  - [ ] Logistic Regression, Random Forest, XGBoost
  - [ ] ROC-AUC, Precision-Recall curves
  - [ ] SHAP values for model interpretability
  - [ ] Confusion matrix analysis

## Project 03: Clustering & Segmentation
- [ ] **Customer Segmentation** (Retail/E-Commerce dataset)
  - [ ] RFM feature engineering
  - [ ] K-Means with elbow method and silhouette analysis
  - [ ] DBSCAN comparison
  - [ ] PCA for visualization
  - [ ] Cluster profiling and business recommendations

## Project 04: NLP Classification
- [ ] **Sentiment Analysis** (IMDB reviews / Twitter data)
  - [ ] Text preprocessing: tokenization, stopwords, lemmatization
  - [ ] TF-IDF vectorization
  - [ ] Naive Bayes, Logistic Regression, SVM
  - [ ] Word clouds and text EDA
  - [ ] Comparison with pre-trained embeddings

## Project 05: Time Series
- [ ] **Stock Price / Sales Forecasting**
  - [ ] Time series decomposition (trend, seasonality, residual)
  - [ ] ARIMA / SARIMA
  - [ ] Prophet (Facebook)
  - [ ] Feature engineering for time series
  - [ ] Walk-forward validation

## Project 06: Recommendation System
- [ ] **Movie Recommender** (MovieLens dataset)
  - [ ] Content-based filtering (TF-IDF on genres/descriptions)
  - [ ] Collaborative filtering (user-user, item-item)
  - [ ] Matrix factorization (SVD)
  - [ ] Hybrid approach
  - [ ] Evaluation: RMSE, precision@K, recall@K

## Project 07: End-to-End ML Pipeline
- [ ] **Credit Risk Scoring**
  - [ ] Full pipeline with `sklearn.pipeline.Pipeline`
  - [ ] `ColumnTransformer` for mixed data types
  - [ ] Cross-validation with stratified K-fold
  - [ ] Model comparison dashboard
  - [ ] Save model with `joblib`
  - [ ] Serve predictions with FastAPI
  - [ ] Docker containerize the API

---

## Tech Stack
- Python 3.10+
- Scikit-Learn, XGBoost, LightGBM
- Pandas, NumPy, Matplotlib, Seaborn
- SHAP, LIME for interpretability
- FastAPI for model serving
- Docker for deployment
- MLflow for experiment tracking (optional)

## Project Structure
```
03-ml-projects/
├── project01_regression/
│   ├── notebooks/
│   ├── src/
│   ├── data/
│   └── models/
├── project02_classification/
├── project03_clustering/
├── project04_nlp/
├── project05_timeseries/
├── project06_recommender/
├── project07_pipeline/
├── requirements.txt
└── README.md
```
