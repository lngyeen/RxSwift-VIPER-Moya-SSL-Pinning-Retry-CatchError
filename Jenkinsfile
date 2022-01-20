#!groovy
def lastCommitInfo = ""
def skippingText = ""
def commitContainsSkip = 0
def slackMessage = ""
def shouldBuild = false

def pollSpec = ""

if(env.BRANCH_NAME == "master") {
    pollSpec = "0 * * * *"
} else if(env.BRANCH_NAME == "develop") {
    pollSpec = "* * * * 1-5"
} else if(env.BRANCH_NAME.contains("release")) {
    pollSpec = "0 15 * * *"
}

pipeline {
    agent {label 'macbook'}

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
                checkout scm
                // sh "gem install bundler --user-install"
                sh "gem install -n /usr/local/bin nokogiri --user-install"
                sh "gem install -n /usr/local/bin cocoapods --user-install"
                sh 'gem install -n /usr/local/bin fastlane --user-install'
                sh "gem install -n /usr/local/bin slather --user-install"
                sh "pod install --repo-update"
            }
        }

        stage('Run Tests') {
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

        // stage('Increate build number and commit') {
        //     when {
        //         expression {
        //             return env.shouldBuild != "false"
        //         }
        //     }
        //     steps {
        //         sh "fastlane increment_build_number_and_commit"
        //     }
        // }

        stage('Build develop') {
            when {
                expression {
                    return env.shouldBuild != "false" && env.BRANCH_NAME == 'develop'
                }
            }
            steps {
                sh "fastlane build_develop"
            }
        }

        stage('Build pre-prod') {
            when {
                expression {
                    return env.shouldBuild != "false" && env.BRANCH_NAME == "master"
                }
            }
            steps {
                sh "fastlane build_pre_prod_ad_hoc"
            }
        }

        stage('Build prod') {
            when {
                expression {
                    return env.shouldBuild != "false" && env.BRANCH_NAME.contains("release")
                }
            }
            steps {
                sh "fastlane build_prod_ad_hoc"
            }
        }

        stage('Inform Slack for success') {
            when {
                expression {
                    return env.shouldBuild != "false"
                }
            }
            steps {
                sh "fastlane send_slack_success"
            }
        }
    }

    post {
        failure {
            sh "fastlane send_slack_failure"
        }
        unstable {
            sh "fastlane send_slack_unstable"
        }
    }
}
