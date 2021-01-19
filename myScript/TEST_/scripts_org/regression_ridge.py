#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import scipy.io as sio
import csv
import sys
from sklearn.linear_model import Ridge

def return_latent_arr(SUBJ):
    csvFile='/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/analysis/firstlevel/phase1_trialWiseGLM_train_run1.feat/imgList_cocat_train.csv'%(SUBJ)
    matfile='/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/analysis/firstlevel/phase1_trialWiseGLM_train_run1.feat/tstat_masked_pat_concat_train.mat'%(SUBJ)
    print(csvFile)
    print(matfile)

    # Latent info for each image
    f_latent = np.load('/Users/ghootaekim/fMRI_analysis/primeRecon/latentSpace/f_latent.npy', allow_pickle=True)
    m_latent = np.load('/Users/ghootaekim/fMRI_analysis/primeRecon/latentSpace/m_latent.npy', allow_pickle=True)
    

    # Image for experiment
    imgCSV = open(csvFile, 'r')
    imgCSV = csv.reader(imgCSV)
    imgList = [name for name in imgCSV]
    
    theseLatent=[]
    for idx in range(len(imgList)):
        img_info = imgList[idx][0].split('/')[-2]
        img_name = imgList[idx][0].split('/')[-1]


        if img_info == 'female':
            latent = f_latent
        else: latent = m_latent

        thisLatent = latent[latent[:,0]==img_name][0][1][0]
        theseLatent.append(thisLatent)
   

    # Activation pattern from experiment      
    activMat = sio.loadmat(matfile)
    activArr = activMat['tstat_masked_pat_concat_train']
    
    theseActiv=[]
    for idx in range(len(activArr[0])):


        thisActiv = activArr[:,idx]
        theseActiv.append(thisActiv)
        
    return np.array(theseLatent), np.array(theseActiv)


SUBJ=sys.argv[1]

lat, act = return_latent_arr(SUBJ)
print(lat.shape)
print(act.shape)
    
x , y = act[:1000], lat
print(x.shape, y.shape)
line_fitter = Ridge(alpha=1.0)
line_fitter.fit(x, y)
    
W = line_fitter.coef_
print(W.shape)
    
mdic = {"train_w": W}

outputFile = '/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/analysis/firstlevel/phase1_trialWiseGLM_train_run1.feat/train_reg_ridge_weights.mat'%(SUBJ)
sio.savemat(outputFile, mdic)
print(outputFile)