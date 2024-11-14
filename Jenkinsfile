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
      posts {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
	}
}