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
    def warFullPath =''

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

    props = readProperties  file:'gradle.properties'
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
        def task7Image = docker.build("task7:${VERSION}", "--build-arg WARPATH=${warFullPath} . ")
    }

    stage('Push image') {
        docker.withRegistry("https://${dockerIP}:5000") {
            task7Image.push("${VERSION}")
            task7Image.push("latest")
        }
    }
    
    /*stage('Test image') {
        task7Image.inside {
            sh 'echo "Tests passed"'
        }
    }*/

}
/*    
node('tomcat1'){
    stage('Deploy tomcat1') {
        httpRequest 'http://192.168.100.10/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=1'
        sh "wget http://192.168.100.251:8081/nexus/content/repositories/snapshots/${repGroup}/${repArtifact}/${VERSION}-SNAPSHOT/${repArtifact}-${nameSnapshot}-${repClass}.war"
        sh "sudo cp -f ${repArtifact}-${nameSnapshot}-${repClass}.war /usr/share/tomcat/webapps/task6.war"
    }
}   
*/
node('master') {
    /*stage('Pause') {
        sleep 30
    }

    stage('CorrectVersion1') {
        def response1 = httpRequest "http://192.168.100.11:8080/task6/"
        def correct1 = response1.content.contains("${VERSION}")
        if (correct1 == true) {
            echo 'Deployment to tomcat1 is correct'
            httpRequest 'http://192.168.100.10/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=0'
        } else {
            echo 'Deployment to tomcat1 is incorrect'
            currentBuild.result = 'ABORTED'
            error('Deployment to tomcat1 is incorrect')
        }
    }

    stage('Git Commit') {
        if (isUnix()) {
            withCredentials([usernamePassword(credentialsId: 'GitHubDzmitryBelavusau', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                sh 'git add gradle.properties'
                sh 'git commit -m "new version of gradle.properties"'
                sh("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u task6")
                sh "git checkout master"
                sh 'git pull origin master'
                sh 'git merge task6'
                sh("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u master")
                def gitTagList = bat(script: 'git tag -l', returnStdout: true)
                def tagContVers = gitTagList.contains("${VERSION}")
                if (tagContVers == false) {
                    sh "git tag -a ${VERSION} -m \"new version ${VERSION}\""
                }
                sh("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git --tags")
            }            
        } else {
            withCredentials([usernamePassword(credentialsId: 'GitHubDzmitryBelavusau', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                bat 'git add gradle.properties'
                bat 'git commit -m "new version of gradle.properties"'
                bat("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u task6")
                bat "git checkout master"
                bat 'git pull origin master'
                bat 'git merge task6'
                bat("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git -u master")
                def gitTagList = bat(script: 'git tag -l', returnStdout: true)
                def tagContVers = gitTagList.contains("${VERSION}")
                if (tagContVers == false) {
                    bat "git tag -a ${VERSION} -m \"new version ${VERSION}\""
                }
                bat("git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/DevOpsTraining.git --tags")
            }
       }
    }*/
}