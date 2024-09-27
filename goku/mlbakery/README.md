# MLBakery
![MLBakery](assets/mlbakery.webp)
MLBakery is a subproject under [goku](../../README.md) that is aimed at creating lightweight base images with AI/ML artefacts, especially small language models and embedding models, for easier portability. Some of the pre-built images are released as packages that can be found in the parent project's ghcr. Ideally, though, you will use the scripts to build your own images :)

## Example Usage
```
bash build_gguf.sh microsoft/Phi-3-mini-4k-instruct-gguf Phi-3-mini-4k-instruct-fp16.gguf
```

## Available Images

| Image                                | Source(s)             | Image Size |
|---------------------------------------|--------------------------|------------|
| [mlbakery:Phi-3-mini-4k-instruct-q4.gguf](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/215241701?tag=Phi-3-mini-4k-instruct-q4.gguf)   | [Source](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/tree/main)              | 2.83GB     |
| [mlbakery:Phi-3-mini-4k-instruct-fp16.gguf](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/215238297?tag=Phi-3-mini-4k-instruct-fp16.gguf)   | [Source](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/tree/main)              | 8.08GB   |
| [mlbakery:gemma-2b-it-q4_k_m.gguf](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/215226227?tag=gemma-2b-it-q4_k_m.gguf)     | [Source](https://huggingface.co/lmstudio-ai/gemma-2b-it-GGUF/tree/main)         | 1.93GB     |
| [mlbakery:gemma-2b-it-q8_0gguf](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/215224594?tag=gemma-2b-it-q8_0.gguf)     | [Source](https://huggingface.co/lmstudio-ai/gemma-2b-it-GGUF/tree/main)         | 3.1GB     |
| [mlbakery:spacy_en_core](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/237822329?tag=spacy_en_core) | https://huggingface.co/spacy/en_core_web_trf, https://huggingface.co/spacy/en_core_web_lg, https://huggingface.co/spacy/en_core_web_md, https://huggingface.co/spacy/en_core_web_sm | 2.93GB |
| [mlbakery:garak_v2](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/245140214?tag=garak_v2) | https://huggingface.co/leondz/artgpt2tox/, https://huggingface.co/martin-ha/toxic-comment-model/, https://huggingface.co/leondz/refutation_detector_distilbert/, https://huggingface.co/ynie/roberta-large-snli_mnli_fever_anli_R1_R2_R3-nli/ | 4.97GB |
| [mlbakery:guardrail_sbert](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/280281883?tag=guardrail_sbert) | https://huggingface.co/sentence-transformers/all-mpnet-base-v2, https://huggingface.co/sentence-transformers/paraphrase-multilingual-mpnet-base-v2 | 4.228GB |
| [mlbakery:guardrail_transformers](https://github.com/aishwaryaprabhat/goku/pkgs/container/mlbakery/280289434?tag=guardrail_transformers) | https://huggingface.co/google-bert/bert-base-uncased, https://huggingface.co/microsoft/deberta-v3-base, https://huggingface.co/valhalla/distilbart-mnli-12-3 | 7.95GB |

