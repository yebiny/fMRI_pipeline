#!/bin/bash
source tool.sh

SUBJ=${1}
FSF_DIR=results/$SUBJ/fsf/

## trial-wise glm for phase1
#feat $FSF_DIR/phase1_trialWiseGLM_train_run1.fsf
#feat $FSF_DIR/phase1_trialWiseGLM_train_run2.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run3.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run4.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run5.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run6.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run7.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run8.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run9.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run10.fsf





