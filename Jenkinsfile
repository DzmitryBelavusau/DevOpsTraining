    def props = ''
    def VERSION = ''
    def repArtifact = 'test'
    def repGroup = 'test'
    def repClass = 'test'
    def snapshotinfoFile = ''
    def snapshotinfo = ''
    def nameSnapshot = ''
    def nexusIP = '10.70.5.201'
    def dockerIP = '10.70.5.201'
    def warFullPath = ''
    def task7Image = ''
    def serviceRun = ''

node('master') {
    
    stage('Clone sources') {
        git branch: 'task7b', credentialsId: 'GitHubDzmitryBelavusau', url: 'https://github.com/DzmitryBelavusau/DevOpsTraining.git'
    }

    stage('Gradle incrementVersion') {
        if (isUnix()) {
            sh './gradlew incrementVersion'
        } else {
            bat 'gradlew.bat incrementVersion'
        }
    }

    stage('Gradle clean build') {
        if (isUnix()) {
            sh './gradlew clean build'
        } else {
            bat 'gradlew.bat clean build'
        }
    }

    props = readProperties file: 'gradle.properties'
    VERSION = props['VERSION']

    stage('Nexus upload SNAPSHOT') {
        nexusArtifactUploader artifacts: [[artifactId: "${repArtifact}", classifier: "${repClass}", file: 'build/libs/task4.war', type: 'war']], 
        credentialsId: 'nexusOSS', groupId: "${repGroup}", nexusUrl: "${nexusIP}:8081/nexus", nexusVersion: 'nexus2', protocol: 'http', repository: 'snapshots', version: "${VERSION}"+'-SNAPSHOT'
    }

    snapshotinfoFile = httpRequest "http://${nexusIP}:8081/nexus/content/repositories/snapshots/${repGroup}/${repArtifact}/${VERSION}-SNAPSHOT/maven-metadata.xml"
    snapshotinfo = new XmlParser().parseText(snapshotinfoFile.content)
    nameSnapshot = snapshotinfo.versioning.snapshotVersions.snapshotVersion.value[0].text()
    warFullPath = "http://${nexusIP}:8081/nexus/content/repositories/snapshots/${repGroup}/${repArtifact}/${VERSION}-SNAPSHOT/${repArtifact}-${nameSnapshot}-${repClass}.war"

    stage('Build image') {
        task7Image = docker.build("task7:${VERSION}", "--build-arg WARPATH=${warFullPath} . ")
    }

    stage('Push image') {
        docker.withRegistry("https://${dockerIP}:5000") {
            task7Image.push("${VERSION}")
            task7Image.push("latest")
        }
    }
    
    stage('Create-update service') {
        serviceRun = sh returnStdout: true, script: "docker service ls"
        if (serviceRun.contains('task7')) {
            sh "docker service update --image ${dockerIP}:5000/task7:${VERSION} task7 "
        } else {
            sh "docker service create -p 38080:8080 --replicas=2 --name task7 ${dockerIP}:5000/task7:${VERSION}"
        }
    }

    stage('Pause') {
        sleep 10
    }

    stage('CorrectVersion') {
        //def response = httpRequest "http://${dockerIP}:38080/task7b/"
        def response = sh returnStdout: true, script: "curl http://${dockerIP}:38080/task7b/"
        //def correct = response.content.contains("${VERSION}")
        def correct = response.contains("${VERSION}")
        if (correct == true) {
            echo 'Deployment to Docker Swarm is correct'
        } else {
            echo 'Deployment to Docker Swarm is incorrect'
            currentBuild.result = 'ABORTED'
            error('Deployment to Docker Swarm is incorrect')
        }
    }

    stage('Git Commit') {
        if (isUnix()) {
            withCredentials([usernamePassword(credentialsId: 'GitHubDzmitryBelavusau', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                sh 'git add gradle.properties'
                sh 'git commit -m "new version of gradle.properties"'
                sh("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u task7b")
                sh "git checkout master"
                sh 'git pull origin master'
                sh 'git merge task7b'
                sh("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u master")
                def gitTagList = sh(script: 'git tag -l', returnStdout: true)
                def tagContVers = gitTagList.contains("${VERSION}")
                if (tagContVers == false) {
                    sh "git tag -a ${VERSION} -m \"new version ${VERSION}\""
                }
                sh("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git --tags")
            }            
        } 
        else {
            withCredentials([usernamePassword(credentialsId: 'GitHubDzmitryBelavusau', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                bat 'git add gradle.properties'
                bat 'git commit -m "new version of gradle.properties"'
                bat("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u task7b")
                bat "git checkout master"
                bat 'git pull origin master'
                bat 'git merge task7b'
                bat("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u master")
                def gitTagList = bat(script: 'git tag -l', returnStdout: true)
                def tagContVers = gitTagList.contains("${VERSION}")
                if (tagContVers == false) {
                    bat "git tag -a ${VERSION} -m \"new version ${VERSION}\""
                }
                bat("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git --tags")
            }
        }
    }
}