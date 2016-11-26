#!/usr/bin/groovy
@Library('github.com/fabric8io/fabric8-pipeline-library@master')

def utils = new io.fabric8.Utils()

node {
  def envStage = utils.environmentNamespace('staging')
  def envProd = utils.environmentNamespace('production')
  def newVersion = ''

  clientsNode{
    git 'http://gogs.fabric8.kpmhub.com/gogsadmin/kpm.git'

    stage 'Canary release'
    echo 'NOTE: running pipelines for the first time will take longer as build and base docker images are pulled onto the node'
    if (!fileExists ('Dockerfile')) {
      writeFile file: 'Dockerfile', text: 'FROM node:5.3-onbuild'
    }
    env.setProperty('FABRIC8_DOCKER_REGISTRY_SERVICE_HOST', 'fabric8-docker-registry.fabric8.kpmhub.com')
    env.setProperty('FABRIC8_DOCKER_REGISTRY_SERVICE_PORT', '443')
    newVersion = performCanaryRelease {}
  }
  def rc = getKubernetesJson {
    port = 8080
    label = 'node'
    icon = 'https://cdn.rawgit.com/fabric8io/fabric8/dc05040/website/src/images/logos/nodejs.svg'
    version = newVersion
    imageName = clusterImageName
  }

  stage 'Rollout Staging'
  kubernetesApply(file: rc, environment: envStage)

  stage 'Approve'
  approve{
    room = null
    version = canaryVersion
    console = fabric8Console
    environment = envStage
  }

  stage 'Rollout Production'
  kubernetesApply(file: rc, environment: envProd)

}
