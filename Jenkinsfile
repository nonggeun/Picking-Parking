// pipeline {
//     agent any

//     tools {
//         // Global Tool Configuration에서 설정한 jdk21을 사용
//         jdk ("openjdk")  // jdk21을 사용
//     }

//     environment {
//         SSH_CREDENTIALS_ID = "ssh"
//         REMOTE_SERVER = "k11a102.p.ssafy.io"
//         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
//         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
//         CREDENTIALS_ID = 'jenkins'
//         DOCKER_HUB_USERNAME = 'geunwook'
//         DOCKER_HUB_PASSWORD = 'az5483az!!'
//         JAVA_HOME = '/opt/java/openjdk'
//         DB_USERNAME = 'ssafy'
//         DB_PASSWORD = 'ilovessafy'
//     }

//     stages {
//         stage('Print Branch Info') {
//             steps {
//                 script {
//                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
//                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
//                     echo "Current branch: ${branch}"
//                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
//                 }
//             }
//         }

//         stage('Checkout') {
//             steps {
//                 script {
//                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
//                 }
//             }
//         }

//         stage('Build image') {
//             steps {
//                 script {
//                     // withCredentials를 사용하여 DB 자격 증명 설정
//                     withCredentials([usernamePassword(credentialsId: CREDENTIALS_ID, usernameVariable: DB_USERNAME, passwordVariable: DB_PASSWORD)]) {
//                         dir('frontend') {
//                         // Dockerfile.prod 사용하도록 명시
//                         sh 'docker build -t geunwook/flutter2:latest .'
//                         sh 'docker push geunwook/flutter2:latest'
//                     }

//                         // backend 디렉토리로 이동하여 빌드 실행
//                         dir('backend') {
//                             sh './gradlew build -x test'
//                             sh 'docker build -t geunwook/backend4:latest .'
//                             sh 'docker push geunwook/backend4:latest'
//                         }
//                     }
//                 }
//             }
//         }
        
//         stage('Pull Docker Images') {
//             steps {
//                 script {
//                     // Docker Hub에서 Flutter 및 Backend 이미지 가져오기
//                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
//                     sh 'docker pull geunwook/flutter2:latest'
//                     sh 'docker pull geunwook/backend4:latest'
//                 }
//             }
//         }

//         stage('Deploy to Remote Server') {
//             steps {
//                 script {
//                     sshagent([SSH_CREDENTIALS_ID]) {
//                         sh '''
//                         # 원격 서버에서 Docker 이미지 pull
//                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
//                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
//                             docker pull geunwook/flutter2:latest
//                             docker pull geunwook/backend4:latest
// EOF_1

//                         # Docker Compose 파일 전송
//                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

//                         # 원격 서버에서 Docker Compose 실행
//                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
//                             cd /home/ubuntu/S11P31A102
//                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
//                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// EOF_2
//                         '''
//                     }
//                 }
//             }
//         }
//     }
    
//     post {
//         always {
//             cleanWs()
//         }
//     }
// }


