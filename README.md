# SIA_clustering

## Project Structure
This repository contains the development of clustering method on segmenting the users of the provided assignment using KMeans for detecting insightful and profitable user segments on targeting Breakfast orders.

The structure of the project is as follows:

* [src](https://github.com/panstav1/SIA_clustering/tree/main/src) - including the entire procedure of segmenting the users and general Explanatory Data Analysis
* [data](https://github.com/panstav1/SIA_clustering/tree/main/data) - including the source provided data in .parquet format 
* [environment](https://github.com/panstav1/SIA_clustering/tree/main/environment)  - including the necessary environment to execute the scripts
* [sql_scripts](https://github.com/panstav1/SIA_clustering/tree/main/sql_scripts) - including the sql scripts demanded for Task 1 & 2.

## Data Provision

The available provided data can be found [data](https://github.com/panstav1/SIA_clustering/tree/main/data) in a .parquet format. The file included a dataset spanning from 01/01/2022 - 01/02/2022.

## Strategy

The main notion of the strategy into modelling this objective is to segment the available users. Meticulous study is done in the Jupyter Notebook of [src](https://github.com/panstav1/SIA_clustering/tree/main/src)


## Installation and Dependencies
This component is implemented in Python3. Its requirements are specified in the environment.yml in the root folder. A new virtual environment would be beneficial in the installation and preferably a conda enviornment. For a Conda environment, you will need to install [Anaconda](https://www.anaconda.com/). After the entire install procedure, redirect into the `environment` folder and use:

```shell
$ conda env create -f environment.yml
```

After the run, a conda environment named `insights_efood` will be created and adequate to run the scripts, either modelling or EDA.


## Presentation

The [presentation](https://github.com/panstav1/SIA_clustering/tree/main/presentation) folder includes the visualization results from the analysis, along with comments on the 3rd part of the assignment.