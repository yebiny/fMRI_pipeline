#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import scipy.io as sio
import csv
import sys

def test_latentMat(SUBJ):
    csvFile_run1='/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/inter_output/gen_actPat/imgList_test_run1.csv'%(SUBJ)
    csvFile_run2='/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/inter_output/gen_actPat/imgList_test_run2.csv'%(SUBJ)
    

    # Latent info for each image
    f_latent = np.load('/Users/ghootaekim/fMRI_analysis/primeRecon/latentSpace/f_latent.npy', allow_pickle=True)
    m_latent = np.load('/Users/ghootaekim/fMRI_analysis/primeRecon/latentSpace/m_latent.npy', allow_pickle=True)
    
    # ############### first run
    # Image for experiment
    imgCSV = open(csvFile_run1, 'r')
    imgCSV = csv.reader(imgCSV)
    imgList = [name for name in imgCSV]
    
    theseLatent_run1=[]
    for idx in range(len(imgList)):
        img_info = imgList[idx][0].split('/')[-2]
        img_name = imgList[idx][0].split('/')[-1]


        if img_info == 'female':
            latent = f_latent
        else: latent = m_latent

        thisLatent = latent[latent[:,0]==img_name][0][1][0]
        theseLatent_run1.append(thisLatent)
        
    # ############### second run
    # Image for experiment
    imgCSV = open(csvFile_run2, 'r')
    imgCSV = csv.reader(imgCSV)
    imgList = [name for name in imgCSV]
    
    theseLatent_run2=[]
    for idx in range(len(imgList)):
        img_info = imgList[idx][0].split('/')[-2]
        img_name = imgList[idx][0].split('/')[-1]


        if img_info == 'female':
            latent = f_latent
        else: latent = m_latent

        thisLatent = latent[latent[:,0]==img_name][0][1][0]
        theseLatent_run2.append(thisLatent)
        
    return np.array(theseLatent_run1), np.array(theseLatent_run2)


SUBJ=sys.argv[1]
test_latMat_run1, test_latMat_run2 = test_latentMat(SUBJ)
print(test_latMat_run1.shape, test_latMat_run2.shape)
    
mdic = {"test_latMat_run1": test_latMat_run1}
outputFile = '/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/inter_output/regression/test_latMat_run1.mat'%(SUBJ)
sio.savemat(outputFile, mdic)

mdic = {"test_latMat_run2": test_latMat_run2}
outputFile = '/Users/ghootaekim/fMRI_analysis/primeRecon/subjects/%s/inter_output/regression/test_latMat_run2.mat'%(SUBJ)
sio.savemat(outputFile, mdic)







