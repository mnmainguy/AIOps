{
  global: {},
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    "mnist-deploy-aws": {
      defaultCpuImage: 'tensorflow/serving:1.11.1',
      defaultGpuImage: 'tensorflow/serving:1.11.1-gpu',
      deployHttpProxy: 'false',
      enablePrometheus: 'true',
      httpProxyImage: 'gcr.io/kubeflow-images-public/tf-model-server-http-proxy:v20180723',
      injectIstio: 'false',
      modelBasePath: 's3://aiops-train/export/',
      modelName: 'mnist',
      name: 'mnist-deploy-aws',
      numGpus: '1',
      s3AwsRegion: 'us-west-2',
      s3Enable: 'true',
      s3Endpoint: 's3.us-west-2.amazonaws.com',
      s3SecretAccesskeyidKeyName: 'awsAccessKeyID',
      s3SecretName: 'aws-creds',
      s3SecretSecretaccesskeyKeyName: 'awsSecretAccessKey',
      s3UseHttps: 'false',
      s3VerifySsl: 'false',
      versionName: 'v1',
    },
    "mnist-service": {
      enablePrometheus: 'true',
      injectIstio: 'false',
      modelName: 'mnist',
      name: 'mnist-service',
      serviceType: 'ClusterIP',
      trafficRule: 'v1:100',
    },
    "web-ui": {
      containerPort: 5000,
      image: 'docker.io/mmainguy/mnist-ui',
      name: 'mnist-web-ui',
      replicas: 1,
      servicePort: 80,
      type: 'LoadBalancer',
    },
  },
}