## How to Run KFP Client Example

### 1. Install miniconda

####Install miniconda
```
apt-get update; apt-get install -y wget bzip2
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

#### Check the conda command is available

```
which conda
```

#### If the conda command is not found, add Miniconda to your path:
```
export PATH=<YOUR_MINICONDA_PATH>/bin:$PATH
```

#### Create a clean Python 3 environment with a name of your choosing. 
This example uses Python 3.7 and an environment name of mlpipeline

```
conda create --name mlpipeline python=3.7
conda activate mlpipeline
```

### 2. Install the Kubeflow Pipelines SDK
```
pip3 install kfp --upgrade
```

