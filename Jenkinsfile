def CONTAINER_NAME="kenantest"
def CONTAINER_TAG="latest4"
def DOCKER_HUB_USER="157584635219.dkr.ecr.eu-west-1.amazonaws.com"
def HTTP_PORT="8090"

node {	


    stage('Initialize'){
	def dockerHome = tool 'myDocker'
		
	env.PATH = "${dockerHome}/bin:${env.PATH}"
    }

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }
	
    stage('Check Docker') {

	checkDocker()
    }
	
    stage("Image Prune"){
        imagePrune(CONTAINER_NAME)
    }

    stage('Image Build'){
        imageBuild(CONTAINER_NAME, CONTAINER_TAG)
    }

    stage('Push to Docker Registry'){
		sh "docker images"
	
        docker.withRegistry("https://${DOCKER_HUB_USER}", 'ecr:eu-west-1:AWS_Credential') {
			docker.image(CONTAINER_NAME).push(CONTAINER_TAG);
        }
    }
	
    stage('Run App'){
        runApp(CONTAINER_NAME, CONTAINER_TAG, DOCKER_HUB_USER, HTTP_PORT)
    }
}

def checkDocker(){
    try {
	echo "$PATH"
        sh "docker version"
	sh "docker ps"
	sh "docker images"
    } catch(error){}
}

def imagePrune(containerName){
    try {
	sh "docker image prune -f"
        sh "docker stop $containerName"
    } catch(error){}
}

def imageBuild(containerName, tag){
    sh "docker build -t $containerName:$tag  -t $containerName --pull --no-cache ."
    echo "Image build complete"
}

def pushToImage(containerName, tag, dockerUser, dockerPassword){
    sh "`aws ecr get-login --no-include-email --region eu-west-1`"
    sh "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
    sh "docker push $dockerUser/$containerName:$tag"
    echo "Image push complete"
}

def runApp(containerName, tag, dockerHubUser, httpPort){
    docker.withRegistry("https://${dockerHubUser}", 'ecr:eu-west-1:AWS_Credential') {
		
		sh "docker run -d --rm -p $httpPort:$httpPort --name $containerName $dockerHubUser/$containerName"
    }
	
    echo "Application started on port: ${httpPort} (http)"
}
