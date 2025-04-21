# uma-lapsuture-gestures-recognition

This repository contains the code that evolved into the paper ["Laparoscopic Suture Gestures Recognition via Machine Learning: A Method for Validation of Kinematic Features Selection"](https://ieeexplore.ieee.org/document/10799090) (DOI [10.1109/ACCESS.2024.3516949](https://www.doi.org/10.1109/ACCESS.2024.3516949)).

## Abstract

>In minimally invasive surgery, robotics integration has been crucial, with a current focus on developing collaborative algorithms to reduce surgeons’ workload. Effective human-robot collaboration requires robots to perceive surgeons’ gestures during interventions for appropriate assistance. Research in this task has utilized both image data, mainly using Deep Learning and Convolutional Neural Networks, and kinematic data extracted from the surgeons’ instruments, processing kinematic sequences with Markov models, Recurrent Neural Networks and even unsupervised learning techniques. However, most studies that develop recognition models with kinematic data do not take into account any study of the significance that each kinematic variable plays in the recognition task, allowing for informed decisions at the time of training simpler models and choosing the sensor systems in deployment platforms. For that purpose, this work models the laparoscopic suturing manoeuvre as a set of simpler gestures to be recognized and, using the ReliefF algorithm on the JIGSAWS dataset’s kinematic data, presents a study of significance of the different kinematic variables. To validate this study, three classification models based on the multilayer perceptron and on Hidden Markov Models have been trained using both the complete set of variables and a reduced selection including only the most significant. The results show that the aperture angle and orientation of the surgical tools retain enough information about the chosen gestures that the accuracy does not vary between equivalent models by more than 5.84% in any case.

## Running the code

This code was developed using MATLAB R2022b and all files are prepared to be run from the repository root directory. As the code uses the JIGSAWS dataset, it is necessary to download it from [here](https://cirl.lcsr.jhu.edu/research/hmm/datasets/jigsaws_release/) and place the unziped folders under the `Data/` directory. The code is organized as follows:

- `Data/`: Contains the JIGSAWS dataset and the preprocessed data used in the paper. More info on how to preprocess the data to be used later in [this file](Data/Matlab_data/README.md).
- `Common/`: Contains code that is common to all models, such as:

    - `Common/Data_discretization/`: scripts to discretize continuous kinematic variables into discrete values with the k-means algorithm, for the HMM based models.
    - `Common/Feature_selection/`: scripts to perform the feature selection using the ReliefF algorithm. Also scripts testing NCA and PCA approaches.
    - `Common/PCA/`: scripts to analyze the dataset using PCA.
    - `Common/functions/`: misc functions used across the repository.

- `Comparison/`: Contains scripts used for generating figures for comparison between models.
- `Utils/`: Contains scripts to generate the figures used in the paper.
- `HMM/`: Contains the code to train and test the models using the HMM, with one HMM per gesture.
- `VMM/`: Contains the code to train and test the models using the HMM, approach, with one HMM per the hole suturing manoeuvre.
- `MLP/`: Contains the code to train and test the models using the Multilayer Perceptron (MLP) approach.
- `docs/`: Contains the code to generate the Github pages documentation. The code was generated using [this template](https://github.com/eliahuhorwitz/Academic-project-page-template). 

> [!WARNING]
> The code layout of this repository has been restructured significantly from the original version and not all the scripts have been tested after the restructuring as that is an ongoing process. If any script does not work, please open an issue and I will try to fix it as soon as possible.

## Citing

If you consider this work useful for your research, please cite the paper as follows:

```bibtex
@ARTICLE{10799090,
  author={Herrera-López, Juan M. and Galán-Cuenca, Álvaro and Reina, Antonio J. and García-Morales, Isabel and Muñoz, Víctor F.},
  journal={IEEE Access},
  title={Laparoscopic Suture Gestures Recognition via Machine Learning: A Method for Validation of Kinematic Features Selection},
  year={2024},
  volume={12},
  number={},
  pages={190470-190486},
  keywords={Surgery;Kinematics;Needles;Hidden Markov models;Robots;Data models;Laparoscopes;Data mining;Image recognition;Vectors;Feature selection;hidden Markov models;laparoscopic suturing;neural networks;surgical gestures recognition;surgical robotics},
  doi={10.1109/ACCESS.2024.3516949}}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.