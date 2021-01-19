#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 13 13:09:31 2020

@author: ghootaekim
"""
from regression import *
from sklearn.linear_model import LinearRegression
import sys

def run_reg(run):
    
    lat, act = return_latent_arr('/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/primeRecon_02/analysis/firstlevel/phase1_trialWiseGLM_train_run1.feat/imgList_test_run1.csv', '/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/primeRecon_02/analysis/firstlevel/phase1_trialWiseGLM_train_run1.feat/stats/tstat_masked_pat_test_run1.mat')
    lat.shape, act.shape
    
    x , y = act[:10], lat
    print(x.shape, y.shape)
    line_fitter = LinearRegression()
    line_fitter.fit(x, y)
    
    W = line_fitter.coef_
    print(W.shape)
    
    mdic = {"w": W}
    
    file_name = 'test_run%s.mat'%run
    sio.savemat(file_name, mdic)
    print(file_name)
    

run=sys.argv[1]
run_reg(run)
    
    

