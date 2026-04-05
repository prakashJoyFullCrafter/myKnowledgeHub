# Deep Learning Projects - Curriculum

Neural network projects from basic to advanced, covering vision, NLP, and generative AI.

---

## Project 01: Neural Network Fundamentals
- [ ] **MNIST Digit Classifier** (Hello World of DL)
  - [ ] Build with TensorFlow/Keras Sequential API
  - [ ] Rebuild with PyTorch from scratch
  - [ ] Experiment: activation functions, optimizers, layers
  - [ ] Visualize training loss/accuracy curves
  - [ ] Achieve >98% accuracy

## Project 02: Convolutional Neural Networks (CNN)
- [ ] **CIFAR-10 Image Classifier**
  - [ ] Build CNN from scratch: Conv2D -> ReLU -> MaxPool -> Dense
  - [ ] Data augmentation: flip, rotate, crop, color jitter
  - [ ] Batch normalization and dropout
  - [ ] Compare architectures: simple CNN vs deeper models
  - [ ] Learning rate scheduling

## Project 03: Transfer Learning
- [ ] **Custom Image Classifier** (your own dataset)
  - [ ] Collect/organize custom image dataset (min 5 classes)
  - [ ] Fine-tune ResNet50 / EfficientNet / ViT
  - [ ] Freeze/unfreeze layers strategy
  - [ ] Grad-CAM visualization (what the model sees)
  - [ ] Export to TFLite / ONNX for deployment

## Project 04: NLP with Transformers
- [ ] **Text Classification with BERT**
  - [ ] Hugging Face `transformers` library
  - [ ] Fine-tune BERT on custom text dataset
  - [ ] Tokenization with `AutoTokenizer`
  - [ ] Training with `Trainer` API
  - [ ] Evaluate: accuracy, F1, confusion matrix
- [ ] **Question Answering System**
  - [ ] Use pre-trained QA model
  - [ ] Fine-tune on SQuAD dataset
  - [ ] Build simple QA API with FastAPI

## Project 05: Sequence Models
- [ ] **Text Generation with LSTM**
  - [ ] Character-level language model
  - [ ] Train on Shakespeare / song lyrics
  - [ ] Temperature-based sampling
- [ ] **Time Series Forecasting with LSTM**
  - [ ] Stock price prediction
  - [ ] Sequence-to-sequence architecture
  - [ ] Compare with traditional ARIMA

## Project 06: Generative AI
- [ ] **Image Generation with GAN**
  - [ ] Build DCGAN from scratch (PyTorch)
  - [ ] Train on Fashion-MNIST or CelebA
  - [ ] Visualize generator progress over epochs
  - [ ] FID score evaluation
- [ ] **Text Generation with GPT**
  - [ ] Fine-tune GPT-2 on custom corpus
  - [ ] Hugging Face `pipeline` for generation
  - [ ] Prompt engineering experiments

## Project 07: RAG (Retrieval-Augmented Generation)
- [ ] **Document Q&A System**
  - [ ] Embed documents with sentence-transformers
  - [ ] Vector store: FAISS or ChromaDB
  - [ ] Retrieve relevant chunks on query
  - [ ] Generate answers with LLM (Claude API / OpenAI)
  - [ ] Build Streamlit UI
  - [ ] Evaluate retrieval quality

## Project 08: Full Deployment Pipeline
- [ ] **End-to-End DL App**
  - [ ] Train model (any above project)
  - [ ] Build REST API with FastAPI
  - [ ] Containerize with Docker
  - [ ] CI/CD with GitHub Actions
  - [ ] Deploy to cloud (AWS/GCP)
  - [ ] Monitor with Prometheus + Grafana
  - [ ] A/B testing with model versions

---

## Tech Stack
- Python 3.10+
- TensorFlow/Keras, PyTorch
- Hugging Face Transformers
- FAISS / ChromaDB for vector search
- FastAPI for model serving
- Streamlit for UI
- Docker, GitHub Actions for CI/CD
- MLflow / Weights & Biases for experiment tracking

## Project Structure
```
04-deep-learning-projects/
├── project01_mnist/
├── project02_cnn/
├── project03_transfer_learning/
├── project04_nlp_transformers/
├── project05_sequence_models/
├── project06_generative/
├── project07_rag/
├── project08_deployment/
├── requirements.txt
└── README.md
```

## Recommended Order
1. MNIST (fundamentals) -> CNN (vision basics) -> Transfer Learning (practical vision)
2. NLP with Transformers -> Sequence Models -> Generative AI -> RAG
3. Full Deployment Pipeline (after completing any 2-3 projects above)
