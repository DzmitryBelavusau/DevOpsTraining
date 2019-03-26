    def props = ''
    def version = ''
    def updatedVersion = ''
    def cookbook = 'cookbooks/bluegreen'
    def metadataFile = 'cookbooks/bluegreen/metadata.rb'
    def attributesFile = 'cookbooks/bluegreen/attributes/default.rb'
    def envProperties = ''

node('master') {
    
    stage('Clone sources') {
        git branch: 'task10', credentialsId: 'GitHubDzmitryBelavusau', url: 'https://github.com/DzmitryBelavusau/DevOpsTraining.git'
    }
    
    stage('read cookbook version') {
        props = readProperties file: "${env.WORKSPACE}/${metadataFile}"
        version = props['version']
        version = version.replaceAll(/'/, '')
    }

    stage('increment cookbook version') {
        String minorVers=version.substring(version.lastIndexOf('.')+1)
        int minorNew=minorVers.toInteger()+1
        String majorVers=version.substring(0,version.lastIndexOf("."))
        updatedVersion=majorVers+ "." +minorNew
    }

    stage('write cookbook version') {
        String propsString = new File("${env.WORKSPACE}/${metadataFile}").text
        File propsFile = new File("${env.WORKSPACE}/${metadataFile}")
        propsString = propsString.replace(version, updatedVersion)
        propsFile.write(propsString)
    }

    stage('read dockerImage version') {
        props = readProperties file: "${env.WORKSPACE}/${attributesFile}"
        version = props["default['image']['version']"]
        version = version.replaceAll(/'/, '')
        print dockerImageTag
    }

    stage('write dockerImage version') {
        String propsString = new File("${env.WORKSPACE}/${attributesFile}").text
        File propsFile = new File("${env.WORKSPACE}/${attributesFile}")
        propsString = propsString.replace(version, dockerImageTag)
        propsFile.write(propsString)
    }

    stage('read env variables') {
        def envFile = sh returnStdout: true, script: "knife environment show ${chefEnv} -F json"
        envProperties = readJSON text: envFile;
    }

    stage('set env variables') {
        envProperties.default_attributes.image.version = dockerImageTag
        writeJSON file: "env${chefEnv}.json", json: envProperties
        sh "cat env${chefEnv}.json"
    }

    stage('upload env variables') {
        sh "knife environment from file env${chefEnv}.json"
    }

    stage('upload cookbook') {
        dir("${env.WORKSPACE}/${cookbook}") {
            sh "berks install && berks upload"
        }
    }

    stage('Git Commit') {
            withCredentials([usernamePassword(credentialsId: 'GitHubDzmitryBelavusau', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                sh 'git add .'
                sh 'git commit -m "new version of cookbook"'
                sh("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u task10")
            }            
    }

    stage('start chef-client') {
        withCredentials([usernamePassword(credentialsId: 'ChefClientCentos72', passwordVariable: 'KNIFE_PASSWORD', usernameVariable: 'KNIFE_USERNAME')]) {
            sh("knife ssh 'chef_environment:test' 'sudo chef-client' -x ${KNIFE_USERNAME} -P ${KNIFE_PASSWORD}")
            } 
    }
}