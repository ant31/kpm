#!/usr/bin/groovy
@Library('github.com/fabric8io/fabric8-pipeline-library@master')
//@Library('github.com/ant31/fabric8-pipeline-library@master')

def utils = new io.fabric8.Utils()

node {
  def envStage = utils.environmentNamespace('staging')
  def envProd = utils.environmentNamespace('production')
  def newVersion = ''

  clientsNode{
   // Mark the code checkout 'stage'....
   stage 'Checkout' {

   // Checkout code from repository
    checkout scm
    }

    stage 'Canary release' {
    echo 'NOTE: running pipelines for the first time will take longer as build and base docker images are pulled onto the node'
    if (!fileExists ('Dockerfile')) {
      writeFile file: 'Dockerfile', text: 'FROM node:5.3-onbuild'
    }
    env.setProperty('FABRIC8_DOCKER_REGISTRY_SERVICE_HOST', 'fabric8-docker-registry.fabric8.kpmhub.com')
    env.setProperty('FABRIC8_DOCKER_REGISTRY_SERVICE_PORT', '443')
    newVersion = performCanaryRelease {}
  }
}
}
