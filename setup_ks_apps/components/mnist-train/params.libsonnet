{
  global: {},
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
     "train": {
      batchSize: 100,
      secretKeyRefs: 'AWS_ACCESS_KEY_ID=aws-creds.awsAccessKeyID,AWS_SECRET_ACCESS_KEY=aws-creds.awsSecretAccessKey',
      envVariables: 'S3_ENDPOINT=s3.us-west-2.amazonaws.com,AWS_ENDPOINT_URL=http://s3.us-west-2.amazonaws.com,AWS_REGION=us-west-2,BUCKET_NAME=aiops-train,S3_USE_HTTPS=0,S3_VERIFY_SSL=0',
      exportDir: 's3://aiops-train/export',
      image: 'docker.io/mmainguy/minst-train',
      learningRate: '0.01',
      modelDir: 's3://aiops-train/model',
      name: 'mnist-train-aws',
      numPs: 0,
      numWorkers: 0,
      secret: '',
      trainSteps: 200,
    },
  },
}