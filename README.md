# Machine Learning Continuous Delivery Pipeline Using Kubeflow

## Overview
This projecty implements Kubeflow on a machine learning api to create a continuous delivery pipeline with different server configurations for development, QA, and production.

## Motivation for this project
Having several environments for machine learning applications reduces cost (less servers needed in lower environments), decreases risk (allows new code to be tested before production) and allows greater scalability on demand. 

## Tech Stack
Teraform, Docker, Kubernetes, Kubeflow, Argo CD

## Engineering Challenges
Kubeflow is a very new framework for machine learning continuous delivery and there are few if any examples available using Kubeflow in AWS. Additionally setting up several environments that could share a data backend will be challenging.   