pipeline {
    agent any

    tools {
        // Global Tool Configuration에서 설정한 jdk21 사용
        jdk ("openjdk")  // jdk21 설정
    }

    environment {
        SSH_CREDENTIALS_ID = "ssh"
        REMOTE_SERVER = "k11a102.p.ssafy.io"
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
        GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
        CREDENTIALS_ID = 'jenkins'
        DOCKER_HUB_USERNAME = 'geunwook'
        DOCKER_HUB_PASSWORD = 'az5483az!!'
        JAVA_HOME = '/opt/java/openjdk'
        DB_USERNAME = 'ssafy'
        DB_PASSWORD = 'ilovessafy'
        CERT_PATH = 'src/main/resources/certs/AmazonRootCA1.pem' // 인증서를 저장할 로컬 경로
    }

    stages {
        stage('Prepare .env File') {
            steps {
                script {
                    // .env 파일에 기록할 내용 정의
                    def envContent = """
                    AWS_IOT_ENDPOINT=a33gbanlr1i26p-ats.iot.ap-northeast-2.amazonaws.com
                    AWS_CLIENT_ID=Backend
                    AWS_CERT_PATH=src/main/resources/certs/certificate.pem.crt
                    AWS_KEY_PATH=src/main/resources/certs/private.pem.key
                    AWS_ROOT_CA_PATH=src/main/resources/certs/AmazonRootCA1.pem
                    """

                    // .env 파일을 생성하여 저장
                    writeFile(file: '.env', text: envContent)
                }
            }
        }
        stage('Print Branch Info') {
            steps {
                script {
                    echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Current branch: ${branch}"
                    echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
                }
            }
        }

        stage('Checkout') {
            steps {
                script {
                    git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
                }
            }
        }

        stage('Prepare Certificate') {
            steps {
                script {
                    // 인증서를 Credentials에서 불러와 로컬에 저장
                    withCredentials([string(credentialsId: 'amazon-root-ca1', variable: 'CERT_CONTENT')]) {
                        sh '''
                        mkdir -p src/main/resources/certs
                        echo "$CERT_CONTENT" > ${CERT_PATH}
                        '''
                    }
                }
            }
        }

        stage('Build and Push Images') {
            steps {
                script {
                    // Docker Hub 로그인
                    sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'

                    dir('frontend') {
                        // Flutter 이미지 빌드 및 푸시
                        sh 'docker build -t geunwook/flutter2:latest .'
                        sh 'docker push geunwook/flutter2:latest'
                    }

                    dir('backend') {
                        // Backend 빌드 및 푸시
                        sh './gradlew build -x test'
                        sh """
                        docker build \
                        --build-arg CERT_FILE=${CERT_PATH} \
                        -t geunwook/backend4:latest . 
                        """
                        sh 'docker push geunwook/backend4:latest'
                    }
                }
            }
        }

        stage('Pull Docker Images') {
            steps {
                script {
                    // Docker Hub에서 Flutter 및 Backend 이미지 가져오기
                    sh 'docker pull geunwook/flutter2:latest'
                    sh 'docker pull geunwook/backend4:latest'
                }
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS_ID]) {
                        sh '''
                        # 원격 서버에서 Docker 이미지 pull
                        ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
                            docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
                            docker pull geunwook/flutter2:latest
                            docker pull geunwook/backend4:latest
EOF_1

                        # Docker Compose 파일 전송
                        scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102
                        # .env 파일 전송
                        scp -o StrictHostKeyChecking=no ./.env ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102
                        # 원격 서버에서 Docker Compose 실행
                        ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
                            cd /home/ubuntu/S11P31A102
                            docker-compose -f ${DOCKER_COMPOSE_FILE} down
                            docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
EOF_2
                        '''
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}




// // // // // // // // // // // // // // pipeline {
// // // // // // // // // // // // // //     agent any

// // // // // // // // // // // // // //     environment {
// // // // // // // // // // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // // // // // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // // // // // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // // // // // // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // // // // // // // // // // // //         CREDENTIALS_ID = 'jenkins'
// // // // // // // // // // // // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // // // // // // // // // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
// // // // // // // // // // // // // //     }

// // // // // // // // // // // // // //     stages {
// // // // // // // // // // // // // //         // 1. 현재 빌드가 진행 중인 브랜치 정보 출력
// // // // // // // // // // // // // //         stage('Print Branch Info') {
// // // // // // // // // // // // // //             steps {
// // // // // // // // // // // // // //                 script {
// // // // // // // // // // // // // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // // // // // // // // // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // // // // // // // // // //                     echo "Current branch: ${branch}"
// // // // // // // // // // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // // // // // // // // // //                 }
// // // // // // // // // // // // // //             }
// // // // // // // // // // // // // //         }

// // // // // // // // // // // // // //         // 2. 코드 체크아웃
// // // // // // // // // // // // // //         stage('Checkout') {
// // // // // // // // // // // // // //             steps {
// // // // // // // // // // // // // //                 script {
// // // // // // // // // // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // // // // // // // // // //                 }
// // // // // // // // // // // // // //             }
// // // // // // // // // // // // // //         }

// // // // // // // // // // // // // //         // 3. Docker 이미지 빌드 (백엔드 및 프론트엔드)
// // // // // // // // // // // // // //         stage('Build Docker Images') {
// // // // // // // // // // // // // //             steps {
// // // // // // // // // // // // // //                 script {
// // // // // // // // // // // // // //                     // 프론트엔드 Docker 이미지 빌드
// // // // // // // // // // // // // //                     sh 'docker build -t geunwook/flutter2:latest -f frontend/Dockerfile.prod .'
// // // // // // // // // // // // // //                     // 백엔드 Docker 이미지 빌드 (Gradle을 사용하여 빌드)
// // // // // // // // // // // // // //                     sh '''
// // // // // // // // // // // // // //                     cd backend/whitebox
// // // // // // // // // // // // // //                     if [ ! -f gradlew ]; then
// // // // // // // // // // // // // //                         echo "gradlew file not found. Generating Gradle Wrapper."
// // // // // // // // // // // // // //                         gradle wrapper
// // // // // // // // // // // // // //                     fi
// // // // // // // // // // // // // //                     chmod +x gradlew
// // // // // // // // // // // // // //                     ./gradlew clean build
// // // // // // // // // // // // // //                     docker build -t geunwook/backend:latest .
// // // // // // // // // // // // // //                     '''
// // // // // // // // // // // // // //                 }
// // // // // // // // // // // // // //             }
// // // // // // // // // // // // // //         }

// // // // // // // // // // // // // //         // 4. Docker Hub에서 Flutter 및 백엔드 이미지 pull
// // // // // // // // // // // // // //         stage('Pull Docker Images') {
// // // // // // // // // // // // // //             steps {
// // // // // // // // // // // // // //                 script {
// // // // // // // // // // // // // //                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
// // // // // // // // // // // // // //                     sh 'docker pull geunwook/flutter2:latest'
// // // // // // // // // // // // // //                     sh 'docker pull geunwook/backend:latest'
// // // // // // // // // // // // // //                 }
// // // // // // // // // // // // // //             }
// // // // // // // // // // // // // //         }

// // // // // // // // // // // // // //         // 5. 원격 서버에 배포
// // // // // // // // // // // // // //         stage('Deploy to Remote Server') {
// // // // // // // // // // // // // //             steps {
// // // // // // // // // // // // // //                 script {
// // // // // // // // // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // // // // // // // // //                         sh '''
// // // // // // // // // // // // // //                         # Docker Hub에서 최신 이미지 pull
// // // // // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // // // // // // // // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // // // // // // // // // // //                             docker pull geunwook/flutter2:latest
// // // // // // // // // // // // // //                             docker pull geunwook/backend:latest
// // // // // // // // // // // // // // EOF_1

// // // // // // // // // // // // // //                         # Docker Compose 파일 전송
// // // // // // // // // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // // // // // // // // // // //                         # 원격 서버에서 Docker Compose 실행
// // // // // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // // // // // // // // // // //                             cd /home/ubuntu/S11P31A102
// // // // // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // // // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // // // // // // // // // // // EOF_2
// // // // // // // // // // // // // //                         '''
// // // // // // // // // // // // // //                     }
// // // // // // // // // // // // // //                 }
// // // // // // // // // // // // // //             }
// // // // // // // // // // // // // //         }
// // // // // // // // // // // // // //     }
    
// // // // // // // // // // // // // //     post {
// // // // // // // // // // // // // //         always {
// // // // // // // // // // // // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // // // // // // // // // // // //             cleanWs()
// // // // // // // // // // // // // //         }
// // // // // // // // // // // // // //     }
// // // // // // // // // // // // // // }
// // // // // // // // // // // // // pipeline {
// // // // // // // // // // // // //     agent any

// // // // // // // // // // // // //     environment {
// // // // // // // // // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // // // // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // // // // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // // // // // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // // // // // // // // // // //         CREDENTIALS_ID = 'jenkins'
// // // // // // // // // // // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // // // // // // // // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
// // // // // // // // // // // // //     }

// // // // // // // // // // // // //     stages {
// // // // // // // // // // // // //         // 1. 현재 빌드가 진행 중인 브랜치 정보 출력
// // // // // // // // // // // // //         stage('Print Branch Info') {
// // // // // // // // // // // // //             steps {
// // // // // // // // // // // // //                 script {
// // // // // // // // // // // // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // // // // // // // // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // // // // // // // // //                     echo "Current branch: ${branch}"
// // // // // // // // // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // // // // // // // // //                 }
// // // // // // // // // // // // //             }
// // // // // // // // // // // // //         }

// // // // // // // // // // // // //         // 2. 코드 체크아웃
// // // // // // // // // // // // //         stage('Checkout') {
// // // // // // // // // // // // //             steps {
// // // // // // // // // // // // //                 script {
// // // // // // // // // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // // // // // // // // //                 }
// // // // // // // // // // // // //             }
// // // // // // // // // // // // //         }

// // // // // // // // // // // // //         // 3. Docker 이미지 빌드 및 푸시
// // // // // // // // // // // // //         stage('Build and Push Docker Images') {
// // // // // // // // // // // // //             steps {
// // // // // // // // // // // // //                 script {
// // // // // // // // // // // // //                     // 프론트엔드 Docker 이미지 빌드
// // // // // // // // // // // // //                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
// // // // // // // // // // // // //                     sh 'docker pull geunwook/flutter2:latest'
// // // // // // // // // // // // //                     // 백엔드 Docker 이미지 빌드
// // // // // // // // // // // // //                     sh '''
// // // // // // // // // // // // //                     cd backend
// // // // // // // // // // // // //                     if [ ! -f gradlew ]; then
// // // // // // // // // // // // //                         echo "gradlew file not found. Generating Gradle Wrapper."
// // // // // // // // // // // // //                         gradle wrapper
// // // // // // // // // // // // //                     fi
// // // // // // // // // // // // //                     chmod +x gradlew
// // // // // // // // // // // // //                     ./gradlew clean build
// // // // // // // // // // // // //                     docker build -t geunwook/backend:latest .
// // // // // // // // // // // // //                     '''
// // // // // // // // // // // // //                     // Docker Hub에 푸시
// // // // // // // // // // // // //                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
// // // // // // // // // // // // //                     sh 'docker push geunwook/flutter2:latest'
// // // // // // // // // // // // //                     sh 'docker push geunwook/backend:latest'
// // // // // // // // // // // // //                 }
// // // // // // // // // // // // //             }
// // // // // // // // // // // // //         }

// // // // // // // // // // // // //         // 4. 원격 서버에 배포
// // // // // // // // // // // // //         stage('Deploy to Remote Server') {
// // // // // // // // // // // // //             steps {
// // // // // // // // // // // // //                 script {
// // // // // // // // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // // // // // // // //                         sh '''
// // // // // // // // // // // // //                         # Docker Hub에서 최신 이미지 pull
// // // // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // // // // // // // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // // // // // // // // // //                             docker pull geunwook/flutter2:latest
// // // // // // // // // // // // //                             docker pull geunwook/backend:latest
// // // // // // // // // // // // // EOF_1

// // // // // // // // // // // // //                         # Docker Compose 파일 전송
// // // // // // // // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // // // // // // // // // //                         # 원격 서버에서 Docker Compose 실행
// // // // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // // // // // // // // // //                             cd /home/ubuntu/S11P31A102
// // // // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // // // // // // // // // // EOF_2
// // // // // // // // // // // // //                         '''
// // // // // // // // // // // // //                     }
// // // // // // // // // // // // //                 }
// // // // // // // // // // // // //             }
// // // // // // // // // // // // //         }
// // // // // // // // // // // // //     }

// // // // // // // // // // // // //     post {
// // // // // // // // // // // // //         always {
// // // // // // // // // // // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // // // // // // // // // // //             cleanWs()
// // // // // // // // // // // // //         }
// // // // // // // // // // // // //     }
// // // // // // // // // // // // // }
// // // // // // // // // // // // pipeline {
// // // // // // // // // // // //     agent any

// // // // // // // // // // // //     tools {
// // // // // // // // // // // //         // Global Tool Configuration에서 설정한 jdk21을 사용
// // // // // // // // // // // //         jdk ("jdk21")  // jdk21을 사용
// // // // // // // // // // // //     }

// // // // // // // // // // // //     environment {
// // // // // // // // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // // // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // // // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // // // // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // // // // // // // // // //         CREDENTIALS_ID = 'jenkins'
// // // // // // // // // // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // // // // // // // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
// // // // // // // // // // // //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'  // JAVA_HOME 추가 (JDK 21 경로)
// // // // // // // // // // // //     }

// // // // // // // // // // // //     stages {
// // // // // // // // // // // //         stage('Print Branch Info') {
// // // // // // // // // // // //             steps {
// // // // // // // // // // // //                 script {
// // // // // // // // // // // //                     echo "Current GIT_BRANCH: ${env.BRANCH_NAME}"
// // // // // // // // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // // // // // // // //                     echo "Current branch: ${branch}"
// // // // // // // // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // // // // // // // //                 }
// // // // // // // // // // // //             }
// // // // // // // // // // // //         }

// // // // // // // // // // // //         stage('Checkout') {
// // // // // // // // // // // //             steps {
// // // // // // // // // // // //                 script {
// // // // // // // // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // // // // // // // //                 }
// // // // // // // // // // // //             }
// // // // // // // // // // // //         }

// // // // // // // // // // // //         stage('Build and Push Docker Images') {
// // // // // // // // // // // //             steps {
// // // // // // // // // // // //                 script {
// // // // // // // // // // // //                     // Docker Hub 로그인
// // // // // // // // // // // //                     sh "docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}"
// // // // // // // // // // // //                     // Flutter Docker 이미지 풀
// // // // // // // // // // // //                     sh "docker pull geunwook/flutter2:latest"

// // // // // // // // // // // //                     // Gradle 빌드 전에 JAVA_HOME을 설정하여 JDK 21 적용
// // // // // // // // // // // //                     withEnv(["JAVA_HOME=${JAVA_HOME}"]) {
// // // // // // // // // // // //                         sh '''
// // // // // // // // // // // //                         cd backend
// // // // // // // // // // // //                         if [ ! -f gradlew ]; then
// // // // // // // // // // // //                             echo "gradlew file not found. Generating Gradle Wrapper."
// // // // // // // // // // // //                             gradle wrapper
// // // // // // // // // // // //                         fi
// // // // // // // // // // // //                         chmod +x gradlew
// // // // // // // // // // // //                         java -version  # Java 버전 확인
// // // // // // // // // // // //                         ./gradlew clean build  # Gradle 빌드
// // // // // // // // // // // //                         docker build -t geunwook/backend:latest .  # Backend Docker 이미지 빌드
// // // // // // // // // // // //                         '''
// // // // // // // // // // // //                     }

// // // // // // // // // // // //                     // Docker 이미지 푸시
// // // // // // // // // // // //                     sh "docker push geunwook/flutter2:latest"
// // // // // // // // // // // //                     sh "docker push geunwook/backend:latest"
// // // // // // // // // // // //                 }
// // // // // // // // // // // //             }
// // // // // // // // // // // //         }

// // // // // // // // // // // //         stage('Deploy to Remote Server') {
// // // // // // // // // // // //             steps {
// // // // // // // // // // // //                 script {
// // // // // // // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // // // // // // //                         sh '''
// // // // // // // // // // // //                         # 원격 서버에서 Docker Hub 로그인 및 이미지 풀
// // // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // // // // // // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // // // // // // // // //                             docker pull geunwook/flutter2:latest
// // // // // // // // // // // //                             docker pull geunwook/backend:latest
// // // // // // // // // // // // EOF_1

// // // // // // // // // // // //                         # 원격 서버에 docker-compose 파일 전송
// // // // // // // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // // // // // // // // //                         # 원격 서버에서 docker-compose 명령어 실행
// // // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // // // // // // // // //                             cd /home/ubuntu/S11P31A102
// // // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down  # 기존 컨테이너 종료
// // // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build  # 새 컨테이너 빌드 및 실행
// // // // // // // // // // // // EOF_2
// // // // // // // // // // // //                         '''
// // // // // // // // // // // //                     }
// // // // // // // // // // // //                 }
// // // // // // // // // // // //             }
// // // // // // // // // // // //         }
// // // // // // // // // // // //     }

// // // // // // // // // // // //     post {
// // // // // // // // // // // //         always {
// // // // // // // // // // // //             cleanWs()  // 작업 후 워크스페이스 정리
// // // // // // // // // // // //         }
// // // // // // // // // // // //     }
// // // // // // // // // // // // }


// // // // // // // // // // // pipeline {
// // // // // // // // // // //     agent any

// // // // // // // // // // //     tools {
// // // // // // // // // // //         // Global Tool Configuration에서 설정한 jdk21을 사용
// // // // // // // // // // //         jdk ("jdk21")  // jdk21을 사용
// // // // // // // // // // //     }

// // // // // // // // // // //     environment {
// // // // // // // // // // //         SSH_CREDENTIALS_ID = "ssh"  // SSH 로그인 자격 증명 ID
// // // // // // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"  // 원격 서버 주소
// // // // // // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'  // Docker Compose 파일 경로
// // // // // // // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'  // GitLab 저장소 URL
// // // // // // // // // // //         CREDENTIALS_ID = 'jenkins'  // Jenkins 자격 증명 ID
// // // // // // // // // // //         DOCKER_HUB_USERNAME = 'geunwook'  // Docker Hub 사용자 이름
// // // // // // // // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'  // Docker Hub 비밀번호
// // // // // // // // // // //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'  // JAVA_HOME 환경 변수 (JDK 21 경로)
// // // // // // // // // // //     }

// // // // // // // // // // //     stages {
// // // // // // // // // // //         stage('Print Branch Info') {
// // // // // // // // // // //             steps {
// // // // // // // // // // //                 script {
// // // // // // // // // // //                     echo "Current GIT_BRANCH: ${env.BRANCH_NAME}"
// // // // // // // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // // // // // // //                     echo "Current branch: ${branch}"
// // // // // // // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // // // // // // //                 }
// // // // // // // // // // //             }
// // // // // // // // // // //         }

// // // // // // // // // // //         stage('Checkout') {
// // // // // // // // // // //             steps {
// // // // // // // // // // //                 script {
// // // // // // // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // // // // // // //                 }
// // // // // // // // // // //             }
// // // // // // // // // // //         }

// // // // // // // // // // //         stage('Build and Push Docker Images') {
// // // // // // // // // // //             steps {
// // // // // // // // // // //                 script {
// // // // // // // // // // //                     // Docker Hub 로그인
// // // // // // // // // // //                     sh "docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}"
                    
// // // // // // // // // // //                     // Flutter Docker 이미지 풀
// // // // // // // // // // //                     sh "docker pull geunwook/flutter2:latest"

// // // // // // // // // // //                     // 백엔드 디렉토리로 이동하여 Gradle 빌드 실행
// // // // // // // // // // //                     dir('/var/jenkins_home/workspace/a102/backend/pickingparking') {
// // // // // // // // // // //                         sh 'chmod +x gradlew'
// // // // // // // // // // //                         sh './gradlew build'
// // // // // // // // // // //                     }

// // // // // // // // // // //                     // 빌드된 파일 확인
// // // // // // // // // // //                     sh 'ls -l /var/jenkins_home/workspace/a102/backend/pickingparking/build/libs/'

// // // // // // // // // // //                     // Docker 이미지 빌드
// // // // // // // // // // //                     sh 'docker build -t geunwook/backend:latest /var/jenkins_home/workspace/a102/backend/pickingparking'
// // // // // // // // // // //                 }

// // // // // // // // // // //                 // Docker 이미지 푸시
// // // // // // // // // // //                 sh "docker push geunwook/flutter2:latest"
// // // // // // // // // // //                 sh "docker push geunwook/backend:latest"
// // // // // // // // // // //             }
// // // // // // // // // // //         }

// // // // // // // // // // //         stage('Deploy to Remote Server') {
// // // // // // // // // // //             steps {
// // // // // // // // // // //                 script {
// // // // // // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // // // // // //                         // 원격 서버에서 Docker Hub 로그인 및 이미지 풀
// // // // // // // // // // //                         sh '''
// // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // // // // // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // // // // // // // //                             docker pull geunwook/flutter2:latest
// // // // // // // // // // //                             docker pull geunwook/backend:latest
// // // // // // // // // // // EOF_1

// // // // // // // // // // //                         // Docker Compose 파일을 원격 서버에 복사
// // // // // // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // // // // // // // //                         // 원격 서버에서 docker-compose 명령어 실행
// // // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // // // // // // // //                             cd /home/ubuntu/S11P31A102
// // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down  # 기존 컨테이너 종료
// // // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build  # 새 컨테이너 빌드 및 실행
// // // // // // // // // // // EOF_2
// // // // // // // // // // //                         '''
// // // // // // // // // // //                     }
// // // // // // // // // // //                 }
// // // // // // // // // // //             }
// // // // // // // // // // //         }
// // // // // // // // // // //     }

// // // // // // // // // // //     post {
// // // // // // // // // // //         always {
// // // // // // // // // // //             cleanWs()  // 작업 후 워크스페이스 정리
// // // // // // // // // // //         }
// // // // // // // // // // //     }
// // // // // // // // // // // }

// // // // // // // // // // pipeline {
// // // // // // // // // //     agent any

// // // // // // // // // //     tools {
// // // // // // // // // //         jdk "jdk21"  // JDK 21 사용
// // // // // // // // // //     }

// // // // // // // // // //     environment {
// // // // // // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // // // // // //         FRONTEND_DIR = 'frontend'
// // // // // // // // // //         BACKEND_DIR = 'backend'
// // // // // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // // // // // //         JAVA_HOME = "/var/jenkins_home/tools/hudson.model.JDK/jdk21/amazon-corretto-21.0.3.9.1-linux-x64"  // JDK 경로 설정
// // // // // // // // // //     }

// // // // // // // // // //     stages {
// // // // // // // // // //         stage('Checkout Code') {
// // // // // // // // // //             steps {
// // // // // // // // // //                 script {
// // // // // // // // // //                     git branch: 'infra-test', credentialsId: 'jenkins', url: 'https://lab.ssafy.com/s11-final/S11P31A102.git'
// // // // // // // // // //                 }
// // // // // // // // // //             }
// // // // // // // // // //         }

// // // // // // // // // //         stage('Build Docker Images') {
// // // // // // // // // //             steps {
// // // // // // // // // //                 script {
// // // // // // // // // //                     // 프론트엔드 Docker 이미지 빌드
// // // // // // // // // //                     sh 'docker build -t geunwook/frontend:latest /var/jenkins_home/workspace/pickingparking/frontend'

// // // // // // // // // //                     // 백엔드 디렉토리로 이동하여 Gradle 빌드 실행
// // // // // // // // // //                     dir('/home/ubuntu/S11P31A102/backend') {
// // // // // // // // // //                         sh 'ls -l'
// // // // // // // // // //                         sh 'chmod +x gradlew'
// // // // // // // // // //                         sh './gradlew build'  // 이제 JAVA_HOME이 설정되어 있어야 함
// // // // // // // // // //                     }

// // // // // // // // // //                     // 빌드된 파일 확인
// // // // // // // // // //                     sh 'ls -l /home/ubuntu/S11P31A102/backend/build/libs/'

// // // // // // // // // //                     // Docker 이미지 빌드
// // // // // // // // // //                     sh 'docker build -t geunwook/backend:latest /home/ubuntu/S11P31A102/backend'
// // // // // // // // // //                 }
// // // // // // // // // //             }
// // // // // // // // // //         }

// // // // // // // // // //         stage('Deploy to Remote Server') {
// // // // // // // // // //             steps {
// // // // // // // // // //                 script {
// // // // // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // // // // //                         sh '''
// // // // // // // // // //                         # 프론트엔드 이미지를 원격 서버로 전송하고 로드
// // // // // // // // // //                         docker save geunwook/frontend:latest | ssh -o StrictHostKeyChecking=no ${REMOTE_SERVER} 'docker load'

// // // // // // // // // //                         # 백엔드 이미지를 원격 서버로 전송하고 로드
// // // // // // // // // //                         docker save geunwook/backend:latest | ssh -o StrictHostKeyChecking=no ${REMOTE_SERVER} 'docker load'

// // // // // // // // // //                         # Docker Compose 파일을 원격 서버로 전송
// // // // // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ${REMOTE_SERVER}:/home/ubuntu  

// // // // // // // // // //                         # 원격 서버에서 Docker Compose로 컨테이너 실행
// // // // // // // // // //                         ssh -o StrictHostKeyChecking=no ${REMOTE_SERVER} << EOF
// // // // // // // // // //                             cd /home/ubuntu
// // // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d  
// // // // // // // // // // EOF
// // // // // // // // // //                         '''
// // // // // // // // // //                     }
// // // // // // // // // //                 }
// // // // // // // // // //             }
// // // // // // // // // //         }
// // // // // // // // // //     }

// // // // // // // // // //     post {
// // // // // // // // // //         always {
// // // // // // // // // //             cleanWs()
// // // // // // // // // //         }
// // // // // // // // // //     }
// // // // // // // // // // }


// // // // // // // // // pipeline {
// // // // // // // // //     agent any

// // // // // // // // //     tools {
// // // // // // // // //         jdk "jdk21"  // JDK 21 사용
// // // // // // // // //     }

// // // // // // // // //     environment {
// // // // // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // // // // //         FRONTEND_DIR = 'frontend'
// // // // // // // // //         BACKEND_DIR = 'backend'
// // // // // // // // //         CREDENTIALS_ID = 'jenkins'
// // // // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // // // // //         JAVA_HOME = "/var/jenkins_home/tools/hudson.model.JDK/jdk21/amazon-corretto-21.0.3.9.1-linux-x64"  // JDK 경로 설정
// // // // // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102.git'
// // // // // // // // //     }

// // // // // // // // //     stages {
// // // // // // // // //         // 1. 현재 빌드가 진행 중인 브랜치 정보 출력
// // // // // // // // //         stage('Print Branch Info') {
// // // // // // // // //             steps {
// // // // // // // // //                 script {
// // // // // // // // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // // // // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // // // // //                     echo "Current branch: ${branch}"
// // // // // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // // // // //                 }
// // // // // // // // //             }
// // // // // // // // //         }

// // // // // // // // //         // 2. 코드 체크아웃
// // // // // // // // //         stage('Checkout') {
// // // // // // // // //             steps {
// // // // // // // // //                 script {
// // // // // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // // // // //                 }
// // // // // // // // //             }
// // // // // // // // //         }

// // // // // // // // //         // 3. 디렉토리 리스트 출력
// // // // // // // // //         stage('List Directory') {
// // // // // // // // //             steps {
// // // // // // // // //                 sh 'mkdir -p frontend'
// // // // // // // // //                 sh 'mkdir -p backend'
// // // // // // // // //                 sh 'ls -l'
// // // // // // // // //                 sh 'ls -l frontend'
// // // // // // // // //                 sh 'ls -l backend'
// // // // // // // // //             }
// // // // // // // // //         }

// // // // // // // // //         // 4. Docker 이미지 빌드
// // // // // // // // //         stage('Build Docker Images') {
// // // // // // // // //             steps {
// // // // // // // // //                 script {
// // // // // // // // //                     // 프론트엔드 Docker 이미지 빌드
// // // // // // // // //                     dir(FRONTEND_DIR) {
// // // // // // // // //                         // Dockerfile.prod 사용하도록 명시
// // // // // // // // //                         sh 'docker build -t frontend:latest -f /home/ubuntu/S11P31A102/frontend/Dockerfile .'
// // // // // // // // //                     }

// // // // // // // // //                     // 백엔드 Docker 이미지 빌드
// // // // // // // // //                     dir(BACKEND_DIR) {
// // // // // // // // //                         // Gradle Wrapper 관련 파일 확인 후 빌드 진행
// // // // // // // // //                         sh '''
// // // // // // // // //                         if [ ! -f gradlew ]; then
// // // // // // // // //                             echo "gradlew file not found. Generating Gradle Wrapper."
// // // // // // // // //                             gradle wrapper
// // // // // // // // //                         fi
// // // // // // // // //                         chmod +x gradlew
// // // // // // // // //                         ./gradlew clean build
// // // // // // // // //                         '''
// // // // // // // // //                         sh 'docker build -t backend:latest .'
// // // // // // // // //                     }
// // // // // // // // //                 }
// // // // // // // // //             }
// // // // // // // // //         }

// // // // // // // // //         // 5. 원격 서버에 배포
// // // // // // // // //         stage('Deploy to Remote Server') {
// // // // // // // // //             steps {
// // // // // // // // //                 script {
// // // // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // // // //                         sh '''
// // // // // // // // //                         docker save frontend:latest | ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} 'docker load'
// // // // // // // // //                         docker save backend:latest | ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} 'docker load'

// // // // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu

// // // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF
// // // // // // // // //                             cd /home/ubuntu
// // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // // // // // // EOF
// // // // // // // // //                         '''
// // // // // // // // //                     }
// // // // // // // // //                 }
// // // // // // // // //             }
// // // // // // // // //         }
// // // // // // // // //     }
// // // // // // // // //     post {
// // // // // // // // //         always {
// // // // // // // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // // // // // // //             cleanWs()
// // // // // // // // //         }
// // // // // // // // //     }
// // // // // // // // // }
// // // // // // // // pipeline {
// // // // // // // //     agent any

// // // // // // // //     environment {
// // // // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // // // // // //         CREDENTIALS_ID = 'jenkins'
// // // // // // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // // // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
// // // // // // // //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
// // // // // // // //         PATH = "${JAVA_HOME}/bin:${PATH}"
// // // // // // // //     }

// // // // // // // //     stages {
// // // // // // // //         // 1. 현재 빌드가 진행 중인 브랜치 정보 출력
// // // // // // // //         stage('Print Branch Info') {
// // // // // // // //             steps {
// // // // // // // //                 script {
// // // // // // // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // // // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // // // //                     echo "Current branch: ${branch}"
// // // // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // // // //                 }
// // // // // // // //             }
// // // // // // // //         }

// // // // // // // //         // 2. 코드 체크아웃
// // // // // // // //         stage('Checkout') {
// // // // // // // //             steps {
// // // // // // // //                 script {
// // // // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // // // //                 }
// // // // // // // //             }
// // // // // // // //         }

// // // // // // // //         // 3. Gradle 빌드
// // // // // // // //         stage('Gradle Build') {
// // // // // // // //             steps {
// // // // // // // //                 script {
// // // // // // // //                     dir('backend') {
// // // // // // // //                         sh 'chmod +x gradlew'
// // // // // // // //                         sh './gradlew build' // Gradle 빌드 실행
// // // // // // // //                     }
// // // // // // // //                 }
// // // // // // // //             }
// // // // // // // //         }

// // // // // // // //         // 4. Docker Hub에서 Flutter 이미지 pull
// // // // // // // //         stage('Pull Flutter Docker Image') {
// // // // // // // //             steps {
// // // // // // // //                 script {
// // // // // // // //                     // Docker Hub에서 이미지 가져오기
// // // // // // // //                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
// // // // // // // //                     sh 'docker pull geunwook/flutter2:latest'
// // // // // // // //                     sh 'docker pull geunwook/backend:latest'
// // // // // // // //                 }
// // // // // // // //             }
// // // // // // // //         }

// // // // // // // //         // 5. 원격 서버에 배포
// // // // // // // //         stage('Deploy to Remote Server') {
// // // // // // // //             steps {
// // // // // // // //                 script {
// // // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // // //                         sh '''
// // // // // // // //                         # Docker Hub에서 최신 이미지 pull
// // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // // // // //                             docker pull geunwook/flutter2:latest
// // // // // // // //                             docker pull geunwook/backend:latest
// // // // // // // // EOF_1

// // // // // // // //                         # Docker Compose 파일 전송
// // // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // // // // //                         # 원격 서버에서 Docker Compose 실행
// // // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // // // // //                             cd /home/ubuntu/S11P31A102
// // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // // // // // EOF_2
// // // // // // // //                         '''
// // // // // // // //                     }
// // // // // // // //                 }
// // // // // // // //             }
// // // // // // // //         }
// // // // // // // //     }
    
// // // // // // // //     post {
// // // // // // // //         always {
// // // // // // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // // // // // //             cleanWs()
// // // // // // // //         }
// // // // // // // //     }
// // // // // // // // }


// // // // // // // pipeline {
// // // // // // //     agent any

// // // // // // //     environment {
// // // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // // // // //         CREDENTIALS_ID = 'jenkins'
// // // // // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
        
// // // // // // //         // JAVA_HOME을 올바르게 설정
// // // // // // //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'  // 적절한 Java 경로로 수정
// // // // // // //         PATH = "${JAVA_HOME}/bin:${PATH}"  // PATH에 JAVA_HOME/bin 추가
// // // // // // //     }

// // // // // // //     stages {
// // // // // // //         // 1. 현재 빌드가 진행 중인 브랜치 정보 출력
// // // // // // //         stage('Print Branch Info') {
// // // // // // //             steps {
// // // // // // //                 script {
// // // // // // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // // //                     echo "Current branch: ${branch}"
// // // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // // //                 }
// // // // // // //             }
// // // // // // //         }

// // // // // // //         // 2. 코드 체크아웃
// // // // // // //         stage('Checkout') {
// // // // // // //             steps {
// // // // // // //                 script {
// // // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // // //                 }
// // // // // // //             }
// // // // // // //         }

// // // // // // //         // 3. Gradle 빌드
// // // // // // //         stage('Gradle Build') {
// // // // // // //             steps {
// // // // // // //                 script {
// // // // // // //                     dir('backend') {
// // // // // // //                         sh 'chmod +x gradlew'
// // // // // // //                         sh './gradlew build' // Gradle 빌드 실행
// // // // // // //                     }
// // // // // // //                 }
// // // // // // //             }
// // // // // // //         }

// // // // // // //         // 4. Docker Hub에서 Flutter 이미지 pull
// // // // // // //         stage('Pull Flutter Docker Image') {
// // // // // // //             steps {
// // // // // // //                 script {
// // // // // // //                     // Docker Hub에서 이미지 가져오기
// // // // // // //                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
// // // // // // //                     sh 'docker pull geunwook/flutter2:latest'
// // // // // // //                     sh 'docker pull geunwook/backend:latest'
// // // // // // //                 }
// // // // // // //             }
// // // // // // //         }

// // // // // // //         // 5. 원격 서버에 배포
// // // // // // //         stage('Deploy to Remote Server') {
// // // // // // //             steps {
// // // // // // //                 script {
// // // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // // //                         sh '''
// // // // // // //                         # Docker Hub에서 최신 이미지 pull
// // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // // // //                             docker pull geunwook/flutter2:latest
// // // // // // //                             docker pull geunwook/backend:latest
// // // // // // // EOF_1

// // // // // // //                         # Docker Compose 파일 전송
// // // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // // // //                         # 원격 서버에서 Docker Compose 실행
// // // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // // // //                             cd /home/ubuntu/S11P31A102
// // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // // // // EOF_2
// // // // // // //                         '''
// // // // // // //                     }
// // // // // // //                 }
// // // // // // //             }
// // // // // // //         }
// // // // // // //     }
    
// // // // // // //     post {
// // // // // // //         always {
// // // // // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // // // // //             cleanWs()
// // // // // // //         }
// // // // // // //     }
// // // // // // // }
// // // // // // pipeline {
// // // // // //     agent any

// // // // // //     environment {
// // // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // // // //         CREDENTIALS_ID = 'jenkins'
// // // // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
        
// // // // // //         // JAVA_HOME을 올바르게 설정
// // // // // //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
// // // // // //         PATH = "${JAVA_HOME}/bin:${PATH}"
// // // // // //     }

// // // // // //     stages {
// // // // // //         // 1. 현재 빌드가 진행 중인 브랜치 정보 출력
// // // // // //         stage('Print Branch Info') {
// // // // // //             steps {
// // // // // //                 script {
// // // // // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // // // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // // // //                     echo "Current branch: ${branch}"
// // // // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // // // //                 }
// // // // // //             }
// // // // // //         }

// // // // // //         // 2. 코드 체크아웃
// // // // // //         stage('Checkout') {
// // // // // //             steps {
// // // // // //                 script {
// // // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // // //                 }
// // // // // //             }
// // // // // //         }

// // // // // //         // 3. Gradle 빌드
// // // // // //         stage('Gradle Build') {
// // // // // //             steps {
// // // // // //                 script {
// // // // // //                     dir('backend') {
// // // // // //                         sh 'echo $JAVA_HOME'   // JAVA_HOME 출력 확인
// // // // // //                         sh 'java -version'     // Java 버전 확인
// // // // // //                         sh 'chmod +x gradlew'
// // // // // //                         sh './gradlew build'   // Gradle 빌드 실행
// // // // // //                     }
// // // // // //                 }
// // // // // //             }
// // // // // //         }

// // // // // //         // 4. Docker Hub에서 Flutter 이미지 pull
// // // // // //         stage('Pull Flutter Docker Image') {
// // // // // //             steps {
// // // // // //                 script {
// // // // // //                     // Docker Hub에서 이미지 가져오기
// // // // // //                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
// // // // // //                     sh 'docker pull geunwook/flutter2:latest'
// // // // // //                     sh 'docker pull geunwook/backend:latest'
// // // // // //                 }
// // // // // //             }
// // // // // //         }

// // // // // //         // 5. 원격 서버에 배포
// // // // // //         stage('Deploy to Remote Server') {
// // // // // //             steps {
// // // // // //                 script {
// // // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // // //                         sh '''
// // // // // //                         # Docker Hub에서 최신 이미지 pull
// // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // // //                             docker pull geunwook/flutter2:latest
// // // // // //                             docker pull geunwook/backend:latest
// // // // // // EOF_1

// // // // // //                         # Docker Compose 파일 전송
// // // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // // //                         # 원격 서버에서 Docker Compose 실행
// // // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // // //                             cd /home/ubuntu/S11P31A102
// // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // // // EOF_2
// // // // // //                         '''
// // // // // //                     }
// // // // // //                 }
// // // // // //             }
// // // // // //         }
// // // // // //     }
    
// // // // // //     post {
// // // // // //         always {
// // // // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // // // //             cleanWs()
// // // // // //         }
// // // // // //     }
// // // // // // }

// // // // // pipeline {
// // // // //     agent any
// // // // //     tools {
// // // // //         // Global Tool Configuration에서 설정한 jdk21을 사용
// // // // //         jdk ("jdk21")  // jdk21을 사용
// // // // //     }

// // // // //     environment {
// // // // //         SSH_CREDENTIALS_ID = "ssh"
// // // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // // //         CREDENTIALS_ID = 'jenkins'
// // // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
        
// // // // //         // JAVA_HOME을 올바르게 설정
// // // // //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
// // // // //         PATH = "${JAVA_HOME}/bin:${PATH}"
// // // // //     }

// // // // //     stages {
// // // // //         stage('Checkout') {
// // // // //             steps {
// // // // //                 script {
// // // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // // //                 }
// // // // //             }
// // // // //         }

// // // // //         stage('Gradle Build') {
// // // // //             steps {
// // // // //                 script {
// // // // //                     dir('backend') {
// // // // //                         // Gradle 빌드 전에 JAVA_HOME을 명시적으로 설정
// // // // //                         sh '''
// // // // //                             export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
// // // // //                             export PATH=$JAVA_HOME/bin:$PATH
// // // // //                             echo $JAVA_HOME   # JAVA_HOME 출력 확인
// // // // //                             java -version      # Java 버전 확인
// // // // //                             chmod +x gradlew
// // // // //                             ./gradlew build   # Gradle 빌드 실행
// // // // //                         '''
// // // // //                     }
// // // // //                 }
// // // // //             }
// // // // //         }

// // // // //         stage('Pull Flutter Docker Image') {
// // // // //             steps {
// // // // //                 script {
// // // // //                     // Docker Hub에서 이미지 가져오기
// // // // //                     sh 'docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}'
// // // // //                     sh 'docker pull geunwook/flutter2:latest'
// // // // //                     sh 'docker pull geunwook/backend:latest'
// // // // //                 }
// // // // //             }
// // // // //         }

// // // // //         stage('Deploy to Remote Server') {
// // // // //             steps {
// // // // //                 script {
// // // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // // //                         sh '''
// // // // //                         # Docker Hub에서 최신 이미지 pull
// // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_1
// // // // //                             docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
// // // // //                             docker pull geunwook/flutter2:latest
// // // // //                             docker pull geunwook/backend:latest
// // // // // EOF_1

// // // // //                         # Docker Compose 파일 전송
// // // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu/S11P31A102

// // // // //                         # 원격 서버에서 Docker Compose 실행
// // // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF_2
// // // // //                             cd /home/ubuntu/S11P31A102
// // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // // EOF_2
// // // // //                         '''
// // // // //                     }
// // // // //                 }
// // // // //             }
// // // // //         }
// // // // //     }
    
// // // // //     post {
// // // // //         always {
// // // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // // //             cleanWs()
// // // // //         }
// // // // //     }
// // // // // }
// // // // pipeline {
// // // //     agent any

// // // //     environment {
// // // //         SSH_CREDENTIALS_ID = "ssh"
// // // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // // //         CREDENTIALS_ID = 'jenkins'
// // // //         DOCKER_HUB_USERNAME = 'geunwook'
// // // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
// // // //         FRONTEND_DIR = 'frontend'
// // // //         BACKEND_DIR = 'backend'
// // // //     }

// // // //     stages {
// // // //         // 1. 현재 빌드가 진행 중인 브랜치 정보 출력
// // // //         stage('Print Branch Info') {
// // // //             steps {
// // // //                 script {
// // // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // // //                     echo "Current branch: ${branch}"
// // // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // // //                 }
// // // //             }
// // // //         }

// // // //         // 2. 코드 체크아웃
// // // //         stage('Checkout') {
// // // //             steps {
// // // //                 script {
// // // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // // //                 }
// // // //             }
// // // //         }

// // // //         // 3. 디렉토리 리스트 출력
// // // //         stage('List Directory') {
// // // //             steps {
// // // //                 sh 'mkdir -p frontend'
// // // //                 sh 'mkdir -p backend'
// // // //                 sh 'ls -l'
// // // //                 sh 'ls -l frontend'
// // // //                 sh 'ls -l backend'
// // // //             }
// // // //         }

// // // //         // 4. Docker 이미지 빌드
// // // //         stage('Build Docker Images') {
// // // //             steps {
// // // //                 script {
// // // //                     // 프론트엔드 Docker 이미지 빌드
// // // //                     dir(FRONTEND_DIR) {
// // // //                         // Dockerfile.prod 사용하도록 명시
// // // //                         sh 'docker build -t geunwook/flutter2:latest -f Dockerfile .'
// // // //                     }

// // // //                     // 백엔드 Docker 이미지 빌드
// // // //                     dir(BACKEND_DIR) {
// // // //                         // Gradle Wrapper 관련 파일 확인 후 빌드 진행
// // // //                         sh '''
// // // //                         if [ ! -f gradlew ]; then
// // // //                             echo "gradlew file not found. Generating Gradle Wrapper."
// // // //                             gradle wrapper
// // // //                         fi
// // // //                         chmod +x gradlew
// // // //                         ./gradlew clean build
// // // //                         '''
// // // //                         sh 'docker build -t geunwook/backend:latest .'
// // // //                     }
// // // //                 }
// // // //             }
// // // //         }

// // // //         // 5. 원격 서버에 배포
// // // //         stage('Deploy to Remote Server') {
// // // //             steps {
// // // //                 script {
// // // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // // //                         sh '''
// // // //                         docker save geunwook/flutter2:latest | ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} 'docker load'
// // // //                         docker save geunwook/backend:latest | ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} 'docker load'

// // // //                         scp -o StrictHostKeyChecking=no ${DOCKER_COMPOSE_FILE} ubuntu@${REMOTE_SERVER}:/home/ubuntu

// // // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF
// // // //                             cd /home/ubuntu/S11P31A102
// // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --build
// // // // EOF
// // // //                         '''
// // // //                     }
// // // //                 }
// // // //             }
// // // //         }
// // // //     }
// // // //     post {
// // // //         always {
// // // //             // 파이프라인 실행 후 워크스페이스 정리 (불필요한 파일 삭제)
// // // //             cleanWs()
// // // //         }
// // // //     }
// // // // }
// // // pipeline {
// // //     agent any

// // //     environment {
// // //         SSH_CREDENTIALS_ID = "ssh"
// // //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// // //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// // //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// // //         CREDENTIALS_ID = 'jenkins'
// // //         DOCKER_HUB_USERNAME = 'geunwook'
// // //         DOCKER_HUB_PASSWORD = 'az5483az!!'
// // //         FRONTEND_DIR = 'frontend'
// // //         BACKEND_DIR = 'backend'
// // //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
// // //         PATH = "${JAVA_HOME}/bin:${env.PATH}"
// // //     }

// // //     stages {
// // //         stage('Print Branch Info') {
// // //             steps {
// // //                 script {
// // //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// // //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// // //                     echo "Current branch: ${branch}"
// // //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// // //                 }
// // //             }
// // //         }

// // //         stage('Checkout') {
// // //             steps {
// // //                 script {
// // //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// // //                 }
// // //             }
// // //         }

// // //         stage('List Directory') {
// // //             steps {
// // //                 sh 'mkdir -p frontend'
// // //                 sh 'mkdir -p backend'
// // //                 sh 'ls -l'
// // //                 sh 'ls -l frontend'
// // //                 sh 'ls -l backend'
// // //             }
// // //         }

// // //         stage('Check JAVA_HOME') {
// // //             steps {
// // //                 script {
// // //                     sh 'echo $JAVA_HOME'
// // //                     sh 'java -version'
// // //                 }
// // //             }
// // //         }
// // //         stage('Build Docker Images') {
// // //             steps {
// // //                 script {
// // //                     dir(FRONTEND_DIR) {
// // //                         sh 'docker build -t geunwook/flutter2:latest -f Dockerfile .'
// // //                     }
// // //                     dir(BACKEND_DIR) {
// // //                         sh '''
// // //                         if [ ! -f gradlew ]; then
// // //                             echo "gradlew file not found. Generating Gradle Wrapper."
// // //                             gradle wrapper
// // //                         fi
// // //                         ./gradlew --debug
// // //                         chmod +x gradlew
// // //                         ./gradlew clean build
// // //                         '''
// // //                         sh 'docker build -t geunwook/backend:latest .'
// // //                     }
// // //                 }
// // //             }
// // //         }

// // //         stage('Push Docker Images to Docker Hub') {
// // //             steps {
// // //                 script {
// // //                     sh '''
// // //                     echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
// // //                     docker push geunwook/flutter2:latest
// // //                     docker push geunwook/backend:latest
// // //                     '''
// // //                 }
// // //             }
// // //         }

// // //         stage('Deploy to Remote Server') {
// // //             steps {
// // //                 script {
// // //                     sshagent([SSH_CREDENTIALS_ID]) {
// // //                         sh '''
// // //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF
// // //                             docker pull geunwook/flutter2:latest
// // //                             docker pull geunwook/backend:latest
// // //                             cd /home/ubuntu/S11P31A102
// // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// // //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d
// // // EOF
// // //                         '''
// // //                     }
// // //                 }
// // //             }
// // //         }
// // //     }

// // //     post {
// // //         always {
// // //             cleanWs()
// // //         }
// // //     }
// // // }


// // pipeline {
// //     agent any

// //     environment {
// //         SSH_CREDENTIALS_ID = "ssh"
// //         REMOTE_SERVER = "k11a102.p.ssafy.io"
// //         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
// //         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
// //         CREDENTIALS_ID = 'jenkins'
// //         DOCKER_HUB_USERNAME = 'geunwook'
// //         DOCKER_HUB_PASSWORD = 'az5483az!!'
// //         FRONTEND_DIR = 'frontend'
// //         BACKEND_DIR = 'backend'
// //         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
// //         PATH = "${JAVA_HOME}/bin:${env.PATH}"
// //     }

// //     stages {
// //         stage('Print Branch Info') {
// //             steps {
// //                 script {
// //                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
// //                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
// //                     echo "Current branch: ${branch}"
// //                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
// //                 }
// //             }
// //         }

// //         stage('Checkout') {
// //             steps {
// //                 script {
// //                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
// //                 }
// //             }
// //         }

// //         stage('List Directory') {
// //             steps {
// //                 sh 'mkdir -p frontend'
// //                 sh 'mkdir -p backend'
// //                 sh 'ls -l'
// //                 sh 'ls -l frontend'
// //                 sh 'ls -l backend'
// //             }
// //         }

// //         stage('Check JAVA_HOME') {
// //             steps {
// //                 script {
// //                     sh 'echo $JAVA_HOME'
// //                     sh 'java -version'
// //                 }
// //             }
// //         }

// //         stage('Build Docker Images') {
// //             steps {
// //                 script {
// //                     // Build frontend Docker image
// //                     dir(FRONTEND_DIR) {
// //                         sh 'docker build -t geunwook/flutter2:latest -f Dockerfile .'
// //                     }
                    
// //                     // Build backend Docker image
// //                     dir(BACKEND_DIR) {
// //                         // Ensure gradlew is present and executable
// //                         if (fileExists('gradlew')) {
// //                             sh 'chmod +x gradlew'
// //                         } else {
// //                             echo "gradlew not found, generating..."
// //                             sh 'gradle wrapper'
// //                             sh 'chmod +x gradlew'
// //                         }
// //                         // Run Gradle build
// //                         sh './gradlew clean build'
// //                         sh 'docker build -t geunwook/backend:latest .'
// //                     }
// //                 }
// //             }
// //         }

// //         stage('Push Docker Images to Docker Hub') {
// //             steps {
// //                 script {
// //                     sh '''
// //                     echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
// //                     docker push geunwook/flutter2:latest
// //                     docker push geunwook/backend:latest
// //                     '''
// //                 }
// //             }
// //         }

// //         stage('Deploy to Remote Server') {
// //             steps {
// //                 script {
// //                     sshagent([SSH_CREDENTIALS_ID]) {
// //                         sh '''
// //                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF
// //                             docker pull geunwook/flutter2:latest
// //                             docker pull geunwook/backend:latest
// //                             cd /home/ubuntu/S11P31A102
// //                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
// //                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d
// // EOF
// //                         '''
// //                     }
// //                 }
// //             }
// //         }
// //     }

// //     post {
// //         always {
// //             cleanWs()
// //         }
// //     }
// // }

// pipeline {
//     agent any

//     environment {
//         SSH_CREDENTIALS_ID = "ssh"
//         REMOTE_SERVER = "k11a102.p.ssafy.io"
//         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
//         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
//         CREDENTIALS_ID = 'jenkins'
//         DOCKER_HUB_USERNAME = 'geunwook'
//         DOCKER_HUB_PASSWORD = 'az5483az!!'
//         FRONTEND_DIR = 'frontend'
//         BACKEND_DIR = 'backend'
//         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
//         PATH = "${JAVA_HOME}/bin:${env.PATH}"
//     }

//     stages {
//         stage('Print Branch Info') {
//             steps {
//                 script {
//                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
//                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
//                     echo "Current branch: ${branch}"
//                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
//                 }
//             }
//         }

//         stage('Checkout') {
//             steps {
//                 script {
//                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
//                 }
//             }
//         }

//         stage('List Directory') {
//             steps {
//                 sh 'mkdir -p frontend'
//                 sh 'mkdir -p backend'
//                 sh 'ls -l'
//                 sh 'ls -l frontend'
//                 sh 'ls -l backend'
//             }
//         }

//         stage('Check JAVA_HOME') {
//             steps {
//                 script {
//                     sh 'echo $JAVA_HOME'
//                     sh 'java -version'
//                 }
//             }
//         }

//         stage('Build Docker Images') {
//             steps {
//                 script {
//                     // Ensure JAVA_HOME is set before building images
//                     sh 'echo "JAVA_HOME is set to: $JAVA_HOME"'
//                     sh 'echo "PATH is set to: $PATH"'

//                     // Build frontend Docker image
//                     dir(FRONTEND_DIR) {
//                         sh 'docker build -t geunwook/flutter2:latest -f Dockerfile .'
//                     }
                    
//                     // Build backend Docker image
//                     dir(BACKEND_DIR) {
//                         // Ensure gradlew is present and executable
//                         if (fileExists('gradlew')) {
//                             sh 'chmod +x gradlew'
//                         } else {
//                             echo "gradlew not found, generating..."
//                             sh 'gradle wrapper'
//                             sh 'chmod +x gradlew'
//                         }
//                         // Run Gradle build with JAVA_HOME explicitly set
//                         sh '''
//                         export JAVA_HOME=${JAVA_HOME}
//                         ./gradlew clean build
//                         '''
//                         sh 'docker build -t geunwook/backend:latest .'
//                     }
//                 }
//             }
//         }

//         stage('Push Docker Images to Docker Hub') {
//             steps {
//                 script {
//                     sh '''
//                     echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
//                     docker push geunwook/flutter2:latest
//                     docker push geunwook/backend:latest
//                     '''
//                 }
//             }
//         }

//         stage('Deploy to Remote Server') {
//             steps {
//                 script {
//                     sshagent([SSH_CREDENTIALS_ID]) {
//                         sh '''
//                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF
//                             docker pull geunwook/flutter2:latest
//                             docker pull geunwook/backend:latest
//                             cd /home/ubuntu/S11P31A102
//                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
//                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d
// EOF
//                         '''
//                     }
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             cleanWs()
//         }
//     }
// }
// pipeline {
//     agent any

//     environment {
//         SSH_CREDENTIALS_ID = "ssh"
//         REMOTE_SERVER = "k11a102.p.ssafy.io"
//         DOCKER_COMPOSE_FILE = 'docker-compose.yml'
//         GIT_REPO_URL = 'https://lab.ssafy.com/s11-final/S11P31A102'
//         CREDENTIALS_ID = 'jenkins'
//         DOCKER_HUB_USERNAME = 'geunwook'
//         DOCKER_HUB_PASSWORD = 'az5483az!!'
//         FRONTEND_DIR = 'frontend'
//         BACKEND_DIR = 'backend'
//         JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
//         PATH = "${JAVA_HOME}/bin:${env.PATH}"
//     }

//     stages {
//         stage('Print Branch Info') {
//             steps {
//                 script {
//                     echo "Current GIT_BRANCH: ${env.GIT_BRANCH}"
//                     def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
//                     echo "Current branch: ${branch}"
//                     echo "REMOTE_SERVER: ${env.REMOTE_SERVER}"
//                 }
//             }
//         }

//         stage('Checkout') {
//             steps {
//                 script {
//                     git branch: 'infra-test', credentialsId: CREDENTIALS_ID, url: GIT_REPO_URL
//                 }
//             }
//         }

//         stage('List Directory') {
//             steps {
//                 sh 'mkdir -p frontend'
//                 sh 'mkdir -p backend'
//                 sh 'ls -l'
//                 sh 'ls -l frontend'
//                 sh 'ls -l backend'
//             }
//         }

//         stage('Check JAVA_HOME') {
//             steps {
//                 script {
//                     sh 'echo $JAVA_HOME'
//                     sh 'java -version'
//                 }
//             }
//         }

//         stage('Build Docker Images') {
//             steps {
//                 script {
//                     // Ensure JAVA_HOME is set before building images
//                     sh 'echo "JAVA_HOME is set to: $JAVA_HOME"'
//                     sh 'echo "PATH is set to: $PATH"'

//                     // Build frontend Docker image
//                     dir(FRONTEND_DIR) {
//                         sh 'docker build -t geunwook/flutter2:latest -f Dockerfile .'
//                     }
                    
//                     // Build backend Docker image
//                     dir(BACKEND_DIR) {
//                         // Ensure gradlew is present and executable
//                         if (fileExists('gradlew')) {
//                             sh 'chmod +x gradlew'
//                         } else {
//                             echo "gradlew not found, generating..."
//                             sh 'gradle wrapper'
//                             sh 'chmod +x gradlew'
//                         }

//                         // Run Gradle build with JAVA_HOME explicitly set
//                         sh '''
//                         export JAVA_HOME=${JAVA_HOME}
//                         ./gradlew clean build
//                         '''
//                         sh 'docker build -t geunwook/backend:latest .'
//                     }
//                 }
//             }
//         }

//         stage('Push Docker Images to Docker Hub') {
//             steps {
//                 script {
//                     // Login and push to Docker Hub
//                     sh '''
//                     echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
//                     docker push geunwook/flutter2:latest
//                     docker push geunwook/backend:latest
//                     '''
//                 }
//             }
//         }

//         stage('Deploy to Remote Server') {
//             steps {
//                 script {
//                     sshagent([SSH_CREDENTIALS_ID]) {
//                         sh '''
//                         # SSH into remote server, pull Docker images and restart containers
//                         ssh -o StrictHostKeyChecking=no ubuntu@${REMOTE_SERVER} << EOF
//                             docker pull geunwook/flutter2:latest
//                             docker pull geunwook/backend:latest
//                             cd /home/ubuntu/S11P31A102
//                             docker-compose -f ${DOCKER_COMPOSE_FILE} down
//                             docker-compose -f ${DOCKER_COMPOSE_FILE} up -d
// EOF
//                         '''
//                     }
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             cleanWs()
//         }
//     }
// }
