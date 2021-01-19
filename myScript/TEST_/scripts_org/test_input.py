#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import scipy.io as sio
import csv
import sys
from sklearn.linear_model import LinearRegression

def getting_input(SUBJ, run):
    print(SUBJ)
    print(run)
    csvFile='/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/analysis/firstlevel/phase1_trialWiseGLM_train_run%s.feat/imgList_test_run%s.csv'%(SUBJ, run, run)
    print(csvFile)


SUBJ=sys.argv[1]
run=sys.argv[2]

getting_input(SUBJ, run)