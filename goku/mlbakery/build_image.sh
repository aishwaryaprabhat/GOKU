#!/bin/bash

# Set default values for image name and tag
IMAGE_NAME=ghcr.io/aishwaryaprabhat/mlbakery
IMAGE_TAG=spacy_en_core
REMOVE_PATTERNS=""
MODELS=""
DATASETS=""

# Dockerfile contents
DOCKERFILE="
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \\
    apt-get install -y g++

RUN apt-get install -y python3 python3-pip git htop

# Copy the model and dataset files into the container
WORKDIR /models
COPY models/ /models/

WORKDIR /datasets
COPY datasets/ /datasets/
"

# Function to print usage
print_usage() {
    echo "Usage: $0 [-n IMAGE_NAME] [-t IMAGE_TAG] [-m MODELS] [-d DATASETS] [-r REMOVE_PATTERNS]"
    echo "  -n IMAGE_NAME          Set the name of the Docker image (default: $IMAGE_NAME)"
    echo "  -t IMAGE_TAG           Set the tag for the Docker image (default: $IMAGE_TAG)"
    echo "  -m MODELS              Comma-separated list of Hugging Face models to download"
    echo "  -d DATASETS            Comma-separated list of Hugging Face datasets to download"
    echo "  -r REMOVE_PATTERNS     Comma-separated list of files/directories to remove from each model/dataset directory"
    echo "  -h                     Display this help message"
}

# Parse command-line arguments
while getopts "n:t:m:d:r:h" opt; do
    case $opt in
        n)
            IMAGE_NAME=$OPTARG
            ;;
        t)
            IMAGE_TAG=$OPTARG
            ;;
        m)
            MODELS=$OPTARG
            ;;
        d)
            DATASETS=$OPTARG
            ;;
        r)
            REMOVE_PATTERNS=$OPTARG
            ;;
        h)
            print_usage
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            print_usage
            exit 1
            ;;
    esac
done

# Check if at least one model or dataset is provided
if [ -z "$MODELS" ] && [ -z "$DATASETS" ]; then
    echo "Error: No models or datasets provided." >&2
    print_usage
    exit 1
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)

# Create directories for models and datasets
mkdir -p "$TEMP_DIR/models"
mkdir -p "$TEMP_DIR/datasets"

# Write Dockerfile to temporary directory
echo "$DOCKERFILE" > "$TEMP_DIR/Dockerfile"

# Download models using Hugging Face CLI
if [ -n "$MODELS" ]; then
    echo "Downloading models..."
    IFS=',' read -ra MODEL_LIST <<< "$MODELS"
    for MODEL in "${MODEL_LIST[@]}"; do
        MODEL_DIR="$TEMP_DIR/models/$(basename "$MODEL")"
        mkdir -p "$MODEL_DIR"
        huggingface-cli download "$MODEL" --local-dir "$MODEL_DIR" --repo-type model
    done
fi

# Download datasets using Hugging Face CLI
if [ -n "$DATASETS" ]; then
    echo "Downloading datasets..."
    IFS=',' read -ra DATASET_LIST <<< "$DATASETS"
    for DATASET in "${DATASET_LIST[@]}"; do
        DATASET_DIR="$TEMP_DIR/datasets/$(basename "$DATASET")"
        mkdir -p "$DATASET_DIR"
        huggingface-cli download "$DATASET" --local-dir "$DATASET_DIR" --repo-type dataset
    done
fi

# Remove specified files/directories from models and datasets
if [ -n "$REMOVE_PATTERNS" ]; then
    echo "Removing specified files/directories..."
    IFS=',' read -ra PATTERNS <<< "$REMOVE_PATTERNS"
    for PATTERN in "${PATTERNS[@]}"; do
        if [ -n "$MODELS" ]; then
            for MODEL_DIR in "$TEMP_DIR/models/"*; do
                echo "Removing $PATTERN from $MODEL_DIR"
                rm -rf "$MODEL_DIR/$PATTERN"
            done
        fi
        if [ -n "$DATASETS" ]; then
            for DATASET_DIR in "$TEMP_DIR/datasets/"*; do
                echo "Removing $PATTERN from $DATASET_DIR"
                rm -rf "$DATASET_DIR/$PATTERN"
            done
        fi
    done
fi

# Build Docker image
echo "Building Docker image $IMAGE_NAME:$IMAGE_TAG..."
docker build -t "$IMAGE_NAME:$IMAGE_TAG" "$TEMP_DIR"

# Clean up temporary directory
rm -rf "$TEMP_DIR"

echo "Docker image $IMAGE_NAME:$IMAGE_TAG built successfully."
