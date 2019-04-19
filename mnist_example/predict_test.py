"""Test mnist_client.

This file tests that we can send predictions to the model
using REST.

It is an integration test as it depends on having access to
a deployed model.

We use the pytest framework because
  1. It can output results in junit format for prow/gubernator
  2. It has good support for configuring tests using command line arguments
     (https://docs.pytest.org/en/latest/example/simple.html)

Python Path Requirements:
  kubeflow/testing/py - https://github.com/kubeflow/testing/tree/master/py
     * Provides utilities for testing

Manually running the test
 1. Configure your KUBECONFIG file to point to the desired cluster
"""

import json
import logging
import os
import subprocess
import requests
from retrying import retry
import six

from kubernetes.config import kube_config
from kubernetes import client as k8s_client

import pytest

def send_request(*args, **kwargs):
  # We don't use util.run because that ends up including the access token
  # in the logs
  token = ""

  headers = {
    "Authorization": "Bearer " + token,
  }

  if "headers" not in kwargs:
    kwargs["headers"] = {}

  kwargs["headers"].update(headers)

  r = requests.post(*args, **kwargs)

  return r

@pytest.mark.xfail
def test_predict():

  this_dir = os.path.dirname(__file__)
  test_data = os.path.join(this_dir, "test_data", "instances.json")
  with open(test_data) as hf:
    instances = json.load(hf)

  # We proxy the request through the APIServer so that we can connect
  # from outside the cluster.
  url = ("http://a74a65a43626f11e9add206315979229-1245725681.us-west-2.elb.amazonaws.com:8500"
         "/v1/models/mnist:predict")
  logging.info("Request: %s", url)
  r = send_request(url, json=instances, verify=False)
  print(url)
  if r.status_code != requests.codes.OK:
    msg = "Request to {0} exited with status code: {1} and content: {2}".format(
      url, r.status_code, r.content)
    logging.error(msg)
    raise RuntimeError(msg)

  content = r.content
  if six.PY3 and hasattr(content, "decode"):
    content = content.decode()
  result = json.loads(content)
  assert len(result["predictions"]) == 1
  predictions = result["predictions"][0]
  assert "classes" in predictions
  assert "predictions" in predictions
  assert len(predictions["predictions"]) == 10
  logging.info("URL %s returned; %s", url, content)

if __name__ == "__main__":
  logging.basicConfig(level=logging.INFO,
                      format=('%(levelname)s|%(asctime)s'
                              '|%(pathname)s|%(lineno)d| %(message)s'),
                      datefmt='%Y-%m-%dT%H:%M:%S',
                      )
  logging.getLogger().setLevel(logging.INFO)
  pytest.main()
