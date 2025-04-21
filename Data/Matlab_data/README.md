In this directory there are all the scripts necessary to load the JIGSAWS
dataset into MATLAB variables, in the `scripts` folder. The output of the
scripts is saved to the `.mat` files in here.

The order of execution of the scripts is:
- loadRawData: loads raw data into a cell matrix with one row per user and
        one column per experiment. There is one var for the labels (stored
        as integers) and other for the kinematic data, saved as Nx76
        matrices of doubles.
    - This outputs file Suturing_raw_data.mat
- extractFeaturesFromRaw: it extracts the 24 kinematic variables defined in
        the paper from the 76 original JIGSAWS kinematic vars. The output
        files are:
    - Suturing_features_data.mat : just that
    - Suturing_features_data_clean.mat : the same 24 extracted variables,
            with the same cell matrix structure, but with the experiment
            H002 not saved (as it has no labels)
    - Suturing_features_names.mat : strings with the names and LaTeX 
            symbols for the selected features, in the order they appear in
            the 24 vars in Suturing_features_data files.