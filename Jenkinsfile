pipeline {
    parameters {
        booleanParam defaultValue: false, description: 'Whether to upload the packages in devel repositories', name: 'PLAYGROUND'
    }
    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 1, unit: 'HOURS')
    }
    agent {
        node {
            label 'base-agent-v1'
        }
    }
    environment {
        NETWORK_OPTS = '--network ci_agent'
    }
    stages {
        stage('Checkout & Stash') {
            agent {
                node {
                    label 'base-agent-v1'
                }
            }
            steps {
                checkout scm
                stash includes: '**', name: 'project'
            }
        }
        stage('Packaging') {
            parallel {
                stage('Ubuntu 20') {
                    agent {
                        node {
                            label 'yap-agent-ubuntu-20.04-v2'
                        }
                    }
                    steps {
                        unstash 'project'
                        sh 'sudo yap build ubuntu-focal .'
                        stash includes: 'artifacts/*focal*.deb', name: 'artifacts-ubuntu-focal'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'artifacts/*focal*.deb', fingerprint: true
                        }
                    }
                }
                stage('Ubuntu 22') {
                    agent {
                        node {
                            label 'yap-agent-ubuntu-22.04-v2'
                        }
                    }
                    steps {
                        unstash 'project'
                        sh 'sudo yap build ubuntu-jammy .'
                        stash includes: 'artifacts/*jammy*.deb', name: 'artifacts-ubuntu-jammy'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'artifacts/*jammy*.deb', fingerprint: true
                        }
                    }
                }
                stage('Ubuntu 24') {
                    agent {
                        node {
                            label 'yap-agent-ubuntu-24.04-v2'
                        }
                    }
                    steps {
                        unstash 'project'
                        sh 'sudo yap build ubuntu-noble .'
                        stash includes: 'artifacts/*noble*.deb', name: 'artifacts-ubuntu-noble'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'artifacts/*noble*.deb', fingerprint: true
                        }
                    }
                }
                stage('RHEL 8') {
                    agent {
                        node {
                            label 'yap-agent-rocky-8-v2'
                        }
                    }
                    steps {
                        unstash 'project'
                        sh 'sudo yap build rocky-8 .'
                        stash includes: 'artifacts/x86_64/*el8*.rpm', name: 'artifacts-rocky-8'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'artifacts/x86_64/*el8*.rpm', fingerprint: true
                        }
                    }
                }
                stage('RHEL 9') {
                    agent {
                        node {
                            label 'yap-agent-rocky-9-v2'
                        }
                    }
                    steps {
                        unstash 'project'
                        sh 'sudo yap build rocky-9 .'
                        stash includes: 'artifacts/x86_64/*el9*.rpm', name: 'artifacts-rocky-9'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'artifacts/x86_64/*el9*.rpm', fingerprint: true
                        }
                    }
                }
            }
        }
        stage('Upload To Playground') {
            when {
                anyOf {
                    expression { params.PLAYGROUND == true }
                }
            }
            steps {
                unstash 'artifacts-ubuntu-focal'
                unstash 'artifacts-ubuntu-jammy'
                unstash 'artifacts-ubuntu-noble'
                unstash 'artifacts-rocky-8'
                unstash 'artifacts-rocky-9'
                script {
                    def server = Artifactory.server 'zextras-artifactory'
                    def buildInfo
                    def uploadSpec
                    buildInfo = Artifactory.newBuildInfo()
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/*focal*.deb",
                                "target": "ubuntu-playground/pool/",
                                "props": "deb.distribution=focal;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/*jammy*.deb",
                                "target": "ubuntu-playground/pool/",
                                "props": "deb.distribution=jammy;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/*noble*.deb",
                                "target": "ubuntu-playground/pool/",
                                "props": "deb.distribution=noble;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/x86_64/(carbonio-certbot)-(*).el8.x86_64.rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.el8.x86_64.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/x86_64/(carbonio-certbot)-(*).el9.x86_64.rpm",
                                "target": "rhel9-playground/zextras/{1}/{1}-{2}.el9.x86_64.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            }
                        ]
                    }'''
                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                }
            }
        }
        stage('Upload To Devel') {
            when {
                branch 'devel'
            }
            steps {
                unstash 'artifacts-ubuntu-focal'
                unstash 'artifacts-ubuntu-jammy'
                unstash 'artifacts-ubuntu-noble'
                unstash 'artifacts-rocky-8'
                unstash 'artifacts-rocky-9'
                script {
                    def server = Artifactory.server 'zextras-artifactory'
                    def buildInfo
                    def uploadSpec
                    buildInfo = Artifactory.newBuildInfo()
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/*focal*.deb",
                                "target": "ubuntu-devel/pool/",
                                "props": "deb.distribution=focal;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/*jammy*.deb",
                                "target": "ubuntu-devel/pool/",
                                "props": "deb.distribution=jammy;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/*noble*.deb",
                                "target": "ubuntu-devel/pool/",
                                "props": "deb.distribution=noble;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/x86_64/(carbonio-certbot)-(*).el8.x86_64.rpm",
                                "target": "centos8-devel/zextras/{1}/{1}-{2}.el8.x86_64.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/x86_64/(carbonio-certbot)-(*).el9.x86_64.rpm",
                                "target": "rhel9-devel/zextras/{1}/{1}-{2}.el9.x86_64.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            }
                        ]
                    }'''
                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                }
            }
        }
        stage('Upload & Promotion Config') {
            when {
                buildingTag()
            }
            steps {
                unstash 'artifacts-ubuntu-focal'
                unstash 'artifacts-ubuntu-jammy'
                unstash 'artifacts-ubuntu-noble'
                unstash 'artifacts-rocky-8'
                unstash 'artifacts-rocky-9'

                script {
                    def server = Artifactory.server 'zextras-artifactory'
                    def buildInfo
                    def uploadSpec
                    def config

                    //ubuntu
                    buildInfo = Artifactory.newBuildInfo()
                    buildInfo.name += '-ubuntu'
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/*focal*.deb",
                                "target": "ubuntu-rc/pool/",
                                "props": "deb.distribution=focal;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/*jammy*.deb",
                                "target": "ubuntu-rc/pool/",
                                "props": "deb.distribution=jammy;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/*noble*.deb",
                                "target": "ubuntu-rc/pool/",
                                "props": "deb.distribution=noble;deb.component=main;deb.architecture=amd64"
                            }
                        ]
                    }'''
                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                    config = [
                            'buildName'          : buildInfo.name,
                            'buildNumber'        : buildInfo.number,
                            'sourceRepo'         : 'ubuntu-rc',
                            'targetRepo'         : 'ubuntu-release',
                            'comment'            : 'Do not change anything! Just press the button',
                            'status'             : 'Released',
                            'includeDependencies': false,
                            'copy'               : true,
                            'failFast'           : true
                    ]
                    Artifactory.addInteractivePromotion server: server, promotionConfig: config, displayName: 'Ubuntu Promotion to Release'
                    server.publishBuildInfo buildInfo

                    //rhel8
                    buildInfo = Artifactory.newBuildInfo()
                    buildInfo.name += "-centos8"
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/x86_64/(carbonio-certbot)-(*).el8.x86_64.rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.el8.x86_64.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            }
                        ]
                    }'''

                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                    config = [
                            'buildName'          : buildInfo.name,
                            'buildNumber'        : buildInfo.number,
                            'sourceRepo'         : 'centos8-rc',
                            'targetRepo'         : 'centos8-release',
                            'comment'            : 'Do not change anything! Just press the button',
                            'status'             : 'Released',
                            'includeDependencies': false,
                            'copy'               : true,
                            'failFast'           : true
                    ]
                    Artifactory.addInteractivePromotion server: server, promotionConfig: config, displayName: "RHEL8 Promotion to Release"
                    server.publishBuildInfo buildInfo

                    //rhel9
                    buildInfo = Artifactory.newBuildInfo()
                    buildInfo.name += "-rhel9"
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/x86_64/(carbonio-certbot)-(*).el9.x86_64.rpm",
                                "target": "rhel9-rc/zextras/{1}/{1}-{2}.el9.x86_64.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            }
                        ]
                    }'''

                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                    config = [
                            'buildName'          : buildInfo.name,
                            'buildNumber'        : buildInfo.number,
                            'sourceRepo'         : 'rhel9-rc',
                            'targetRepo'         : 'rhel9-release',
                            'comment'            : 'Do not change anything! Just press the button',
                            'status'             : 'Released',
                            'includeDependencies': false,
                            'copy'               : true,
                            'failFast'           : true
                    ]
                    Artifactory.addInteractivePromotion server: server, promotionConfig: config, displayName: "RHEL9 Promotion to Release"
                    server.publishBuildInfo buildInfo
                }
            }
        }
    }
}

