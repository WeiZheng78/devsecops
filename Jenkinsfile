pipeline {
	agent any
	stages {
		stage('Build Artifact') {
			steps {
				sh "mvn clean package -DskipTests=true"
				archive 'target/*.jar' 
			}
		}
    stage('Unit Tests - JUnit and JaCoCo') {
      steps {
        sh "mvn test" //test
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
    stage('Mutation Tests - PIT') {
     steps {
       sh "mvn org.pitest:pitest-maven:mutationCoverage"
     }
     post {
      always{
        pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
      }
     }
    }

    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh "mvn clean verify sonar:sonar \
            -Dsonar.projectKey=numeric-applicatoin \
            -Dsonar.projectName='numeric-applicatoin' \
            -Dsonar.host.url=http://192.168.12.20:9000 \
            -Dsonar.token=sqp_6bd0de2b4cc032626c98e6ab818db00439042fd9"
        }
        timeout(time: 2, unit: 'MINUTES') {
          script {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }

    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'sudo docker build -t weizheng78/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push weizheng78/numeric-app:""$GIT_COMMIT""'
        }
      }
    }
    stage('K8S Deployment - DEV') {
      steps {
        parallel(
          "Deployment": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "bash k8s-deployment.sh"
            }
          },
          "Rollout Status": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "bash k8s-deployment-rollout-status.sh"
            }
          }
        )
      }
    }
	}
}