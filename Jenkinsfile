#!groovy

def lastCommitInfo = ""
def skippingText = ""
def commitContainsSkip = 0
def slackMessage = ""
def shouldBuild = false

def pollSpec = ""

if(env.BRANCH_NAME == "master") {
    pollSpec = "*/5 * * * *"
} else if(env.BRANCH_NAME == "develop") {
    pollSpec = "* * * * 1-5"
}

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }

    triggers {
        pollSCM ignorePostCommitHooks: true, scmpoll_spec: pollSpec
    }

    stages {

        stage('Init') {
            steps {
                script {
                    lastCommitInfo = sh(script: "git log -1", returnStdout: true).trim()
                    commitContainsSkip = sh(script: "git log -1 | grep '.*\\[skip ci\\].*'", returnStatus: true)

                    if(commitContainsSkip == 0) {
                        skippingText = "Skipping commit."
                        env.shouldBuild = false
                        currentBuild.result = "NOT_BUILT"
                    }

                    slackMessage = "*${env.JOB_NAME}* *${env.BRANCH_NAME}* received a new commit. ${skippingText}\nHere is commmit info: ${lastCommitInfo}"
                }
            }
        }

        stage('Prepare workspace')  {
            when {
                expression {
                  return env.shouldBuild != "false"
                }
              }
              steps {
                // checkout scm
                sh 'pod install --repo-update'
              }
        }

        // stage('Send info to Slack') {
        //     steps {
        //         slackSend color: "#2222FF", message: slackMessage
        //     }
        // }

        stage('Run Unit and UI Tests') {
            when {
                expression {
                    return env.shouldBuild != "false"
                }
            }
            steps {
                script {
                    try {
                        sh "fastlane runTests"
                    } catch(exc) {
                        currentBuild.result = "UNSTABLE"
                        error('There are failed tests.')
                    }
                }
            }
        }

        stage('Build develop and submit to Deploygate') {
            when {
                expression {
                    return env.shouldBuild != "false" && env.BRANCH_NAME == 'develop'
                }
            }
            steps {
                // sh "fastlane incrementBuildNumberAndCommit"
                sh "fastlane build_develop"
                sh "fastlane upload_deploy_gate"
            }
        }

        stage('Build pre-prod and submit to Deploygate') {
            when {
                expression {
                    return env.shouldBuild != "false" && env.BRANCH_NAME == "master"
                }
            }
            steps {
                // sh "fastlane incrementBuildNumberAndCommit"
                sh "fastlane build_pre_prod_ad_hoc"
                sh "fastlane upload_deploy_gate"
            }
        }


        stage('Build pre-prod and submit to Deploygate') {
            when {
                expression {
                    return env.shouldBuild != "false" && env.BRANCH_NAME.contains("release")
                }
            }
            steps {
                // sh "fastlane incrementBuildNumberAndCommit"
                sh "fastlane build_prod_ad_hoc"
                sh "fastlane upload_deploy_gate"
            }
        }

        stage('Inform Slack for success') {
            when {
                expression {
                    return env.shouldBuild != "false"
                }
            }
            steps {
                //slackSend color: "good", message: "*${env.JOB_NAME}* *${env.BRANCH_NAME}* job is completed successfully"
            }
        }
    }

    post {
        failure {
            //slackSend color: "danger", message: "*${env.JOB_NAME}* *${env.BRANCH_NAME}* job is failed"
        }
        unstable {
            //slackSend color: "danger", message: "*${env.JOB_NAME}* *${env.BRANCH_NAME}* job is unstable. Unstable means test failure, code violation etc."
        }
    }
}
